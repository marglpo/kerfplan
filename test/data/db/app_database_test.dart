import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/data/db/app_database.dart';

void main() {
  late AppDatabase database;
  final timestamp = DateTime.utc(2026, 9, 22);

  setUp(() {
    database = AppDatabase.withExecutor(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  ProjectsCompanion project(String id) => ProjectsCompanion.insert(
    id: id,
    name: 'Workshop job',
    inventoryMode: 'fixed',
    displayUnit: 'mm',
    kerfTicks: 30000,
    endTrimTicks: 0,
    minReusableTicks: 1000000,
    createdAt: timestamp,
    updatedAt: timestamp,
  );

  StockLinesCompanion stock(String id, String projectId) =>
      StockLinesCompanion.insert(
        id: id,
        projectId: projectId,
        lengthTicks: 60000000,
        quantity: 2,
        createdAt: timestamp,
        updatedAt: timestamp,
      );

  PartLinesCompanion part(String id, String projectId) =>
      PartLinesCompanion.insert(
        id: id,
        projectId: projectId,
        lengthTicks: 1000000,
        quantity: 3,
        createdAt: timestamp,
        updatedAt: timestamp,
      );

  test(
    'schema v4 inserts project and lines, then cascades only its children',
    () async {
      expect(database.schemaVersion, 4);
      await database.into(database.projects).insert(project('first'));
      await database.into(database.projects).insert(project('second'));
      await database
          .into(database.stockLines)
          .insert(stock('stock-first', 'first'));
      await database
          .into(database.stockLines)
          .insert(stock('stock-second', 'second'));
      await database
          .into(database.partLines)
          .insert(part('part-first', 'first'));
      await database
          .into(database.partLines)
          .insert(part('part-second', 'second'));

      final projects = await database.select(database.projects).get();
      expect(projects, hasLength(2));
      expect(projects.first.kerfTicks, 30000);
      expect(projects.first.revision, 0);
      expect(projects.first.material, isNull);
      expect(projects.first.createdAt.toUtc(), timestamp);
      final stocks = await database.select(database.stockLines).get();
      expect(stocks, hasLength(2));
      expect(stocks.first.sortOrder, 0);
      expect(await database.select(database.partLines).get(), hasLength(2));

      await (database.delete(
        database.projects,
      )..where((row) => row.id.equals('first'))).go();

      expect(
        (await database.select(database.projects).get()).single.id,
        'second',
      );
      expect(
        (await database.select(database.stockLines).get()).single.id,
        'stock-second',
      );
      expect(
        (await database.select(database.partLines).get()).single.id,
        'part-second',
      );
    },
  );

  test('foreign keys reject orphan stock and part lines', () async {
    await expectLater(
      database
          .into(database.stockLines)
          .insert(stock('orphan-stock', 'missing')),
      throwsA(isA<SqliteException>()),
    );
    await expectLater(
      database.into(database.partLines).insert(part('orphan-part', 'missing')),
      throwsA(isA<SqliteException>()),
    );
  });

  test('tick columns preserve signed 64-bit integers exactly', () async {
    const maximum = 0x7FFFFFFFFFFFFFFF;
    await database
        .into(database.projects)
        .insert(
          project('large').copyWith(
            kerfTicks: const Value(maximum),
            endTrimTicks: const Value(maximum),
            minReusableTicks: const Value(maximum),
            buyStockLengthTicks: const Value(maximum),
          ),
        );
    await database
        .into(database.stockLines)
        .insert(
          stock(
            'large-stock',
            'large',
          ).copyWith(lengthTicks: const Value(maximum)),
        );
    await database
        .into(database.partLines)
        .insert(
          part(
            'large-part',
            'large',
          ).copyWith(lengthTicks: const Value(maximum)),
        );
    final stored = await database.select(database.projects).getSingle();
    expect(stored.kerfTicks, maximum);
    expect(stored.endTrimTicks, maximum);
    expect(stored.minReusableTicks, maximum);
    expect(stored.buyStockLengthTicks, maximum);
    expect(
      (await database.select(database.stockLines).getSingle()).lengthTicks,
      maximum,
    );
    expect(
      (await database.select(database.partLines).getSingle()).lengthTicks,
      maximum,
    );
  });

  test('settings enforces a single row and preserves integer ticks', () async {
    AppSettingsCompanion settings(int id) => AppSettingsCompanion.insert(
      id: Value(id),
      defaultDisplayUnit: 'mm',
      defaultKerfTicks: 0x7FFFFFFFFFFFFFFF,
      defaultReusableTicks: 0x7FFFFFFFFFFFFFFF,
      themeMode: 'system',
    );
    await database.into(database.appSettings).insert(settings(1));
    await expectLater(
      database.into(database.appSettings).insert(settings(2)),
      throwsA(isA<SqliteException>()),
    );
    await expectLater(
      database.into(database.appSettings).insert(settings(1)),
      throwsA(isA<SqliteException>()),
    );
    final stored = await database.select(database.appSettings).getSingle();
    expect(stored.id, 1);
    expect(stored.defaultKerfTicks, 0x7FFFFFFFFFFFFFFF);
    expect(stored.defaultReusableTicks, 0x7FFFFFFFFFFFFFFF);
  });
}
