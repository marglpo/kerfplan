import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/domain/units/length.dart';

void main() {
  group('Exact length conversions', () {
    for (final example in {
      '1': 10000,
      '3': 30000,
      '25.4': 254000,
      '100': 1000000,
      '0.0001': 1,
    }.entries) {
      test('${example.key} mm = ${example.value} ticks', () {
        expect(Length.fromMillimeters(example.key).ticks, example.value);
      });
    }

    test('1/16 inch = 15,875 ticks', () {
      expect(Length.fromInchFraction(1, 16).ticks, 15875);
    });

    test('16 additions of 1/16 inch equal exactly one inch', () {
      var total = Length.fromTicks(0);
      for (var i = 0; i < 16; i++) {
        total = total + Length.fromInchFraction(1, 16);
      }
      expect(total, Length.fromInchFraction(1, 1));
      expect(total, Length.fromMillimeters('25.4'));
    });

    test('decimal addition and subtraction preserve exact ticks', () {
      expect(
        Length.fromMillimeters('0.1') + Length.fromMillimeters('0.2'),
        Length.fromMillimeters('0.3'),
      );
      expect(
        Length.fromMillimeters('3') - Length.fromMillimeters('1'),
        Length.fromMillimeters('2'),
      );
    });
  });

  test('value equality, hashing and comparison agree', () {
    final a = Length.fromMillimeters('1');
    final b = Length.fromTicks(10000);
    final c = Length.fromMillimeters('3');
    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect({a, b, c}, hasLength(2));
    expect(a.compareTo(c), lessThan(0));
    expect(a.compareTo(b), 0);
    expect(a < c, isTrue);
    expect(a <= b, isTrue);
    expect(c > a, isTrue);
    expect(b >= a, isTrue);
  });

  test('negative lengths and subtraction below zero are rejected', () {
    expect(() => Length.fromTicks(-1), throwsRangeError);
    expect(() => Length.fromMillimeters('-1'), throwsFormatException);
    expect(() => Length.fromInchFraction(-1, 16), throwsRangeError);
    expect(() => Length.fromTicks(0) - Length.fromTicks(1), throwsRangeError);
  });

  test('invalid fractions and sub-tick values are rejected', () {
    expect(() => Length.fromInchFraction(1, 0), throwsRangeError);
    expect(() => Length.fromInchFraction(1, -16), throwsRangeError);
    expect(() => Length.fromInchFraction(1, 3), throwsArgumentError);
    expect(() => Length.fromMillimeters('0.00001'), throwsFormatException);
    expect(() => Length.fromMillimeters('NaN'), throwsFormatException);
  });

  test('64-bit limits are exact and overflow does not wrap', () {
    final maximum = Length.fromTicks(Length.maxTicks);
    expect(Length.fromMillimeters('922337203685477.5807'), maximum);
    expect(() => maximum + Length.fromTicks(1), throwsRangeError);
    expect(
      () => Length.fromMillimeters('922337203685477.5808'),
      throwsRangeError,
    );
    expect(() => Length.fromInchFraction(Length.maxTicks, 1), throwsRangeError);
  });
}
