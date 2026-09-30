/// A non-negative length in ticks, where one tick is exactly 0.0001 mm.
///
/// Values fit SQLite's signed 64-bit INTEGER. Conversions reject quantities
/// that cannot be represented exactly; they never silently round.
final class Length implements Comparable<Length> {
  const Length._(this.ticks);

  static const int ticksPerMillimeter = 10000;
  static const int ticksPerInch = 254000;
  static const int maxTicks = 0x7FFFFFFFFFFFFFFF;

  final int ticks;

  factory Length.fromTicks(int ticks) {
    if (ticks < 0 || ticks > maxTicks) {
      throw RangeError.range(ticks, 0, maxTicks, 'ticks');
    }
    return Length._(ticks);
  }

  /// Accepts an exact decimal, e.g. '25.4', without using floating point.
  ///
  /// This is a domain constructor, not a localized UI input parser. Only
  /// unsigned decimal notation with at most four fractional digits is accepted.
  factory Length.fromMillimeters(String millimeters) {
    if (!RegExp(r'^\d+(?:\.\d{1,4})?$').hasMatch(millimeters)) {
      throw FormatException(
        'Expected millimeters with up to 4 decimal places',
        millimeters,
      );
    }
    final parts = millimeters.split('.');
    final fraction = parts.length == 2 ? parts[1].padRight(4, '0') : '0000';
    return Length._fromBigInt(
      BigInt.parse(parts[0]) * BigInt.from(ticksPerMillimeter) +
          BigInt.parse(fraction),
    );
  }

  /// Converts a fraction of an inch exactly, including improper fractions.
  /// Fractions smaller than the tick resolution are rejected, not rounded.
  factory Length.fromInchFraction(int numerator, int denominator) {
    if (numerator < 0) {
      throw RangeError.value(numerator, 'numerator', 'Must be non-negative');
    }
    if (denominator <= 0) {
      throw RangeError.value(denominator, 'denominator', 'Must be positive');
    }
    final scaled = BigInt.from(numerator) * BigInt.from(ticksPerInch);
    final divisor = BigInt.from(denominator);
    if (scaled % divisor != BigInt.zero) {
      throw ArgumentError(
        'Inch fraction must resolve to a whole number of ticks',
      );
    }
    return Length._fromBigInt(scaled ~/ divisor);
  }

  factory Length._fromBigInt(BigInt ticks) {
    if (ticks < BigInt.zero || ticks > BigInt.from(maxTicks)) {
      throw RangeError(
        'Length is outside the non-negative signed 64-bit range',
      );
    }
    return Length._(ticks.toInt());
  }

  Length operator +(Length other) =>
      Length._fromBigInt(BigInt.from(ticks) + BigInt.from(other.ticks));

  /// Throws [RangeError] if the result would be negative.
  Length operator -(Length other) => Length.fromTicks(ticks - other.ticks);

  @override
  int compareTo(Length other) => ticks.compareTo(other.ticks);

  bool operator <(Length other) => ticks < other.ticks;
  bool operator <=(Length other) => ticks <= other.ticks;
  bool operator >(Length other) => ticks > other.ticks;
  bool operator >=(Length other) => ticks >= other.ticks;

  @override
  bool operator ==(Object other) => other is Length && ticks == other.ticks;

  @override
  int get hashCode => ticks.hashCode;
}
