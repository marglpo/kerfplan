import '../units/display_unit.dart';

/// Preferred family for new cut lists. Existing projects retain their units.
enum MeasurementSystem {
  metric('metric'),
  imperial('imperial');

  const MeasurementSystem(this.storageValue);
  final String storageValue;

  DisplayUnit get defaultUnit =>
      this == metric ? DisplayUnit.mm : DisplayUnit.ftIn;

  bool contains(DisplayUnit unit) => switch (this) {
    metric =>
      unit == DisplayUnit.mm || unit == DisplayUnit.cm || unit == DisplayUnit.m,
    imperial => unit == DisplayUnit.inch || unit == DisplayUnit.ftIn,
  };

  static MeasurementSystem fromUnit(DisplayUnit unit) =>
      unit == DisplayUnit.inch || unit == DisplayUnit.ftIn ? imperial : metric;

  static MeasurementSystem fromStorage(String value) => switch (value) {
    'metric' => metric,
    'imperial' => imperial,
    _ => throw FormatException('Unknown measurement system', value),
  };

  /// A recommendation only; the user can choose either system.
  static MeasurementSystem recommend(String? countryCode) =>
      switch (countryCode?.toUpperCase()) {
        'US' || 'LR' || 'MM' => imperial,
        _ => metric,
      };
}
