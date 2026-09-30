import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/data/db/app_database.dart';
import 'package:kerfplan/data/repositories/drift_project_repository.dart';
import 'package:kerfplan/data/repositories/drift_part_repository.dart';
import 'package:kerfplan/domain/models/project_metadata.dart';
import 'package:kerfplan/domain/models/part_input.dart';
import 'package:kerfplan/domain/repositories/project_repository.dart';
import 'package:kerfplan/domain/repositories/part_repository.dart';
import 'package:kerfplan/domain/units/length.dart';

void main() {
  late AppDatabase db;
  late DriftProjectRepository projects;
  late DriftPartRepository parts;
  late DateTime now;
  late String projectId;
  PartInput input({String mm = '1800', int quantity = 6, String? name}) =>
      PartInput(
        length: Length.fromMillimeters(mm),
        quantity: quantity,
        name: name,
      );

  setUp(() async {
    now = DateTime.utc(2026, 9, 23, 12);
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    projects = DriftProjectRepository(db, now: () => now);
    parts = DriftPartRepository(db, now: () => now);
    projectId = (await projects.createProject(ProjectMetadata(name: 'Frame')))
        .id;
  });
  tearDown(() => db.close());
  Future<int> revision() async =>
      (await projects.getProject(projectId))!.revision;

  test('create stores exact ticks, quantity and trimmed name; each insert increments once', () async {
    final original = (await projects.getProject(projectId))!;
    final first = await parts.createPart(projectId, input(name: ' Upright '));
    final stored = await db.select(db.partLines).getSingle();
    expect(first.length.ticks, 18000000);
    expect(stored.lengthTicks, 18000000);
    expect(stored.quantity, 6);
    expect(first.name, 'Upright');
    expect(first.sortOrder, 0);
    expect(first.createdAt.isUtc, isTrue);
    expect(await revision(), 1);
    expect(
      (await projects.getProject(projectId))!.updatedAt
          .isAfter(original.updatedAt),
      isTrue,
    );
    final second = await parts.createPart(
      projectId,
      input(quantity: 9999, name: '  '),
    );
    expect(second.quantity, 9999);
    expect(second.name, isNull);
    expect(second.sortOrder, 1);
    expect(await revision(), 2);
  });

  test(
    'length, quantity, and combined updates each increment exactly once',
    () async {
      final part = await parts.createPart(projectId, input());
      await parts.updatePart(part.id, input(mm: '3000'));
      expect(await revision(), 2);
      expect((await parts.getPart(part.id))!.length.ticks, 30000000);
      await parts.updatePart(part.id, input(mm: '3000', quantity: 5));
      expect(await revision(), 3);
      await parts.updatePart(part.id, input(mm: '2000', quantity: 7));
      expect(await revision(), 4);
      final updated = (await parts.getPart(part.id))!;
      expect(updated.createdAt, part.createdAt);
      expect(updated.sortOrder, part.sortOrder);
      expect(updated.updatedAt.isAfter(part.updatedAt), isTrue);
    },
  );

  test(
    'name-only updates timestamps without revision; identical saves do nothing',
    () async {
      final part = await parts.createPart(projectId, input(name: 'Warehouse'));
      final before = (await projects.getProject(projectId))!;
      await parts.updatePart(part.id, input(name: ' Rack A '));
      final changed = (await parts.getPart(part.id))!;
      final project = (await projects.getProject(projectId))!;
      expect(changed.name, 'Rack A');
      expect(changed.updatedAt.isAfter(part.updatedAt), isTrue);
      expect(project.updatedAt.isAfter(before.updatedAt), isTrue);
      expect(project.revision, 1);
      await parts.updatePart(part.id, input(name: 'Rack A'));
      expect((await parts.getPart(part.id))!.updatedAt, changed.updatedAt);
      expect(
        (await projects.getProject(projectId))!.updatedAt,
        project.updatedAt,
      );
      expect(await revision(), 1);
    },
  );

  test(
    'duplicate appends a fresh row with same values and revision plus one',
    () async {
      final source = await parts.createPart(
        projectId,
        input(name: 'Warehouse'),
      );
      now = now.add(const Duration(hours: 1));
      final copy = await parts.duplicatePart(source.id);
      expect(copy.id, isNot(source.id));
      expect(copy.projectId, source.projectId);
      expect(copy.length, source.length);
      expect(copy.quantity, source.quantity);
      expect(copy.name, source.name);
      expect(copy.sortOrder, 1);
      expect(copy.createdAt, now);
      expect(copy.updatedAt, now);
      expect(await revision(), 2);
    },
  );

  test(
    'delete removes only its row and increments revision exactly once',
    () async {
      final part = await parts.createPart(projectId, input());
      await parts.deletePart(part.id);
      expect(await parts.getPart(part.id), isNull);
      expect(await revision(), 2);
      await expectLater(
        parts.deletePart(part.id),
        throwsA(isA<PartNotFoundException>()),
      );
      expect(await revision(), 2);
    },
  );

  test(
    'watch ordering is sortOrder, createdAt, id and scopes rows to project',
    () async {
      for (final sample in [
        ('c', 1, 0),
        ('b', 0, 1),
        ('a', 0, 0),
        ('d', 0, 0),
      ]) {
        await db
            .into(db.partLines)
            .insert(
              PartLinesCompanion.insert(
                id: sample.$1,
                projectId: projectId,
                lengthTicks: 10000,
                quantity: 1,
                sortOrder: Value(sample.$2),
                createdAt: now.add(Duration(seconds: sample.$3)),
                updatedAt: now,
              ),
            );
      }
      final other = await projects.createProject(
        ProjectMetadata(name: 'Other'),
      );
      await parts.createPart(other.id, input());
      expect((await parts.watchParts(projectId).first).map((row) => row.id), [
        'a',
        'd',
        'b',
        'c',
      ]);
      final emission = expectLater(
        parts.watchParts(projectId),
        emitsThrough(predicate<List<dynamic>>((rows) => rows.length == 5)),
      );
      await parts.createPart(projectId, input());
      await emission;
    },
  );

  test('failed project mutation rolls back every part operation', () async {
    final part = await parts.createPart(projectId, input());
    await db.customStatement(
      "CREATE TRIGGER reject_touch BEFORE UPDATE ON projects BEGIN SELECT RAISE(ABORT, 'test'); END",
    );
    final operations = <Future<void> Function()>[
      () async {
        await parts.createPart(projectId, input());
      },
      () => parts.updatePart(part.id, input(mm: '3000')),
      () async {
        await parts.duplicatePart(part.id);
      },
      () => parts.deletePart(part.id),
    ];
    for (final operation in operations) {
      await expectLater(operation(), throwsA(isA<SqliteException>()));
      expect(await revision(), 1);
      expect(await db.select(db.partLines).get(), hasLength(1));
      expect((await parts.getPart(part.id))!.length.ticks, 18000000);
    }
  });

  test('deleted project and part IDs fail safely; no orphan rows', () async {
    final part = await parts.createPart(projectId, input());
    await projects.deleteProject(projectId);
    await expectLater(
      parts.createPart(projectId, input()),
      throwsA(isA<ProjectNotFoundException>()),
    );
    await expectLater(
      parts.updatePart(part.id, input()),
      throwsA(isA<PartNotFoundException>()),
    );
    await expectLater(
      parts.duplicatePart(part.id),
      throwsA(isA<PartNotFoundException>()),
    );
    expect(await db.select(db.partLines).get(), isEmpty);
  });

  test('equal lengths remain separate named groups and concurrent revisions serialize', () async {
    await Future.wait([
      parts.createPart(projectId, input(name: 'Frame side')),
      parts.createPart(projectId, input(name: 'Shelf')),
    ]);
    expect(await revision(), 2);
    final rows = await parts.watchParts(projectId).first;
    expect(rows.map((row) => row.sortOrder), [0, 1]);
    expect(rows.map((row) => row.name), containsAll(['Frame side', 'Shelf']));
  });

  test('part persistence survives file database close/reopen', () async {
    final directory = await Directory.systemTemp.createTemp('kerfplan-parts-');
    addTearDown(() => directory.delete(recursive: true));
    await db.close();
    final file = File('${directory.path}/parts.sqlite');
    db = AppDatabase.withExecutor(NativeDatabase(file));
    projects = DriftProjectRepository(db);
    parts = DriftPartRepository(db);
    projectId = (await projects.createProject(
      ProjectMetadata(name: 'Persistent'),
    )).id;
    final part = await parts.createPart(projectId, input(name: 'Upright'));
    await db.close();
    db = AppDatabase.withExecutor(NativeDatabase(file));
    projects = DriftProjectRepository(db);
    parts = DriftPartRepository(db);
    expect(await revision(), 1);
    final restored = (await parts.getPart(part.id))!;
    expect(restored.length.ticks, 18000000);
    expect(restored.name, 'Upright');
    expect(restored.quantity, 6);
    expect((await parts.watchParts(projectId).first).single.id, part.id);
    await db.close();
    db = AppDatabase.withExecutor(NativeDatabase.memory());
  });
}
