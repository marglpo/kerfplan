import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/domain/models/app_preferences.dart';
import 'package:kerfplan/domain/models/app_theme_mode.dart';
import 'package:kerfplan/domain/models/project_defaults.dart';
import 'package:kerfplan/domain/units/display_unit.dart';
import 'package:kerfplan/domain/units/length.dart';

void main() {
  test('fresh preferences share one source of project fallback defaults', () {
    final defaults = AppPreferences.defaults;
    expect(defaults.defaultDisplayUnit, DisplayUnit.mm);
    expect(defaults.defaultKerf.ticks, 30000);
    expect(defaults.defaultReusable.ticks, 1000000);
    expect(defaults.themeMode, AppThemeMode.system);
    expect(ProjectDefaults.displayUnit, defaults.defaultDisplayUnit);
    expect(ProjectDefaults.kerf, defaults.defaultKerf);
    expect(ProjectDefaults.minReusable, defaults.defaultReusable);
    expect(ProjectDefaults.endTrim.ticks, 0);
  });
  test('zero kerf and reusable are valid', () {
    final p = AppPreferences(
      defaultDisplayUnit: DisplayUnit.mm,
      defaultKerf: Length.fromTicks(0),
      defaultReusable: Length.fromTicks(0),
      themeMode: AppThemeMode.system,
    );
    expect(p.defaultKerf.ticks, 0);
    expect(p.defaultReusable.ticks, 0);
  });
  for (final field in ['kerf', 'reusable']) {
    test('negative $field cannot enter the preferences model', () {
      expect(
        () => AppPreferences(
          defaultDisplayUnit: DisplayUnit.mm,
          defaultKerf: Length.fromTicks(field == 'kerf' ? -1 : 0),
          defaultReusable: Length.fromTicks(field == 'reusable' ? -1 : 0),
          themeMode: AppThemeMode.system,
        ),
        throwsRangeError,
      );
    });
  }
  for (final mode in AppThemeMode.values) {
    test('$mode stable storage round trip', () {
      expect(AppThemeMode.fromStorage(mode.storageValue), mode);
    });
  }
  test('unknown theme fails clearly', () {
    expect(() => AppThemeMode.fromStorage('night'), throwsFormatException);
  });
  test('value equality compares every setting', () {
    final a = AppPreferences.defaults;
    final b = AppPreferences(
      defaultDisplayUnit: a.defaultDisplayUnit,
      defaultKerf: a.defaultKerf,
      defaultReusable: a.defaultReusable,
      themeMode: a.themeMode,
    );
    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(
      a,
      isNot(
        AppPreferences(
          defaultDisplayUnit: a.defaultDisplayUnit,
          defaultKerf: a.defaultKerf,
          defaultReusable: a.defaultReusable,
          themeMode: AppThemeMode.dark,
        ),
      ),
    );
  });
}
