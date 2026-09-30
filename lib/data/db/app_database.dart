import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/app_settings.dart';
import 'tables/part_lines.dart';
import 'tables/projects.dart';
import 'tables/stock_lines.dart';
import 'tables/entitlement_cache.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Projects, StockLines, PartLines, AppSettings, EntitlementCache],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'kerfplan'));

  /// Allows tests to use an isolated in-memory SQLite database.
  AppDatabase.withExecutor(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) await migrator.createTable(entitlementCache);
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
