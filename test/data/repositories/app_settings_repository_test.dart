import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/app/settings_providers.dart';
import 'package:kerfplan/data/db/app_database.dart';
import 'package:kerfplan/data/db/database_provider.dart';
import 'package:kerfplan/data/repositories/drift_app_settings_repository.dart';
import 'package:kerfplan/domain/models/app_preferences.dart';
import 'package:kerfplan/domain/models/app_theme_mode.dart';
import 'package:kerfplan/domain/units/display_unit.dart';
import 'package:kerfplan/domain/units/length.dart';

AppPreferences preferences({
  DisplayUnit unit = DisplayUnit.ftIn,
  AppThemeMode theme = AppThemeMode.dark,
}) => AppPreferences(
  defaultDisplayUnit: unit,
  defaultKerf: Length.fromInchFraction(1, 8),
  defaultReusable: Length.fromInchFraction(4, 1),
  themeMode: theme,
);
void main() {
  late AppDatabase db;
  late DriftAppSettingsRepository repository;
  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    repository = DriftAppSettingsRepository(db);
  });
  tearDown(() => db.close());
  test('missing row initializes once under concurrent reads', () async {
    final values = await Future.wait(
      List.generate(5, (_) => repository.getSettings()),
    );
    expect(values, everyElement(AppPreferences.defaults));
    final row = await db.select(db.appSettings).getSingle();
    expect(row.id, 1);
    expect(row.defaultDisplayUnit, 'mm');
    expect(row.defaultKerfTicks, 30000);
    expect(row.defaultReusableTicks, 1000000);
    expect(row.themeMode, 'system');
  });
  test(
    'watch initializes a missing row and observes one full update',
    () async {
      final stream = repository.watchSettings();
      final seen = <AppPreferences>[];
      final subscription = stream.listen(seen.add);
      addTearDown(subscription.cancel);
      await repository.getSettings();
      await pumpEventQueue();
      await repository.updateSettings(preferences());
      await pumpEventQueue();
      expect(seen, [AppPreferences.defaults, preferences()]);
    },
  );
  for (final unit in DisplayUnit.values) {
    test('$unit persists with exact imperial ticks and stable theme', () async {
      await repository.updateSettings(preferences(unit: unit));
      final row = await db.select(db.appSettings).getSingle();
      expect(row.defaultDisplayUnit, unit.storageValue);
      expect(row.defaultKerfTicks, 31750);
      expect(row.defaultReusableTicks, 1016000);
      expect(row.themeMode, 'dark');
      expect(await repository.getSettings(), preferences(unit: unit));
    });
  }
  test('zero defaults persist', () async {
    final zero = AppPreferences(
      defaultDisplayUnit: DisplayUnit.mm,
      defaultKerf: Length.fromTicks(0),
      defaultReusable: Length.fromTicks(0),
      themeMode: AppThemeMode.light,
    );
    await repository.updateSettings(zero);
    expect(await repository.getSettings(), zero);
  });
  test('failed update changes no numeric value, unit, or theme', () async {
    final before = await repository.getSettings();
    await db.customStatement(
      "CREATE TRIGGER fail_settings BEFORE UPDATE ON app_settings BEGIN SELECT RAISE(ABORT,'private detail'); END",
    );
    await expectLater(
      repository.updateSettings(preferences()),
      throwsA(anything),
    );
    expect(await repository.getSettings(), before);
  });
  test('failed first save also rolls back initialization', () async {
    await db.customStatement(
      "CREATE TRIGGER fail_settings BEFORE UPDATE ON app_settings BEGIN SELECT RAISE(ABORT,'private detail'); END",
    );
    await expectLater(
      repository.updateSettings(preferences()),
      throwsA(anything),
    );
    expect(await db.select(db.appSettings).get(), isEmpty);
  });
  test('identical save performs neither update nor replace', () async {
    final before = await repository.getSettings();
    await db.customStatement(
      "CREATE TRIGGER reject_update BEFORE UPDATE ON app_settings BEGIN SELECT RAISE(ABORT,'unnecessary update'); END",
    );
    await db.customStatement(
      "CREATE TRIGGER reject_insert BEFORE INSERT ON app_settings BEGIN SELECT RAISE(ABORT,'unnecessary insert'); END",
    );
    await db.customStatement(
      "CREATE TRIGGER reject_delete BEFORE DELETE ON app_settings BEGIN SELECT RAISE(ABORT,'unnecessary delete'); END",
    );
    await repository.updateSettings(before);
    expect(await repository.getSettings(), before);
  });
  for (final corrupt in [
    const AppSettingsCompanion(themeMode: Value('invalid')),
    const AppSettingsCompanion(defaultDisplayUnit: Value('invalid')),
    const AppSettingsCompanion(defaultKerfTicks: Value(-1)),
    const AppSettingsCompanion(defaultReusableTicks: Value(-1)),
  ]) {
    test('invalid stored values fail clearly: $corrupt', () async {
      await repository.getSettings();
      await db.update(db.appSettings).write(corrupt);
      await expectLater(repository.getSettings(), throwsA(anything));
      await expectLater(repository.watchSettings().first, throwsA(anything));
    });
  }
  for (final theme in AppThemeMode.values) {
    test(
      '$theme and exact defaults survive database/provider recreation',
      () async {
        final dir = await Directory.systemTemp.createTemp(
          'kerfplan-preferences-',
        );
        addTearDown(() => dir.delete(recursive: true));
        await db.close();
        final file = File('${dir.path}/preferences.sqlite');
        final firstDb = AppDatabase.withExecutor(NativeDatabase(file));
        final first = ProviderContainer(
          overrides: [appDatabaseProvider.overrideWithValue(firstDb)],
        );
        final saved = preferences(theme: theme);
        await first.read(appSettingsRepositoryProvider).updateSettings(saved);
        first.dispose();
        await firstDb.close();
        final secondDb = AppDatabase.withExecutor(NativeDatabase(file));
        final second = ProviderContainer(
          overrides: [appDatabaseProvider.overrideWithValue(secondDb)],
        );
        final subscription = second.listen(appSettingsProvider, (_, _) {});
        try {
          expect(await second.read(appSettingsProvider.future), saved);
          expect(secondDb.schemaVersion, 2);
        } finally {
          subscription.close();
          second.dispose();
          await secondDb.close();
          db = AppDatabase.withExecutor(NativeDatabase.memory());
        }
      },
    );
  }
}
