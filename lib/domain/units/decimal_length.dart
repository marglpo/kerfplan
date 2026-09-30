import 'display_unit.dart';
import 'length.dart';

enum LengthInputError { required, invalid, precision, outOfRange }

final class LengthInputException implements Exception {
  const LengthInputException(this.error);
  final LengthInputError error;
}

/// Exact decimal entry. Zero is accepted only when explicitly requested.
abstract final class DecimalLength {
  static int ticksPerUnit(DisplayUnit unit) => switch (unit) {
    DisplayUnit.mm => 10000,
    DisplayUnit.cm => 100000,
    DisplayUnit.m => 10000000,
    DisplayUnit.inch || DisplayUnit.ftIn => Length.ticksPerInch,
  };

  static Length parse(String text, DisplayUnit unit, {bool allowZero = false}) {
    final normalized = text.trim().replaceAll(',', '.');
    if (normalized.isEmpty) {
      throw const LengthInputException(LengthInputError.required);
    }
    if (!RegExp(r'^\d+(?:\.\d+)?$').hasMatch(normalized)) {
      throw const LengthInputException(LengthInputError.invalid);
    }
    final parts = normalized.split('.');
    final fraction = parts.length == 1
        ? ''
        : parts[1].replaceFirst(RegExp(r'0+$'), '');
    // No supported unit can express a nonzero eighth decimal place in ticks.
    if (fraction.length > 7) {
      throw const LengthInputException(LengthInputError.precision);
    }
    final denominator = BigInt.from(10).pow(fraction.length);
    final numerator =
        BigInt.parse('${parts[0]}$fraction') * BigInt.from(ticksPerUnit(unit));
    if (!allowZero && numerator == BigInt.zero) {
      throw const LengthInputException(LengthInputError.invalid);
    }
    if (numerator % denominator != BigInt.zero) {
      throw const LengthInputException(LengthInputError.precision);
    }
    final ticks = numerator ~/ denominator;
    if (ticks > BigInt.from(Length.maxTicks)) {
      throw const LengthInputException(LengthInputError.outOfRange);
    }
    return Length.fromTicks(ticks.toInt());
  }

  /// Long division only; never converts through double. Repeating inch values
  /// are marked approximate for display and must not replace stored lengths.
  static ({String text, bool approximate}) format(
    Length length,
    DisplayUnit unit,
  ) {
    final divisor = ticksPerUnit(unit);
    final whole = length.ticks ~/ divisor;
    var remainder = length.ticks % divisor;
    var fraction = '';
    for (var i = 0; remainder != 0 && i < 8; i++) {
      remainder *= 10;
      fraction += '${remainder ~/ divisor}';
      remainder %= divisor;
    }
    return (
      text: fraction.isEmpty ? '$whole' : '$whole.$fraction',
      approximate: remainder != 0,
    );
  }
}
