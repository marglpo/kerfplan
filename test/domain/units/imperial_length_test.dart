import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/domain/units/imperial_length.dart';
import 'package:kerfplan/domain/units/decimal_length.dart';
import 'package:kerfplan/domain/units/display_unit.dart';
import 'package:kerfplan/domain/units/length.dart';
import 'package:kerfplan/presentation/shared/inputs/length_input.dart';
import 'package:kerfplan/l10n/app_localizations_en.dart';

void main() {
  test('shared display formatter respects metric units and marks imperial rounding', () {
    final l10n = AppLocalizationsEn();
    final length = Length.fromMillimeters('6000');
    expect(displayLength(l10n, length, DisplayUnit.mm), '6000 mm');
    expect(displayLength(l10n, length, DisplayUnit.cm), '600 cm');
    expect(displayLength(l10n, length, DisplayUnit.m), '6 m');
    expect(
      displayLength(l10n, Length.fromMillimeters('1'), DisplayUnit.inch),
      '≈ 0-1/16"',
    );
  });
  for (final sample in [(1, 15875), (2, 31750), (4, 63500), (8, 127000)]) {
    test('${sample.$1}/16 inch exact ticks', () {
      expect(
        ImperialLength.parse(inches: '0', sixteenths: sample.$1).ticks,
        sample.$2,
      );
    });
  }
  test('whole inch and sixteen sixteenths have identical ticks', () {
    final inch = ImperialLength.parse(inches: '1', sixteenths: 0);
    expect(inch.ticks, 254000);
    var total = Length.fromTicks(0);
    for (var i = 0; i < 16; i++) {
      total += ImperialLength.parse(inches: '0', sixteenths: 1);
    }
    expect(total, inch);
  });
  test('8 feet equals 96 inches exactly', () {
    final feet = ImperialLength.parse(
      feet: '8',
      inches: '0',
      sixteenths: 0,
      feetAndInches: true,
    );
    expect(feet.ticks, 24384000);
    expect(feet, ImperialLength.parse(inches: '96', sixteenths: 0));
  });
  test('3 feet 11 and 5/8 inches matches decimal inches and millimeters', () {
    final length = ImperialLength.parse(
      feet: '3',
      inches: '11',
      sixteenths: 10,
      feetAndInches: true,
    );
    expect(length.ticks, 12096750);
    expect(length, DecimalLength.parse('47.625', DisplayUnit.inch));
    expect(length, Length.fromMillimeters('1209.675'));
    expect(ImperialLength.format(length, feetAndInches: true), (
      text: '3\' 11-5/8"',
      approximate: false,
    ));
    expect(ImperialLength.format(length, feetAndInches: false).text, '47-5/8"');
  });
  test('fractions reduce and exact sixteenth values round-trip', () {
    expect(ImperialLength.fraction(2), '1/8');
    expect(ImperialLength.fraction(8), '1/2');
    for (var i = 0; i < 16; i++) {
      final length = ImperialLength.parse(
        feet: '3',
        inches: '11',
        sixteenths: i,
        feetAndInches: true,
      );
      final c = ImperialLength.components(length, feetAndInches: true);
      expect(
        ImperialLength.parse(
          feet: '${c.feet}',
          inches: '${c.inches}',
          sixteenths: c.sixteenths,
          feetAndInches: true,
        ),
        length,
      );
      expect(c.approximate, isFalse);
    }
  });
  test('rejects invalid components, zero, fractions and overflow', () {
    for (final operation in <Length Function()>[
      () => ImperialLength.parse(
        inches: '12',
        sixteenths: 0,
        feetAndInches: true,
      ),
      () => ImperialLength.parse(inches: '0', sixteenths: 0),
      () => ImperialLength.parse(inches: '-1', sixteenths: 0),
      () => ImperialLength.parse(inches: '1.5', sixteenths: 0),
      () => ImperialLength.parse(inches: '1', sixteenths: 16),
      () => ImperialLength.parse(inches: '1', sixteenths: -1),
      () => ImperialLength.parse(
        feet: '999999999999999999999',
        inches: '1',
        sixteenths: 0,
      ),
    ]) {
      expect(operation, throwsA(isA<LengthInputException>()));
    }
    expect(
      ImperialLength.parse(
        feet: '0',
        inches: '0',
        sixteenths: 1,
        feetAndInches: true,
      ).ticks,
      15875,
    );
  });
  test(
    'display rounding carries feet and marks approximation without overflow',
    () {
      final length = Length.fromTicks(12 * 254000 - 1);
      expect(ImperialLength.format(length, feetAndInches: true), (
        text: '1\' 0"',
        approximate: true,
      ));
      expect(length.ticks, 12 * 254000 - 1);
      expect(
        ImperialLength.format(
          Length.fromTicks(Length.maxTicks),
          feetAndInches: true,
        ).approximate,
        isTrue,
      );
    },
  );
  test('unchanged non-sixteenth survives focus and only changes after component edits', () {
    final original = Length.fromMillimeters('1');
    final controller = LengthEditingController(
      unit: DisplayUnit.ftIn,
      initialLength: original,
    );
    addTearDown(controller.dispose);
    controller.inches.selection = const TextSelection.collapsed(offset: 1);
    expect(controller.length, original);
    expect(controller.showsApproximation, isTrue);
    controller.sixteenths = 2;
    expect(controller.length.ticks, 31750);
    expect(controller.showsApproximation, isFalse);
    controller.sixteenths = 1;
    expect(controller.length.ticks, 15875);
  });
}
