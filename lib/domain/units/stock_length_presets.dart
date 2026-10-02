import 'display_unit.dart';
import 'length.dart';

/// Exact commercial stock shortcuts. These do not constrain manual entry.
abstract final class StockLengthPresets {
  static final metric = <Length>[
    for (final millimeters in [1000, 2000, 2400, 3000, 4000, 6000])
      Length.fromMillimeters('$millimeters'),
  ];

  static final imperial = <Length>[
    for (final feet in [8, 10, 12, 16, 20])
      Length.fromInchFraction(feet * 12, 1),
  ];

  static List<Length> forUnit(DisplayUnit unit) =>
      unit == DisplayUnit.inch || unit == DisplayUnit.ftIn ? imperial : metric;
}
