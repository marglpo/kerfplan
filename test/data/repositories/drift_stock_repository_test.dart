import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/data/db/app_database.dart';
import 'package:kerfplan/data/repositories/drift_project_repository.dart';
import 'package:kerfplan/data/repositories/drift_stock_repository.dart';
import 'package:kerfplan/domain/models/inventory_mode.dart';
import 'package:kerfplan/domain/models/project_metadata.dart';
import 'package:kerfplan/domain/models/stock_input.dart';
import 'package:kerfplan/domain/repositories/project_repository.dart';
import 'package:kerfplan/domain/repositories/stock_repository.dart';
import 'package:kerfplan/domain/units/length.dart';

void main() {
  late AppDatabase db;
  late DriftProjectRepository projects;
  late DriftStockRepository stocks;
  late DateTime now;
  late String projectId;
  StockInput input({String mm = '6000', int quantity = 10, String? label}) =>
      StockInput(
        length: Length.fromMillimeters(mm),
        quantity: quantity,
        label: label,
      );

  setUp(() async {
    now = DateTime.utc(2026, 9, 23, 12);
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    projects = DriftProjectRepository(db, now: () => now);
    stocks = DriftStockRepository(db, now: () => now);
    projectId = (await projects.createProject(ProjectMetadata(name: 'Frame')))
        .id;
  });
  tearDown(() => db.close());
  Future<int> revision() async =>
      (await projects.getProject(projectId))!.revision;

  test('create stores exact ticks, quantity and blank label; each insert increments once', () async {
    final original = (await projects.getProject(projectId))!;
    final first = await stocks.createStockLine(projectId, input(label: '  '));
    final stored = await db.select(db.stockLines).getSingle();
    expect(first.length.ticks, 60000000);
    expect(stored.lengthTicks, 60000000);
    expect(stored.quantity, 10);
    expect(first.label, isNull);
    expect(first.sortOrder, 0);
    expect(first.createdAt.isUtc, isTrue);
    expect(await revision(), 1);
    expect(
      (await projects.getProject(projectId))!.updatedAt
          .isAfter(original.updatedAt),
      isTrue,
    );
    final second = await stocks.createStockLine(
      projectId,
      input(quantity: 9999),
    );
    expect(second.quantity, 9999);
    expect(second.sortOrder, 1);
    expect(await revision(), 2);
  });

  test(
    'length, quantity, and combined updates each increment exactly once',
    () async {
      final stock = await stocks.createStockLine(projectId, input());
      await stocks.updateStockLine(stock.id, input(mm: '3000'));
      expect(await revision(), 2);
      expect((await stocks.getStockLine(stock.id))!.length.ticks, 30000000);
      await stocks.updateStockLine(stock.id, input(mm: '3000', quantity: 5));
      expect(await revision(), 3);
      await stocks.updateStockLine(stock.id, input(mm: '2000', quantity: 7));
      expect(await revision(), 4);
      final updated = (await stocks.getStockLine(stock.id))!;
      expect(updated.createdAt, stock.createdAt);
      expect(updated.sortOrder, stock.sortOrder);
      expect(updated.updatedAt.isAfter(stock.updatedAt), isTrue);
    },
  );

  test('label-only updates timestamps without revision; identical saves do nothing', () async {
    final stock = await stocks.createStockLine(
      projectId,
      input(label: 'Warehouse'),
    );
    final before = (await projects.getProject(projectId))!;
    await stocks.updateStockLine(stock.id, input(label: ' Rack A '));
    final changed = (await stocks.getStockLine(stock.id))!;
    final project = (await projects.getProject(projectId))!;
    expect(changed.label, 'Rack A');
    expect(changed.updatedAt.isAfter(stock.updatedAt), isTrue);
    expect(project.updatedAt.isAfter(before.updatedAt), isTrue);
    expect(project.revision, 1);
    await stocks.updateStockLine(stock.id, input(label: 'Rack A'));
    expect((await stocks.getStockLine(stock.id))!.updatedAt, changed.updatedAt);
    expect(
      (await projects.getProject(projectId))!.updatedAt,
      project.updatedAt,
    );
    expect(await revision(), 1);
  });

  test(
    'duplicate appends a fresh row with same values and revision plus one',
    () async {
      final source = await stocks.createStockLine(
        projectId,
        input(label: 'Warehouse'),
      );
      now = now.add(const Duration(hours: 1));
      final copy = await stocks.duplicateStockLine(source.id);
      expect(copy.id, isNot(source.id));
      expect(copy.projectId, source.projectId);
      expect(copy.length, source.length);
      expect(copy.quantity, source.quantity);
      expect(copy.label, source.label);
      expect(copy.sortOrder, 1);
      expect(copy.createdAt, now);
      expect(copy.updatedAt, now);
      expect(await revision(), 2);
    },
  );

  test(
    'delete removes only its row and increments revision exactly once',
    () async {
      final stock = await stocks.createStockLine(projectId, input());
      await stocks.deleteStockLine(stock.id);
      expect(await stocks.getStockLine(stock.id), isNull);
      expect(await revision(), 2);
      await expectLater(
        stocks.deleteStockLine(stock.id),
        throwsA(isA<StockNotFoundException>()),
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
            .into(db.stockLines)
            .insert(
              StockLinesCompanion.insert(
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
      await stocks.createStockLine(other.id, input());
      expect(
        (await stocks.watchStockLines(projectId).first).map((row) => row.id),
        ['a', 'd', 'b', 'c'],
      );
      final emission = expectLater(
        stocks.watchStockLines(projectId),
        emitsThrough(predicate<List<dynamic>>((rows) => rows.length == 5)),
      );
      await stocks.createStockLine(projectId, input());
      await emission;
    },
  );

  test(
    'mode switches preserve both inputs and same-mode saves do nothing',
    () async {
      final stock = await stocks.createStockLine(projectId, input());
      await projects.setInventoryMode(projectId, InventoryMode.buy);
      expect(
        (await projects.getProject(projectId))!.inventoryMode,
        InventoryMode.buy,
      );
      expect(await revision(), 2);
      expect(await stocks.getStockLine(stock.id), isNotNull);
      await projects.setBuyStockLength(
        projectId,
        Length.fromMillimeters('6000'),
      );
      expect(await revision(), 3);
      await projects.setInventoryMode(projectId, InventoryMode.fixed);
      final fixed = (await projects.getProject(projectId))!;
      expect(fixed.inventoryMode, InventoryMode.fixed);
      expect(fixed.buyStockLength!.ticks, 60000000);
      expect(await stocks.getStockLine(stock.id), isNotNull);
      expect(fixed.revision, 4);
      await projects.setInventoryMode(projectId, InventoryMode.fixed);
      expect(
        (await projects.getProject(projectId))!.updatedAt,
        fixed.updatedAt,
      );
      expect(await revision(), 4);
    },
  );

  test('buy length changes increment once; identical values preserve revision and time', () async {
    await projects.setBuyStockLength(projectId, Length.fromMillimeters('6000'));
    expect(
      (await projects.getProject(projectId))!.buyStockLength!.ticks,
      60000000,
    );
    expect(await revision(), 1);
    await projects.setBuyStockLength(projectId, Length.fromMillimeters('3000'));
    final before = (await projects.getProject(projectId))!;
    expect(before.revision, 2);
    await projects.setBuyStockLength(projectId, Length.fromMillimeters('3000'));
    expect(await revision(), 2);
    expect((await projects.getProject(projectId))!.updatedAt, before.updatedAt);
    expect(await db.select(db.stockLines).get(), isEmpty);
    await expectLater(
      projects.setBuyStockLength(projectId, Length.fromTicks(0)),
      throwsArgumentError,
    );
    expect(await revision(), 2);
  });

  test(
    'stock mutations preserve metadata, cut settings, createdAt and lastRunId',
    () async {
      await (db.update(
        db.projects,
      )..where((row) => row.id.equals(projectId))).write(
        const ProjectsCompanion(
          lastRunId: Value('run'),
          kerfTicks: Value(15875),
          endTrimTicks: Value(20),
          minReusableTicks: Value(50000),
          note: Value('Note'),
          material: Value('Steel'),
        ),
      );
      final before = (await projects.getProject(projectId))!;
      await stocks.createStockLine(projectId, input());
      await projects.setBuyStockLength(
        projectId,
        Length.fromMillimeters('3000'),
      );
      await projects.setInventoryMode(projectId, InventoryMode.buy);
      final after = (await projects.getProject(projectId))!;
      expect(after.revision, 3);
      expect(after.name, before.name);
      expect(after.note, before.note);
      expect(after.material, before.material);
      expect(after.createdAt, before.createdAt);
      expect(after.lastRunId, before.lastRunId);
      expect(after.kerf, before.kerf);
      expect(after.endTrim, before.endTrim);
      expect(after.minReusable, before.minReusable);
      expect(after.displayUnit, before.displayUnit);
    },
  );

  test('failed project touch rolls back create, update, duplicate, delete and mode settings', () async {
    final stock = await stocks.createStockLine(projectId, input());
    await db.customStatement(
      "CREATE TRIGGER reject_revision BEFORE UPDATE ON projects BEGIN SELECT RAISE(ABORT, 'test'); END",
    );
    final operations = <Future<void> Function()>[
      () async {
        await stocks.createStockLine(projectId, input());
      },
      () => stocks.updateStockLine(stock.id, input(mm: '3000')),
      () async {
        await stocks.duplicateStockLine(stock.id);
      },
      () => stocks.deleteStockLine(stock.id),
      () => projects.setInventoryMode(projectId, InventoryMode.buy),
      () =>
          projects.setBuyStockLength(projectId, Length.fromMillimeters('3000')),
    ];
    for (final operation in operations) {
      await expectLater(operation(), throwsA(isA<SqliteException>()));
      expect(await revision(), 1);
      expect(await db.select(db.stockLines).get(), hasLength(1));
      expect((await stocks.getStockLine(stock.id))!.length.ticks, 60000000);
      expect(
        (await projects.getProject(projectId))!.inventoryMode,
        InventoryMode.fixed,
      );
      expect((await projects.getProject(projectId))!.buyStockLength, isNull);
    }
  });

  test(
    'concurrent mutations serialize increments without lost revisions',
    () async {
      await Future.wait([
        stocks.createStockLine(projectId, input()),
        stocks.createStockLine(projectId, input(mm: '3000')),
        projects.setBuyStockLength(projectId, Length.fromMillimeters('6000')),
        projects.setInventoryMode(projectId, InventoryMode.buy),
      ]);
      expect(await revision(), 4);
      expect(
        (await stocks.watchStockLines(projectId).first).map(
          (row) => row.sortOrder,
        ),
        [0, 1],
      );
    },
  );

  test('deleted projects and stock IDs fail safely without orphans', () async {
    final stock = await stocks.createStockLine(projectId, input());
    await projects.deleteProject(projectId);
    await expectLater(
      stocks.createStockLine(projectId, input()),
      throwsA(isA<ProjectNotFoundException>()),
    );
    await expectLater(
      stocks.updateStockLine(stock.id, input()),
      throwsA(isA<StockNotFoundException>()),
    );
    await expectLater(
      stocks.duplicateStockLine(stock.id),
      throwsA(isA<StockNotFoundException>()),
    );
    await expectLater(
      projects.setInventoryMode(projectId, InventoryMode.buy),
      throwsA(isA<ProjectNotFoundException>()),
    );
    await expectLater(
      projects.setBuyStockLength(projectId, Length.fromMillimeters('6000')),
      throwsA(isA<ProjectNotFoundException>()),
    );
    expect(await db.select(db.stockLines).get(), isEmpty);
  });

  test('close/reopen preserves stock, mode, buy length and revision', () async {
    final directory = await Directory.systemTemp.createTemp('kerfplan-stock-');
    addTearDown(() => directory.delete(recursive: true));
    await db.close();
    final file = File('${directory.path}/stock.sqlite');
    db = AppDatabase.withExecutor(NativeDatabase(file));
    projects = DriftProjectRepository(db);
    stocks = DriftStockRepository(db);
    projectId = (await projects.createProject(
      ProjectMetadata(name: 'Persistent'),
    )).id;
    final stock = await stocks.createStockLine(
      projectId,
      input(label: 'Warehouse'),
    );
    await projects.setBuyStockLength(projectId, Length.fromMillimeters('3000'));
    await projects.setInventoryMode(projectId, InventoryMode.buy);
    await db.close();
    db = AppDatabase.withExecutor(NativeDatabase(file));
    projects = DriftProjectRepository(db);
    stocks = DriftStockRepository(db);
    final project = (await projects.getProject(projectId))!;
    expect(project.inventoryMode, InventoryMode.buy);
    expect(project.buyStockLength!.ticks, 30000000);
    expect(project.revision, 3);
    expect((await stocks.getStockLine(stock.id))!.label, 'Warehouse');
    await projects.setInventoryMode(projectId, InventoryMode.fixed);
    expect(
      (await stocks.watchStockLines(projectId).first).single.length.ticks,
      60000000,
    );
    await db.close();
    db = AppDatabase.withExecutor(NativeDatabase.memory());
  });
}
