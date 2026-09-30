import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/part_input.dart';
import '../../domain/models/part_item.dart';
import '../../domain/repositories/part_repository.dart';
import '../../domain/units/length.dart';
import '../db/app_database.dart';
import 'project_mutation.dart';

final class DriftPartRepository implements PartRepository {
  DriftPartRepository(this._db, {DateTime Function()? now})
    : _now = now ?? DateTime.now;
  final AppDatabase _db;
  final DateTime Function() _now;
  final Uuid _uuid = const Uuid();

  PartItem _map(PartLine row) => PartItem(
    id: row.id,
    projectId: row.projectId,
    length: Length.fromTicks(row.lengthTicks),
    quantity: row.quantity,
    name: row.name,
    sortOrder: row.sortOrder,
    createdAt: row.createdAt.toUtc(),
    updatedAt: row.updatedAt.toUtc(),
  );

  SimpleSelectStatement<$PartLinesTable, PartLine> _byId(String id) =>
      _db.select(_db.partLines)..where((row) => row.id.equals(id));

  Future<PartLine> _require(String id) async =>
      await _byId(id).getSingleOrNull() ?? (throw PartNotFoundException(id));

  SimpleSelectStatement<$PartLinesTable, PartLine> _forProject(
    String projectId,
  ) => _db.select(_db.partLines)
    ..where((row) => row.projectId.equals(projectId))
    ..orderBy([
      (row) => OrderingTerm.asc(row.sortOrder),
      (row) => OrderingTerm.asc(row.createdAt),
      (row) => OrderingTerm.asc(row.id),
    ]);

  @override
  Stream<List<PartItem>> watchParts(String projectId) =>
      _forProject(projectId)
          .watch()
          .map((rows) => rows.map(_map).toList(growable: false));

  @override
  Future<List<PartItem>> getPartLines(String projectId) async =>
      (await _forProject(projectId).get()).map(_map).toList(growable: false);

  @override
  Future<PartItem?> getPart(String id) async {
    final row = await _byId(id).getSingleOrNull();
    return row == null ? null : _map(row);
  }

  Future<int> _appendOrder(String projectId) async {
    final last =
        await (_db.select(_db.partLines)
              ..where((row) => row.projectId.equals(projectId))
              ..orderBy([(row) => OrderingTerm.desc(row.sortOrder)])
              ..limit(1))
            .getSingleOrNull();
    if (last == null) return 0;
    if (last.sortOrder == 0x7FFFFFFFFFFFFFFF) {
      throw StateError('Part order overflow');
    }
    return last.sortOrder + 1;
  }

  Future<PartItem> _insert(String projectId, PartInput input) async {
    final id = _uuid.v4();
    final now = databaseTimestamp(_now());
    final order = await _appendOrder(projectId);
    await _db
        .into(_db.partLines)
        .insert(
          PartLinesCompanion.insert(
            id: id,
            projectId: projectId,
            lengthTicks: input.length.ticks,
            quantity: input.quantity,
            name: Value(input.name),
            sortOrder: Value(order),
            createdAt: now,
            updatedAt: now,
          ),
        );
    return _map(await _require(id));
  }

  @override
  Future<PartItem> createPart(String projectId, PartInput input) =>
      _db.transaction(() async {
        final project = await requireProject(_db, projectId);
        final part = await _insert(projectId, input);
        await touchProject(_db, project, _now());
        return part;
      });

  @override
  Future<void> updatePart(
    String id,
    PartInput input,
  ) => _db.transaction(() async {
    final source = await _require(id);
    final project = await requireProject(_db, source.projectId);
    final changedInput =
        source.lengthTicks != input.length.ticks ||
        source.quantity != input.quantity;
    if (!changedInput && source.name == input.name) return;
    await (_db.update(_db.partLines)..where((row) => row.id.equals(id))).write(
      PartLinesCompanion(
        lengthTicks: Value(input.length.ticks),
        quantity: Value(input.quantity),
        name: Value(input.name),
        updatedAt: Value(nextDatabaseTimestamp(_now(), source.updatedAt)),
      ),
    );
    await touchProject(_db, project, _now(), affectsOptimization: changedInput);
  });

  @override
  Future<PartItem> duplicatePart(String id) => _db.transaction(() async {
    final source = _map(await _require(id));
    final project = await requireProject(_db, source.projectId);
    final copy = await _insert(
      source.projectId,
      PartInput(
        length: source.length,
        quantity: source.quantity,
        name: source.name,
      ),
    );
    await touchProject(_db, project, _now());
    return copy;
  });

  @override
  Future<void> deletePart(String id) => _db.transaction(() async {
    final source = await _require(id);
    final project = await requireProject(_db, source.projectId);
    await (_db.delete(_db.partLines)..where((row) => row.id.equals(id))).go();
    await touchProject(_db, project, _now());
  });
}
