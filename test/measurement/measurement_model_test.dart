import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/domain/models/measurement_system.dart';
import 'package:kerfplan/domain/units/display_unit.dart';
import 'package:kerfplan/domain/units/length.dart';
import 'package:kerfplan/domain/units/stock_length_presets.dart';
import 'package:kerfplan/l10n/app_localizations_de.dart';
import 'package:kerfplan/l10n/app_localizations_en.dart';
import 'package:kerfplan/presentation/shared/inputs/length_input.dart';

void main() {
  test('stable storage and unit-family mapping', () {
    expect(MeasurementSystem.metric.storageValue, 'metric');
    expect(MeasurementSystem.imperial.storageValue, 'imperial');
    expect(MeasurementSystem.fromStorage('metric'), MeasurementSystem.metric);
    expect(
      MeasurementSystem.fromStorage('imperial'),
      MeasurementSystem.imperial,
    );
    expect(() => MeasurementSystem.fromStorage('other'), throwsFormatException);
    for (final unit in [DisplayUnit.mm, DisplayUnit.cm, DisplayUnit.m]) {
      expect(MeasurementSystem.fromUnit(unit), MeasurementSystem.metric);
    }
    for (final unit in [DisplayUnit.inch, DisplayUnit.ftIn]) {
      expect(MeasurementSystem.fromUnit(unit), MeasurementSystem.imperial);
    }
    expect(MeasurementSystem.metric.defaultUnit, DisplayUnit.mm);
    expect(MeasurementSystem.imperial.defaultUnit, DisplayUnit.ftIn);
  });

  for (final (locale, system) in [
    (const Locale('en', 'US'), MeasurementSystem.imperial),
    (const Locale('en', 'GB'), MeasurementSystem.metric),
    (const Locale('en', 'AU'), MeasurementSystem.metric),
    (const Locale('en', 'CA'), MeasurementSystem.metric),
    (const Locale('de', 'DE'), MeasurementSystem.metric),
    (const Locale('es', 'MX'), MeasurementSystem.metric),
    (const Locale('en'), MeasurementSystem.metric),
  ]) {
    test('$locale recommends $system without using language', () {
      expect(MeasurementSystem.recommend(locale.countryCode), system);
    });
  }

  test('metric and imperial shortcuts retain exact canonical ticks', () {
    expect(StockLengthPresets.metric.map((e) => e.ticks), [
      10000000,
      20000000,
      24000000,
      30000000,
      40000000,
      60000000,
    ]);
    expect(StockLengthPresets.imperial.map((e) => e.ticks), [
      24384000,
      30480000,
      36576000,
      48768000,
      60960000,
    ]);
    expect(
      StockLengthPresets.forUnit(DisplayUnit.inch),
      StockLengthPresets.imperial,
    );
    expect(
      StockLengthPresets.forUnit(DisplayUnit.m),
      StockLengthPresets.metric,
    );
  });

  test(
    'preset labels follow project unit and metric display decimal locale',
    () {
      final en = AppLocalizationsEn();
      final de = AppLocalizationsDe();
      expect(
        displayLength(en, StockLengthPresets.metric.last, DisplayUnit.m),
        '6 m',
      );
      expect(
        displayLength(en, StockLengthPresets.imperial.first, DisplayUnit.inch),
        '96"',
      );
      expect(
        displayLength(de, Length.fromMillimeters('2.4'), DisplayUnit.mm),
        '2,4 mm',
      );
    },
  );

  test(
    'preset entry and untouched approximate imperial length preserve ticks',
    () {
      final exact = Length.fromMillimeters('2438.41');
      final controller = LengthEditingController(
        unit: DisplayUnit.ftIn,
        initialLength: exact,
      );
      try {
        expect(controller.length.ticks, exact.ticks);
        controller.setExactLength(StockLengthPresets.imperial.first);
        expect(controller.length.ticks, 24384000);
        controller.changeUnit(DisplayUnit.mm);
        expect(controller.length.ticks, 24384000);
      } finally {
        controller.dispose();
      }
    },
  );
}
