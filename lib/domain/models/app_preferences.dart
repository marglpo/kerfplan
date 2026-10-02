import '../units/display_unit.dart';
import '../units/length.dart';
import 'app_theme_mode.dart';
import 'app_language.dart';
import 'measurement_system.dart';

/// Length enforces nonnegative, exact ticks. Zero is valid for both defaults.
final class AppPreferences {
  const AppPreferences({
    required this.defaultDisplayUnit,
    required this.defaultKerf,
    required this.defaultReusable,
    required this.themeMode,
    this.language = AppLanguage.system,
    this.measurementSystem = MeasurementSystem.metric,
    this.onboardingCompleted = false,
  });

  static final defaults = AppPreferences(
    defaultDisplayUnit: DisplayUnit.mm,
    defaultKerf: Length.fromMillimeters('3'),
    defaultReusable: Length.fromMillimeters('100'),
    themeMode: AppThemeMode.system,
    language: AppLanguage.system,
    measurementSystem: MeasurementSystem.metric,
    onboardingCompleted: false,
  );

  final DisplayUnit defaultDisplayUnit;
  final Length defaultKerf;
  final Length defaultReusable;
  final AppThemeMode themeMode;
  final AppLanguage language;
  final MeasurementSystem measurementSystem;
  final bool onboardingCompleted;

  AppPreferences copyWith({
    DisplayUnit? defaultDisplayUnit,
    Length? defaultKerf,
    Length? defaultReusable,
    AppThemeMode? themeMode,
    AppLanguage? language,
    MeasurementSystem? measurementSystem,
    bool? onboardingCompleted,
  }) => AppPreferences(
    defaultDisplayUnit: defaultDisplayUnit ?? this.defaultDisplayUnit,
    defaultKerf: defaultKerf ?? this.defaultKerf,
    defaultReusable: defaultReusable ?? this.defaultReusable,
    themeMode: themeMode ?? this.themeMode,
    language: language ?? this.language,
    measurementSystem: measurementSystem ?? this.measurementSystem,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
  );

  @override
  bool operator ==(Object other) =>
      other is AppPreferences &&
      defaultDisplayUnit == other.defaultDisplayUnit &&
      defaultKerf == other.defaultKerf &&
      defaultReusable == other.defaultReusable &&
      themeMode == other.themeMode &&
      language == other.language &&
      measurementSystem == other.measurementSystem &&
      onboardingCompleted == other.onboardingCompleted;

  @override
  int get hashCode => Object.hash(
    defaultDisplayUnit,
    defaultKerf,
    defaultReusable,
    themeMode,
    language,
    measurementSystem,
    onboardingCompleted,
  );
}
