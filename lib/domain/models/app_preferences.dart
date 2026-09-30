import '../units/display_unit.dart';
import '../units/length.dart';
import 'app_theme_mode.dart';

/// Length enforces nonnegative, exact ticks. Zero is valid for both defaults.
final class AppPreferences {
  const AppPreferences({
    required this.defaultDisplayUnit,
    required this.defaultKerf,
    required this.defaultReusable,
    required this.themeMode,
  });

  static final defaults = AppPreferences(
    defaultDisplayUnit: DisplayUnit.mm,
    defaultKerf: Length.fromMillimeters('3'),
    defaultReusable: Length.fromMillimeters('100'),
    themeMode: AppThemeMode.system,
  );

  final DisplayUnit defaultDisplayUnit;
  final Length defaultKerf;
  final Length defaultReusable;
  final AppThemeMode themeMode;

  @override
  bool operator ==(Object other) =>
      other is AppPreferences &&
      defaultDisplayUnit == other.defaultDisplayUnit &&
      defaultKerf == other.defaultKerf &&
      defaultReusable == other.defaultReusable &&
      themeMode == other.themeMode;

  @override
  int get hashCode =>
      Object.hash(defaultDisplayUnit, defaultKerf, defaultReusable, themeMode);
}
