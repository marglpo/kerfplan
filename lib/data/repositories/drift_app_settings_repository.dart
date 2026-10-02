import 'package:drift/drift.dart';

import '../../domain/models/app_preferences.dart';
import '../../domain/models/app_language.dart';
import '../../domain/models/app_theme_mode.dart';
import '../../domain/models/measurement_system.dart';
import '../../domain/repositories/app_settings_repository.dart';
import '../../domain/units/display_unit.dart';
import '../../domain/units/length.dart';
import '../db/app_database.dart';
import '../db/tables/app_settings.dart';

final class DriftAppSettingsRepository implements AppSettingsRepository {
  const DriftAppSettingsRepository(this._db);
  final AppDatabase _db;

  SimpleSelectStatement<$AppSettingsTable, AppSetting> _query() =>
      _db.select(_db.appSettings)
        ..where((row) => row.id.equals(AppSettings.singletonId));

  AppPreferences _map(AppSetting row) => AppPreferences(
    defaultDisplayUnit: DisplayUnit.fromStorage(row.defaultDisplayUnit),
    defaultKerf: Length.fromTicks(row.defaultKerfTicks),
    defaultReusable: Length.fromTicks(row.defaultReusableTicks),
    themeMode: AppThemeMode.fromStorage(row.themeMode),
    language: AppLanguage.fromStorage(row.localeTag),
    measurementSystem: row.measurementSystem == null
        ? MeasurementSystem.fromUnit(
            DisplayUnit.fromStorage(row.defaultDisplayUnit),
          )
        : MeasurementSystem.fromStorage(row.measurementSystem!),
    onboardingCompleted: row.onboardingCompleted,
  );

  AppSettingsCompanion _values(AppPreferences settings) =>
      AppSettingsCompanion.insert(
        id: const Value(AppSettings.singletonId),
        defaultDisplayUnit: settings.defaultDisplayUnit.storageValue,
        defaultKerfTicks: settings.defaultKerf.ticks,
        defaultReusableTicks: settings.defaultReusable.ticks,
        themeMode: settings.themeMode.storageValue,
        localeTag: Value(settings.language.storageTag),
        measurementSystem: Value(settings.measurementSystem.storageValue),
        onboardingCompleted: Value(settings.onboardingCompleted),
      );

  @override
  Future<AppPreferences> getSettings() => _db.transaction(() async {
    final existing = await _query().getSingleOrNull();
    if (existing != null) return _map(existing);
    await _db
        .into(_db.appSettings)
        .insert(
          _values(AppPreferences.defaults),
          mode: InsertMode.insertOrIgnore,
        );
    return _map(await _query().getSingle());
  });

  @override
  Stream<AppPreferences> watchSettings() => _query()
      .watchSingleOrNull()
      .asyncMap<AppPreferences>(
        (row) => row == null ? getSettings() : _map(row),
      )
      .distinct();

  @override
  Future<void> updateSettings(AppPreferences settings) =>
      _db.transaction(() async {
        final current = await getSettings();
        if (current == settings) return;
        await (_db.update(_db.appSettings)
              ..where((row) => row.id.equals(AppSettings.singletonId)))
            .write(_values(settings));
      });
}
