import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/data/db/app_database.dart';
import 'package:kerfplan/data/repositories/drift_project_repository.dart';
import 'package:kerfplan/domain/models/inventory_mode.dart';
import 'package:kerfplan/domain/models/project_metadata.dart';
import 'package:kerfplan/domain/repositories/project_repository.dart';
import 'package:kerfplan/domain/units/display_unit.dart';

void main() {
  late AppDatabase db;
  late DriftProjectRepository repository;
  late DateTime now;

  setUp(() {
    now = DateTime.utc(2026, 9, 23, 12);
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    repository = DriftProjectRepository(db, now: () => now);
  });
  tearDown(() => db.close());

  Future<void> addChildren(String id) async {
    await db
        .into(db.stockLines)
        .insert(
          StockLinesCompanion.insert(
            id: 'stock-original',
            projectId: id,
            lengthTicks: 60000000,
            quantity: 2,
            label: const Value('Steel'),
            sortOrder: const Value(4),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await db
        .into(db.partLines)
        .insert(
          PartLinesCompanion.insert(
            id: 'part-original',
            projectId: id,
            name: const Value('Leg'),
            lengthTicks: 12500000,
            quantity: 4,
            sortOrder: const Value(3),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  test('creation persists exact defaults, UUID, normalized optional fields and UTC', () async {
    final project = await repository.createProject(
      ProjectMetadata(name: ' Frame ', material: ' ', note: '\n'),
    );
    final stored = (await repository.getProject(project.id))!;
    expect(stored.name, 'Frame');
    expect(
      stored.id,
      matches(
        RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        ),
      ),
    );
    expect(stored.material, isNull);
    expect(stored.note, isNull);
    expect(stored.inventoryMode, InventoryMode.fixed);
    expect(stored.displayUnit, DisplayUnit.mm);
    expect(stored.kerf.ticks, 30000);
    expect(stored.endTrim.ticks, 0);
    expect(stored.minReusable.ticks, 1000000);
    expect(stored.buyStockLength, isNull);
    expect(stored.revision, 0);
    expect(stored.lastRunId, isNull);
    expect(stored.createdAt, now);
    expect(stored.updatedAt, now);
    expect(stored.createdAt.isUtc, isTrue);
    expect(stored.updatedAt.isUtc, isTrue);
    final row = await db.select(db.projects).getSingle();
    expect(row.inventoryMode, 'fixed');
    expect(row.displayUnit, 'mm');
  });

  test(
    'metadata updates preserve all calculation state, timestamps and children',
    () async {
      final original = await repository.createProject(
        ProjectMetadata(name: 'Old'),
      );
      await (db.update(
        db.projects,
      )..where((row) => row.id.equals(original.id))).write(
        const ProjectsCompanion(
          inventoryMode: Value('buy'),
          displayUnit: Value('inch'),
          revision: Value(7),
          lastRunId: Value('run-7'),
          kerfTicks: Value(15875),
          endTrimTicks: Value(20000),
          minReusableTicks: Value(3000000),
          buyStockLengthTicks: Value(60000000),
        ),
      );
      await addChildren(original.id);
      now = now.add(const Duration(hours: 1));
      await repository.updateProjectMetadata(
        original.id,
        ProjectMetadata(name: ' New ', material: ' Steel ', note: ' Wall '),
      );
      final updated = (await repository.getProject(original.id))!;
      expect(updated.id, original.id);
      expect(updated.name, 'New');
      expect(updated.material, 'Steel');
      expect(updated.note, 'Wall');
      expect(updated.createdAt, original.createdAt);
      expect(updated.updatedAt, now);
      expect(updated.revision, 7);
      expect(updated.lastRunId, 'run-7');
      expect(updated.inventoryMode, InventoryMode.buy);
      expect(updated.displayUnit, DisplayUnit.inch);
      expect(updated.kerf.ticks, 15875);
      expect(updated.endTrim.ticks, 20000);
      expect(updated.minReusable.ticks, 3000000);
      expect(updated.buyStockLength!.ticks, 60000000);
      expect((await db.select(db.stockLines).getSingle()).id, 'stock-original');
      expect(
        (await db.select(db.partLines).getSingle()).updatedAt.toUtc(),
        original.createdAt,
      );
      await repository.updateProjectMetadata(
        original.id,
        ProjectMetadata(name: 'New', material: ' ', note: ' '),
      );
      expect((await repository.getProject(original.id))!.material, isNull);
      expect((await repository.getProject(original.id))!.note, isNull);
    },
  );

  test(
    'same-second edits still advance the stored updated timestamp',
    () async {
      final project = await repository.createProject(
        ProjectMetadata(name: 'Before'),
      );
      await repository.updateProjectMetadata(
        project.id,
        ProjectMetadata(name: 'After'),
      );
      expect(
        (await repository.getProject(project.id))!.updatedAt
            .isAfter(project.updatedAt),
        isTrue,
      );
    },
  );

  test(
    'project stream reacts to writes and sorts by updated, created, then id',
    () async {
      final first = await repository.createProject(
        ProjectMetadata(name: 'First'),
      );
      now = now.add(const Duration(seconds: 2));
      final second = await repository.createProject(
        ProjectMetadata(name: 'Second'),
      );
      expect((await repository.watchProjects().first).map((p) => p.id), [
        second.id,
        first.id,
      ]);
      final observed = expectLater(
        repository.watchProjects(),
        emitsThrough(
          predicate<List<dynamic>>(
            (items) => items.isNotEmpty && items.first.id == first.id,
          ),
        ),
      );
      now = now.add(const Duration(seconds: 2));
      await repository.updateProjectMetadata(
        first.id,
        ProjectMetadata(name: 'Updated first'),
      );
      await observed;
      // Equal updatedAt falls back to createdAt.
      await (db.update(db.projects)..where((row) => row.id.equals(second.id)))
          .write(ProjectsCompanion(updatedAt: Value(now)));
      expect((await repository.watchProjects().first).map((p) => p.id), [
        second.id,
        first.id,
      ]);
    },
  );

  test(
    'duplicate copies configuration and children with fresh IDs and timestamps',
    () async {
      final source = await repository.createProject(
        ProjectMetadata(name: 'Frame', material: 'Steel', note: 'Wall'),
      );
      await (db.update(
        db.projects,
      )..where((row) => row.id.equals(source.id))).write(
        const ProjectsCompanion(
          inventoryMode: Value('buy'),
          displayUnit: Value('ftIn'),
          kerfTicks: Value(15875),
          endTrimTicks: Value(20000),
          minReusableTicks: Value(4000000),
          buyStockLengthTicks: Value(70000000),
          revision: Value(8),
          lastRunId: Value('run-8'),
        ),
      );
      await addChildren(source.id);
      now = now.add(const Duration(days: 1));
      final copy = await repository.duplicateProject(
        source.id,
        copyLabel: 'Copy',
      );
      expect(copy.id, isNot(source.id));
      expect(copy.name, 'Frame Copy');
      expect(copy.material, 'Steel');
      expect(copy.note, 'Wall');
      expect(copy.inventoryMode, InventoryMode.buy);
      expect(copy.displayUnit, DisplayUnit.ftIn);
      expect(copy.kerf.ticks, 15875);
      expect(copy.endTrim.ticks, 20000);
      expect(copy.minReusable.ticks, 4000000);
      expect(copy.buyStockLength!.ticks, 70000000);
      expect(copy.revision, 0);
      expect(copy.lastRunId, isNull);
      expect(copy.createdAt, now);
      expect(copy.updatedAt, now);
      expect((await repository.getProject(source.id))!.lastRunId, 'run-8');
      final stock = await (db.select(
        db.stockLines,
      )..where((row) => row.projectId.equals(copy.id))).getSingle();
      expect(stock.id, isNot('stock-original'));
      expect(stock.projectId, copy.id);
      expect(stock.lengthTicks, 60000000);
      expect(stock.quantity, 2);
      expect(stock.label, 'Steel');
      expect(stock.sortOrder, 4);
      expect(stock.createdAt.toUtc(), now);
      expect(stock.updatedAt.toUtc(), now);
      final part = await (db.select(
        db.partLines,
      )..where((row) => row.projectId.equals(copy.id))).getSingle();
      expect(part.id, isNot('part-original'));
      expect(part.projectId, copy.id);
      expect(part.lengthTicks, 12500000);
      expect(part.quantity, 4);
      expect(part.name, 'Leg');
      expect(part.sortOrder, 3);
      expect(part.createdAt.toUtc(), now);
      expect(part.updatedAt.toUtc(), now);
    },
  );

  test('concurrent duplicates select deterministic available names', () async {
    final source = await repository.createProject(
      ProjectMetadata(name: 'Frame'),
    );
    await repository.createProject(ProjectMetadata(name: 'Frame Copy'));
    final copies = await Future.wait([
      repository.duplicateProject(source.id, copyLabel: 'Copy'),
      repository.duplicateProject(source.id, copyLabel: 'Copy'),
    ]);
    expect(copies.map((p) => p.name).toSet(), {'Frame Copy 2', 'Frame Copy 3'});
  });

  test('failed child duplication rolls back the entire transaction', () async {
    final source = await repository.createProject(
      ProjectMetadata(name: 'Frame'),
    );
    await addChildren(source.id);
    await db.customStatement(
      "CREATE TRIGGER reject_copied_parts BEFORE INSERT ON part_lines WHEN NEW.id != 'part-original' BEGIN SELECT RAISE(ABORT, 'test failure'); END",
    );
    await expectLater(
      repository.duplicateProject(source.id, copyLabel: 'Copy'),
      throwsA(isA<SqliteException>()),
    );
    expect(await db.select(db.projects).get(), hasLength(1));
    expect(await db.select(db.stockLines).get(), hasLength(1));
    expect(await db.select(db.partLines).get(), hasLength(1));
  });

  test(
    'deletion cascades children and the watched project becomes null',
    () async {
      final source = await repository.createProject(
        ProjectMetadata(name: 'Frame'),
      );
      await addChildren(source.id);
      expect((await repository.watchProject(source.id).first)!.id, source.id);
      final deleted = expectLater(
        repository.watchProject(source.id),
        emitsThrough(isNull),
      );
      await repository.deleteProject(source.id);
      await deleted;
      expect(await repository.getProject(source.id), isNull);
      expect(await db.select(db.stockLines).get(), isEmpty);
      expect(await db.select(db.partLines).get(), isEmpty);
    },
  );

  test(
    'missing projects and unknown stored enum values fail clearly',
    () async {
      expect(await repository.getProject('missing'), isNull);
      await expectLater(
        repository.updateProjectMetadata(
          'missing',
          ProjectMetadata(name: 'Job'),
        ),
        throwsA(isA<ProjectNotFoundException>()),
      );
      await expectLater(
        repository.duplicateProject('missing', copyLabel: 'Copy'),
        throwsA(isA<ProjectNotFoundException>()),
      );
      final source = await repository.createProject(
        ProjectMetadata(name: 'Frame'),
      );
      await (db.update(db.projects)..where((row) => row.id.equals(source.id)))
          .write(const ProjectsCompanion(displayUnit: Value('unknown')));
      await expectLater(
        repository.getProject(source.id),
        throwsFormatException,
      );
    },
  );

  test(
    'projects persist after closing and reopening a file database',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'kerfplan-repository-',
      );
      addTearDown(() => directory.delete(recursive: true));
      await db.close();
      final file = File('${directory.path}/projects.sqlite');
      db = AppDatabase.withExecutor(NativeDatabase(file));
      repository = DriftProjectRepository(db);
      final project = await repository.createProject(
        ProjectMetadata(name: 'Persistent frame'),
      );
      await db.close();
      db = AppDatabase.withExecutor(NativeDatabase(file));
      repository = DriftProjectRepository(db);
      expect(
        (await repository.getProject(project.id))!.name,
        'Persistent frame',
      );
      expect((await repository.watchProjects().first).single.id, project.id);
      // Close before removing the directory on Windows.
      await db.close();
      db = AppDatabase.withExecutor(NativeDatabase.memory());
    },
  );
}
