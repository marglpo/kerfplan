import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/cut_project.dart';
import '../../domain/models/cut_settings_input.dart';
import '../../domain/models/project_copy_name.dart';
import '../../domain/models/project_defaults.dart';
import '../../domain/models/project_metadata.dart';
import '../../domain/repositories/project_repository.dart';
import '../db/app_database.dart';
import 'project_mapping.dart';
import 'project_mutation.dart';
import '../../domain/models/inventory_mode.dart';
import '../../domain/units/length.dart';

final class DriftProjectRepository implements ProjectRepository {
  DriftProjectRepository(this._db, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _now;
  final Uuid _uuid = const Uuid();

  // Schema v1 stores Unix seconds. Normalize return values to the same precision.
  DateTime _timestamp() => DateTime.fromMillisecondsSinceEpoch(
    (_now().toUtc().millisecondsSinceEpoch ~/ 1000) * 1000,
    isUtc: true,
  );

  SimpleSelectStatement<$ProjectsTable, Project> _byId(String id) =>
      _db.select(_db.projects)..where((row) => row.id.equals(id));

  @override
  Stream<List<CutProject>> watchProjects() =>
      (_db.select(_db.projects)..orderBy([
            (row) => OrderingTerm.desc(row.updatedAt),
            (row) => OrderingTerm.desc(row.createdAt),
            (row) => OrderingTerm.asc(row.id),
          ]))
          .watch()
          .map((rows) => rows.map(mapProject).toList(growable: false));

  @override
  Stream<CutProject?> watchProject(String id) =>
      _byId(id)
          .watchSingleOrNull()
          .map((row) => row == null ? null : mapProject(row));

  @override
  Future<CutProject?> getProject(String id) async {
    final row = await _byId(id).getSingleOrNull();
    return row == null ? null : mapProject(row);
  }

  Future<Project> _requireProject(String id) async =>
      await _byId(id).getSingleOrNull() ?? (throw ProjectNotFoundException(id));

  @override
  Future<CutProject> createProject(
    ProjectMetadata metadata, {
    ProjectCreationDefaults? defaults,
  }) async {
    final initial = defaults ?? ProjectDefaults.creation;
    final timestamp = _timestamp();
    final id = _uuid.v4();
    await _db
        .into(_db.projects)
        .insert(
          ProjectsCompanion.insert(
            id: id,
            name: metadata.name,
            material: Value(metadata.material),
            note: Value(metadata.note),
            inventoryMode: ProjectDefaults.inventoryMode.storageValue,
            displayUnit: initial.displayUnit.storageValue,
            kerfTicks: initial.kerf.ticks,
            endTrimTicks: ProjectDefaults.endTrim.ticks,
            minReusableTicks: initial.minReusable.ticks,
            buyStockLengthTicks: Value(ProjectDefaults.buyStockLength?.ticks),
            revision: const Value(ProjectDefaults.revision),
            lastRunId: const Value(ProjectDefaults.lastRunId),
            createdAt: timestamp,
            updatedAt: timestamp,
          ),
        );
    return mapProject(await _requireProject(id));
  }

  @override
  Future<void> updateProjectMetadata(String id, ProjectMetadata metadata) =>
      _db.transaction(() async {
        final source = await _requireProject(id);
        final now = _timestamp();
        // Even edits within the same stored second must advance updatedAt.
        final updated = now.isAfter(source.updatedAt)
            ? now
            : source.updatedAt.toUtc().add(const Duration(seconds: 1));
        await (_db.update(
          _db.projects,
        )..where((row) => row.id.equals(id))).write(
          ProjectsCompanion(
            name: Value(metadata.name),
            material: Value(metadata.material),
            note: Value(metadata.note),
            updatedAt: Value(updated),
          ),
        );
      });

  @override
  Future<CutProject> duplicateProject(String id, {required String copyLabel}) =>
      _db.transaction(() async {
        final source = await _requireProject(id);
        // Validate persisted configuration before copying anything.
        mapProject(source);
        final names = await (_db.selectOnly(
          _db.projects,
        )..addColumns([_db.projects.name])).get();
        final name = projectCopyName(
          source.name,
          copyLabel,
          names.map((row) => row.read(_db.projects.name)!).toSet(),
        );
        final newId = _uuid.v4();
        final timestamp = _timestamp();
        await _db
            .into(_db.projects)
            .insert(
              source
                  .toCompanion(false)
                  .copyWith(
                    id: Value(newId),
                    name: Value(name),
                    revision: const Value(0),
                    lastRunId: const Value(null),
                    createdAt: Value(timestamp),
                    updatedAt: Value(timestamp),
                  ),
            );
        final stocks = await (_db.select(
          _db.stockLines,
        )..where((row) => row.projectId.equals(id))).get();
        final parts = await (_db.select(
          _db.partLines,
        )..where((row) => row.projectId.equals(id))).get();
        await _db.batch((batch) {
          batch.insertAll(
            _db.stockLines,
            stocks.map(
              (row) => row
                  .toCompanion(false)
                  .copyWith(
                    id: Value(_uuid.v4()),
                    projectId: Value(newId),
                    createdAt: Value(timestamp),
                    updatedAt: Value(timestamp),
                  ),
            ),
          );
          batch.insertAll(
            _db.partLines,
            parts.map(
              (row) => row
                  .toCompanion(false)
                  .copyWith(
                    id: Value(_uuid.v4()),
                    projectId: Value(newId),
                    createdAt: Value(timestamp),
                    updatedAt: Value(timestamp),
                  ),
            ),
          );
        });
        return mapProject(await _requireProject(newId));
      });

  @override
  Future<void> deleteProject(String id) async {
    await (_db.delete(_db.projects)..where((row) => row.id.equals(id))).go();
  }

  @override
  Future<void> updateCutSettings(String id, CutSettingsInput settings) =>
      _db.transaction(() async {
        final project = await _requireProject(id);
        final affectsOptimization =
            project.kerfTicks != settings.kerf.ticks ||
            project.endTrimTicks != settings.endTrim.ticks ||
            project.minReusableTicks != settings.minReusable.ticks;
        if (!affectsOptimization &&
            project.displayUnit == settings.displayUnit.storageValue) {
          return;
        }
        await (_db.update(
          _db.projects,
        )..where((row) => row.id.equals(id))).write(
          ProjectsCompanion(
            displayUnit: Value(settings.displayUnit.storageValue),
            kerfTicks: Value(settings.kerf.ticks),
            endTrimTicks: Value(settings.endTrim.ticks),
            minReusableTicks: Value(settings.minReusable.ticks),
          ),
        );
        await touchProject(
          _db,
          project,
          _now(),
          affectsOptimization: affectsOptimization,
        );
      });

  @override
  Future<void> setInventoryMode(String id, InventoryMode mode) =>
      _db.transaction(() async {
        final project = await _requireProject(id);
        if (project.inventoryMode == mode.storageValue) return;
        await (_db.update(_db.projects)..where((row) => row.id.equals(id)))
            .write(ProjectsCompanion(inventoryMode: Value(mode.storageValue)));
        await touchProject(_db, project, _now());
      });

  @override
  Future<void> setBuyStockLength(String id, Length length) => _db.transaction(
    () async {
      if (length.ticks <= 0) throw ArgumentError.value(length.ticks, 'length');
      final project = await _requireProject(id);
      if (project.buyStockLengthTicks == length.ticks) return;
      await (_db.update(_db.projects)..where((row) => row.id.equals(id))).write(
        ProjectsCompanion(buyStockLengthTicks: Value(length.ticks)),
      );
      await touchProject(_db, project, _now());
    },
  );
}
