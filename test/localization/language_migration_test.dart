import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/data/db/app_database.dart';
import 'package:kerfplan/data/repositories/drift_app_settings_repository.dart';
import 'package:kerfplan/domain/models/app_language.dart';
import 'package:kerfplan/domain/billing/billing_product.dart';
import 'package:kerfplan/data/repositories/drift_entitlement_repository.dart';

void main() {
  test('unknown persisted locale fails clearly', () async {
    final db = AppDatabase.withExecutor(NativeDatabase.memory());
    try {
      final settings = DriftAppSettingsRepository(db);
      await settings.getSettings();
      await db.customStatement(
        "UPDATE app_settings SET locale_tag = 'xx' WHERE id = 1",
      );
      await expectLater(settings.getSettings(), throwsFormatException);
      await expectLater(settings.watchSettings().first, throwsFormatException);
    } finally {
      await db.close();
    }
  });
  test('populated v2 migrates to v4 without changing existing data', () async {
    final directory = await Directory.systemTemp.createTemp('kerfplan-v3-');
    final file = await File('test/fixtures/schema_v2.sqlite')
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
            2,
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
      final settings = DriftAppSettingsRepository(db);
      expect((await settings.getSettings()).language, AppLanguage.system);
      expect(
        (await db.customSelect('PRAGMA user_version').getSingle()).read<int>(
          'user_version',
        ),
        4,
      );
      for (final table in tables) {
        expect([
          for (final row in await db.customSelect('SELECT * FROM $table').get())
            if (table == 'app_settings')
              Map.of(row.data)
                ..remove('locale_tag')
                ..remove('measurement_system')
                ..remove('onboarding_completed')
            else
              row.data,
        ], before[table]);
      }
      final project = await db.select(db.projects).getSingle();
      expect(project.revision, 17);
      expect(project.kerfTicks, 31750);
      expect(
        (await db.select(db.stockLines).getSingle()).lengthTicks,
        60000001,
      );
      expect((await db.select(db.partLines).getSingle()).lengthTicks, 12096750);
      expect((await db.select(db.appSettings).getSingle()).themeMode, 'dark');
      expect(
        (await DriftEntitlementRepository(db).getEntitlements()).isPro,
        isTrue,
      );
      final old = await settings.getSettings();
      await settings.updateSettings(
        old.copyWith(language: AppLanguage.spanish),
      );
    } finally {
      await db.close();
    }
    final reopened = AppDatabase.withExecutor(NativeDatabase(file));
    try {
      expect(
        (await DriftAppSettingsRepository(reopened).getSettings()).language,
        AppLanguage.spanish,
      );
      expect(
        (await DriftEntitlementRepository(reopened).getEntitlements()).isPro,
        isTrue,
      );
      expect(
        (await reopened.select(reopened.entitlementCache).getSingle())
            .productId,
        BillingProduct.lifetimePro.id,
      );
    } finally {
      await reopened.close();
      await directory.delete(recursive: true);
    }
  });
}
