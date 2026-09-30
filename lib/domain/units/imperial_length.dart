import 'decimal_length.dart';
import 'length.dart';

/// Sixteenth-inch entry and display, using integer arithmetic exclusively.
abstract final class ImperialLength {
  static const ticksPerSixteenth = 15875;

  static Length parse({
    String feet = '0',
    required String inches,
    required int sixteenths,
    bool feetAndInches = false,
    bool allowZero = false,
  }) {
    BigInt component(String text) {
      if (!RegExp(r'^\d+$').hasMatch(text.trim())) {
        throw const LengthInputException(LengthInputError.invalid);
      }
      return BigInt.parse(text.trim());
    }

    final ft = component(feet);
    final inch = component(inches);
    if (sixteenths < 0 ||
        sixteenths > 15 ||
        (feetAndInches && inch > BigInt.from(11))) {
      throw const LengthInputException(LengthInputError.invalid);
    }
    final ticks =
        (ft * BigInt.from(12) + inch) * BigInt.from(Length.ticksPerInch) +
        BigInt.from(sixteenths * ticksPerSixteenth);
    if (!allowZero && ticks == BigInt.zero) {
      throw const LengthInputException(LengthInputError.invalid);
    }
    if (ticks > BigInt.from(Length.maxTicks)) {
      throw const LengthInputException(LengthInputError.outOfRange);
    }
    return Length.fromTicks(ticks.toInt());
  }

  static String fraction(int sixteenths) {
    RangeError.checkValueInInterval(sixteenths, 0, 15);
    if (sixteenths == 0) return '0';
    final divisor = sixteenths.gcd(16);
    return '${sixteenths ~/ divisor}/${16 ~/ divisor}';
  }

  /// Nearest sixteenth for display only. Avoids adding to a max-int tick value.
  static ({int feet, int inches, int sixteenths, bool approximate}) components(
    Length length, {
    required bool feetAndInches,
  }) {
    final remainder = length.ticks % ticksPerSixteenth;
    final rounded =
        length.ticks ~/ ticksPerSixteenth +
        (remainder * 2 >= ticksPerSixteenth ? 1 : 0);
    final wholeInches = rounded ~/ 16;
    return (
      feet: feetAndInches ? wholeInches ~/ 12 : 0,
      inches: feetAndInches ? wholeInches % 12 : wholeInches,
      sixteenths: rounded % 16,
      approximate: remainder != 0,
    );
  }

  static ({String text, bool approximate}) format(
    Length length, {
    required bool feetAndInches,
  }) {
    final c = components(length, feetAndInches: feetAndInches);
    final suffix = c.sixteenths == 0 ? '' : '-${fraction(c.sixteenths)}';
    return (
      text: '${feetAndInches ? "${c.feet}' " : ''}${c.inches}$suffix"',
      approximate: c.approximate,
    );
  }
}
