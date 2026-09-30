import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/domain/models/cut_settings_input.dart';
import 'package:kerfplan/domain/models/part_input.dart';
import 'package:kerfplan/domain/models/stock_input.dart';
import 'package:kerfplan/domain/models/stock_trim_warning.dart';
import 'package:kerfplan/domain/units/decimal_length.dart';
import 'package:kerfplan/domain/units/display_unit.dart';
import 'package:kerfplan/domain/units/imperial_length.dart';
import 'package:kerfplan/domain/units/length.dart';
import 'package:kerfplan/presentation/shared/inputs/length_input.dart';

void main() {
  test('all cut settings permit zero; stock and parts still reject it', () {
    final zero = Length.fromTicks(0);
    final settings = CutSettingsInput(
      displayUnit: DisplayUnit.mm,
      kerf: zero,
      endTrim: zero,
      minReusable: zero,
    );
    expect([
      settings.kerf,
      settings.endTrim,
      settings.minReusable,
    ], everyElement(zero));
    expect(
      () => StockInput(length: zero, quantity: 1),
      throwsA(isA<StockValidationException>()),
    );
    expect(
      () => PartInput(length: zero, quantity: 1),
      throwsA(isA<PartValidationException>()),
    );
  });

  for (final unit in DisplayUnit.values) {
    test('$unit zero is opt-in, negatives are always invalid', () {
      expect(DecimalLength.parse('0', unit, allowZero: true).ticks, 0);
      expect(
        () => DecimalLength.parse('0', unit),
        throwsA(isA<LengthInputException>()),
      );
      expect(
        () => DecimalLength.parse('-1', unit, allowZero: true),
        throwsA(isA<LengthInputException>()),
      );
      expect(() => Length.fromTicks(-1), throwsArgumentError);
    });
  }

  test('imperial zero is opt-in; negative components remain invalid', () {
    expect(
      ImperialLength.parse(inches: '0', sixteenths: 0, allowZero: true).ticks,
      0,
    );
    expect(
      () => ImperialLength.parse(inches: '0', sixteenths: 0),
      throwsA(isA<LengthInputException>()),
    );
    expect(
      () => ImperialLength.parse(inches: '-1', sixteenths: 0, allowZero: true),
      throwsA(isA<LengthInputException>()),
    );
    expect(
      () => ImperialLength.parse(
        feet: '-1',
        inches: '0',
        sixteenths: 0,
        feetAndInches: true,
        allowZero: true,
      ),
      throwsA(isA<LengthInputException>()),
    );
  });

  for (final ticks in [0, 30000, 123457, Length.maxTicks]) {
    test('unit rebasing preserves $ticks ticks without editing', () {
      final controller = LengthEditingController(
        unit: DisplayUnit.mm,
        initialLength: Length.fromTicks(ticks),
        allowZero: true,
      );
      addTearDown(controller.dispose);
      for (final unit in [
        DisplayUnit.inch,
        DisplayUnit.ftIn,
        DisplayUnit.cm,
        DisplayUnit.m,
        DisplayUnit.mm,
      ]) {
        controller.changeUnit(unit);
        expect(controller.length.ticks, ticks);
        expect(controller.unit, unit);
      }
    });
  }

  test(
    'unit changes preserve pending edits, fraction edits become authoritative',
    () {
      final controller = LengthEditingController(
        unit: DisplayUnit.mm,
        initialLength: Length.fromTicks(30000),
        allowZero: true,
      );
      addTearDown(controller.dispose);
      controller.text = '4.0001';
      controller.changeUnit(DisplayUnit.inch);
      expect(controller.length.ticks, 40001);
      expect(controller.showsApproximation, isTrue);
      controller.sixteenths = 4;
      expect(controller.length.ticks, 63500);
      controller.changeUnit(DisplayUnit.mm);
      expect(controller.text, '6.35');
      expect(controller.length.ticks, 63500);
    },
  );

  test('invalid pending input prevents rebasing without losing the text', () {
    final controller = LengthEditingController(
      unit: DisplayUnit.mm,
      allowZero: true,
    );
    addTearDown(controller.dispose);
    controller.text = '-1';
    expect(
      () => controller.changeUnit(DisplayUnit.inch),
      throwsA(isA<LengthInputException>()),
    );
    expect(controller.unit, DisplayUnit.mm);
    expect(controller.text, '-1');
  });

  for (final sample in [
    (<int>[], 500, StockTrimWarning.none),
    ([1000], 500, StockTrimWarning.allUnusable),
    ([1000], 499, StockTrimWarning.none),
    ([1000, 2000], 600, StockTrimWarning.someUnusable),
    ([1000, 2000], 1000, StockTrimWarning.allUnusable),
  ]) {
    test('trim warning ${sample.$1} with trim ${sample.$2}', () {
      expect(
        stockTrimWarning(
          sample.$1.map((n) => Length.fromTicks(n * 10000)),
          Length.fromTicks(sample.$2 * 10000),
        ),
        sample.$3,
      );
    });
  }
  test('trim comparison does not overflow for maximum Length', () {
    expect(
      stockTrimWarning([
        Length.fromTicks(Length.maxTicks),
      ], Length.fromTicks(Length.maxTicks)),
      StockTrimWarning.allUnusable,
    );
  });
}
