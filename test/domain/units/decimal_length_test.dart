import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/domain/units/decimal_length.dart';
import 'package:kerfplan/domain/units/display_unit.dart';
import 'package:kerfplan/domain/units/length.dart';
import 'package:kerfplan/presentation/shared/inputs/length_input.dart';

void main() {
  for (final sample in [
    ('6000', DisplayUnit.mm, 60000000),
    ('244', DisplayUnit.cm, 24400000),
    ('2.44', DisplayUnit.m, 24400000),
    ('2,44', DisplayUnit.m, 24400000),
    ('0.0001', DisplayUnit.mm, 1),
    ('0.00001', DisplayUnit.cm, 1),
    ('0.0000001', DisplayUnit.m, 1),
    ('0.0625', DisplayUnit.inch, 15875),
    ('1', DisplayUnit.ftIn, 254000),
    ('2.4400000000', DisplayUnit.m, 24400000),
  ]) {
    test('${sample.$1} ${sample.$2.name} converts to exact ticks', () {
      expect(DecimalLength.parse(sample.$1, sample.$2).ticks, sample.$3);
    });
  }

  test('invalid, zero, negative and excess-precision input is rejected', () {
    for (final input in [
      '',
      '0',
      '-1',
      'word',
      'NaN',
      '1.2.3',
      '1,2.3',
      '1e3',
      '0.00001',
    ]) {
      expect(
        () => DecimalLength.parse(input, DisplayUnit.mm),
        throwsA(isA<LengthInputException>()),
        reason: input,
      );
    }
    expect(
      () => DecimalLength.parse('0.0001', DisplayUnit.inch),
      throwsA(isA<LengthInputException>()),
    );
  });

  test('integer limit is exact without overflow or rounding', () {
    expect(
      DecimalLength.parse('922337203685477.5807', DisplayUnit.mm).ticks,
      Length.maxTicks,
    );
    expect(
      () => DecimalLength.parse('922337203685477.5808', DisplayUnit.mm),
      throwsA(isA<LengthInputException>()),
    );
    expect(
      DecimalLength.format(
        Length.fromTicks(Length.maxTicks),
        DisplayUnit.mm,
      ).text,
      '922337203685477.5807',
    );
  });

  test('metric formatting round-trips and inch fractions are finite', () {
    for (final unit in [DisplayUnit.mm, DisplayUnit.cm, DisplayUnit.m]) {
      for (final ticks in [1, 15875, 24400000, Length.maxTicks]) {
        final length = Length.fromTicks(ticks);
        final formatted = DecimalLength.format(length, unit);
        expect(formatted.approximate, isFalse);
        expect(DecimalLength.parse(formatted.text, unit), length);
      }
    }
    expect(
      DecimalLength.format(Length.fromInchFraction(1, 16), DisplayUnit.inch),
      (text: '0.0625', approximate: false),
    );
  });

  test(
    'imperial editing preserves an existing repeating value until changed',
    () {
      final original = Length.fromMillimeters('1');
      final controller = LengthEditingController(
        unit: DisplayUnit.ftIn,
        initialLength: original,
      );
      addTearDown(controller.dispose);
      expect(controller.showsApproximation, isTrue);
      expect(controller.length, original);
      controller.text = '0.0625';
      expect(controller.length.ticks, 15875);
      controller.text = '0.0001';
      expect(() => controller.length, throwsA(isA<LengthInputException>()));
    },
  );
}
