import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/data/db/app_database.dart';
import 'package:kerfplan/data/repositories/drift_app_settings_repository.dart';
import 'package:kerfplan/data/repositories/drift_entitlement_repository.dart';
import 'package:kerfplan/domain/models/app_language.dart';
import 'package:kerfplan/domain/models/measurement_system.dart';

void main() {
  test(
    'fresh v4 settings begin incomplete and reject unknown system values',
    () async {
      final db = AppDatabase.withExecutor(NativeDatabase.memory());
      try {
        final repository = DriftAppSettingsRepository(db);
        final fresh = await repository.getSettings();
        expect(fresh.onboardingCompleted, isFalse);
        expect(fresh.measurementSystem, MeasurementSystem.metric);
        await db.customStatement(
          "UPDATE app_settings SET measurement_system = 'unknown' WHERE id = 1",
        );
        await expectLater(repository.getSettings(), throwsFormatException);
      } finally {
        await db.close();
      }
    },
  );
  for (final unit in ['mm', 'ftIn']) {
    test(
      'populated v3 $unit migrates to v4 without altering old data',
      () async {
        final directory = await Directory.systemTemp.createTemp('kerfplan-v4-');
        final file = await File('test/fixtures/schema_v3.sqlite')
            .copy('${directory.path}/migration.sqlite');
        final before = <String, List<Map<String, Object?>>>{};
        final tables = [
          'projects',
          'stock_lines',
          'part_lines',
          'app_settings',
          'entitlement_cache',
        ];
        final db = AppDatabase.withExecutor(
          NativeDatabase(
            file,
            setup: (sqlite) {
              expect(
                sqlite.select('PRAGMA user_version').single['user_version'],
                3,
              );
              sqlite.execute(
                'UPDATE app_settings SET default_display_unit = ? WHERE id = 1',
                [unit],
              );
              for (final table in tables) {
                before[table] = [
                  for (final row in sqlite.select('SELECT * FROM $table'))
                    Map.of(row),
                ];
              }
            },
          ),
        );
        try {
          final settings = await DriftAppSettingsRepository(db).getSettings();
          expect(db.schemaVersion, 4);
          expect(settings.onboardingCompleted, isTrue);
          expect(settings.language, AppLanguage.ukrainian);
          expect(
            settings.measurementSystem,
            unit == 'mm'
                ? MeasurementSystem.metric
                : MeasurementSystem.imperial,
          );
          expect(
            (await db.customSelect('PRAGMA user_version').getSingle())
                .read<int>('user_version'),
            4,
          );
          for (final table in tables) {
            expect([
              for (final row
                  in await db.customSelect('SELECT * FROM $table').get())
                if (table == 'app_settings')
                  Map.of(row.data)
                    ..remove('measurement_system')
                    ..remove('onboarding_completed')
                else
                  row.data,
            ], before[table]);
          }
          expect((await db.select(db.projects).getSingle()).revision, 17);
          expect(
            (await db.select(db.stockLines).getSingle()).lengthTicks,
            60000001,
          );
          expect(
            (await db.select(db.partLines).getSingle()).lengthTicks,
            12096750,
          );
          expect(
            (await DriftEntitlementRepository(db).getEntitlements()).isPro,
            isTrue,
          );
        } finally {
          await db.close();
          await directory.delete(recursive: true);
        }
      },
    );
  }

  test('existing v3 install without settings row skips onboarding', () async {
    final directory = await Directory.systemTemp.createTemp(
      'kerfplan-v4-empty-',
    );
    final file = await File('test/fixtures/schema_v3.sqlite')
        .copy('${directory.path}/migration.sqlite');
    final db = AppDatabase.withExecutor(
      NativeDatabase(
        file,
        setup: (sqlite) {
          sqlite.execute('DELETE FROM app_settings');
        },
      ),
    );
    try {
      final settings = await DriftAppSettingsRepository(db).getSettings();
      expect(settings.onboardingCompleted, isTrue);
      expect(settings.measurementSystem, MeasurementSystem.metric);
      expect((await db.select(db.projects).get()).length, 1);
    } finally {
      await db.close();
      await directory.delete(recursive: true);
    }
  });
}
