import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/app/reusable_leftovers.dart';
import 'package:kerfplan/data/db/app_database.dart';
import 'package:kerfplan/data/repositories/drift_stock_repository.dart';
import 'package:kerfplan/domain/models/inventory_mode.dart';
import 'package:kerfplan/domain/models/stock_input.dart';
import 'package:kerfplan/domain/repositories/project_repository.dart';
import 'package:kerfplan/domain/units/length.dart';

import '../../support/optimization_fixture.dart';

void main() {
  late OptimizationFixture f;
  setUp(() async {
    f = OptimizationFixture();
    await f.initialize();
  });
  tearDown(() => f.close());
  StockInput input(int ticks, {int quantity = 1}) =>
      StockInput(length: Length.fromTicks(ticks), quantity: quantity);

  for (final count in [1, 5]) {
    test(
      '$count batch rows get fresh IDs and one revision/timestamp update',
      () async {
        final before = (await f.projects.getProject(f.id))!;
        final now = DateTime.utc(2030);
        var clockReads = 0;
        final repository = DriftStockRepository(
          f.db,
          now: () {
            clockReads++;
            return now;
          },
        );
        await repository.addStockBatch(f.id, [
          for (var i = 0; i < count; i++) input(9970000 + i, quantity: 2),
        ]);
        final rows = await f.stocks.getStockLines(f.id);
        final after = (await f.projects.getProject(f.id))!;
        expect(rows.map((r) => r.length.ticks), [
          for (var i = 0; i < count; i++) 9970000 + i,
        ]);
        expect(rows.map((r) => r.sortOrder), List.generate(count, (i) => i));
        expect(rows.map((r) => r.id).toSet().length, count);
        expect(
          rows.every(
            (r) => r.label == null && r.quantity == 2 && r.projectId == f.id,
          ),
          isTrue,
        );
        expect(
          rows.every(
            (r) =>
                r.createdAt == now && r.updatedAt == now && r.createdAt.isUtc,
          ),
          isTrue,
        );
        expect(after.revision, before.revision + 1);
        expect(after.updatedAt, now);
        expect(clockReads, 1);
      },
    );
  }
  test('empty batch is a complete no-op', () async {
    final before = (await f.projects.getProject(f.id))!;
    await f.stocks.addStockBatch(f.id, []);
    final after = (await f.projects.getProject(f.id))!;
    expect(after.revision, before.revision);
    expect(after.updatedAt, before.updatedAt);
    expect(await f.stocks.getStockLines(f.id), isEmpty);
  });
  test(
    'append preserves existing data and gaps; does not merge existing lengths',
    () async {
      await f.stock(997);
      await (f.db.update(f.db.stockLines))
          .write(const StockLinesCompanion(sortOrder: Value(7)));
      final before = await f.db.select(f.db.stockLines).getSingle();
      await f.stocks.addStockBatch(f.id, [input(9970000), input(35000000)]);
      final rows = await f.stocks.getStockLines(f.id);
      expect(rows.map((r) => r.sortOrder), [7, 8, 9]);
      expect(
        await (f.db.select(
          f.db.stockLines,
        )..where((r) => r.id.equals(before.id))).getSingle(),
        before,
      );
      expect(rows.map((r) => r.id).toSet().length, 3);
    },
  );
  for (final failure in ['insert', 'project update']) {
    test(
      '$failure failure rolls back all inserted rows and project metadata',
      () async {
        await f.stock(1000);
        final before = (await f.projects.getProject(f.id))!;
        final existing = await f.db.select(f.db.stockLines).get();
        await f.db.customStatement(
          failure == 'insert'
              ? "CREATE TRIGGER fail_batch BEFORE INSERT ON stock_lines WHEN NEW.length_ticks = 35000000 BEGIN SELECT RAISE(ABORT, 'private detail'); END"
              : "CREATE TRIGGER fail_batch BEFORE UPDATE ON projects BEGIN SELECT RAISE(ABORT, 'private detail'); END",
        );
        await expectLater(
          f.stocks.addStockBatch(f.id, [input(9970000), input(35000000)]),
          throwsA(anything),
        );
        expect(await f.db.select(f.db.stockLines).get(), existing);
        final after = (await f.projects.getProject(f.id))!;
        expect(after.revision, before.revision);
        expect(after.updatedAt, before.updatedAt);
      },
    );
  }
  test('missing project fails without orphan rows', () async {
    await expectLater(
      f.stocks.addStockBatch('deleted', [input(9970000)]),
      throwsA(isA<ProjectNotFoundException>()),
    );
    expect(await f.db.select(f.db.stockLines).get(), isEmpty);
  });
  test(
    'sort overflow rejects whole batch without reordering existing row',
    () async {
      await f.stock(1000);
      await f.db
          .update(f.db.stockLines)
          .write(
            const StockLinesCompanion(sortOrder: Value(0x7FFFFFFFFFFFFFFE)),
          );
      final before = (await f.projects.getProject(f.id))!;
      await expectLater(
        f.stocks.addStockBatch(f.id, [input(1), input(2)]),
        throwsStateError,
      );
      expect(
        (await f.stocks.getStockLines(f.id)).single.sortOrder,
        0x7FFFFFFFFFFFFFFE,
      );
      expect((await f.projects.getProject(f.id))!.revision, before.revision);
    },
  );
  test('revision overflow rolls back inserted batch', () async {
    await f.db
        .update(f.db.projects)
        .write(const ProjectsCompanion(revision: Value(0x7FFFFFFFFFFFFFFF)));
    await expectLater(
      f.stocks.addStockBatch(f.id, [input(1), input(2)]),
      throwsStateError,
    );
    expect(await f.stocks.getStockLines(f.id), isEmpty);
  });
  for (final mode in InventoryMode.values) {
    test(
      '$mode coordinator adds only used reusable tails and preserves mode/config',
      () async {
        await f.stock(1000, quantity: 5);
        await f.part(400, quantity: 2);
        await f.projects.setBuyStockLength(
          f.id,
          Length.fromMillimeters('1000'),
        );
        await f.projects.setInventoryMode(f.id, mode);
        final before = (await f.projects.getProject(f.id))!;
        final calculation = await f.coordinator.calculate(f.id);
        await ReusableLeftovers(f.stocks).addToStock(f.id, calculation.result);
        final rows = await f.stocks.getStockLines(f.id);
        expect(rows.length, 2);
        expect(rows.last.length.ticks, 1970000);
        expect(rows.last.quantity, 1);
        final after = (await f.projects.getProject(f.id))!;
        expect(after.inventoryMode, mode);
        expect(after.buyStockLength, before.buyStockLength);
        expect(after.revision, before.revision + 1);
        expect(after.kerf, before.kerf);
        expect(after.endTrim, before.endTrim);
        expect(after.minReusable, before.minReusable);
        expect(after.createdAt, before.createdAt);
        expect(after.lastRunId, before.lastRunId);
      },
    );
  }
}
