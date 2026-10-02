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
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) await migrator.createTable(entitlementCache);
      if (from < 3) {
        await migrator.addColumn(appSettings, appSettings.localeTag);
      }
      if (from < 4) {
        await migrator.addColumn(appSettings, appSettings.measurementSystem);
        await migrator.addColumn(appSettings, appSettings.onboardingCompleted);
        await customStatement('''
          UPDATE app_settings SET measurement_system = CASE
            WHEN default_display_unit IN ('inch', 'ftIn') THEN 'imperial'
            ELSE 'metric' END
        ''');
        // A prior install with no preferences row is still an existing user.
        await customStatement('''
          INSERT OR IGNORE INTO app_settings
            (id, default_display_unit, default_kerf_ticks,
             default_reusable_ticks, theme_mode, locale_tag,
             measurement_system, onboarding_completed)
          VALUES (1, 'mm', 30000, 1000000, 'system', NULL, 'metric', 1)
        ''');
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
