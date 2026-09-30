import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kerfplan/domain/units/display_unit.dart';
import 'package:kerfplan/services/export/cut_report_pdf.dart';

import '../domain/optimizer/optimizer_test_support.dart';
import '../support/report_fixture.dart';

void main() async {
  await initializeDateFormatting('en');
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'bundled fonts cover Latin, Cyrillic and report measurement symbols',
    () async {
      final regular = TtfParser(
        await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'),
      );
      final bold = TtfParser(
        await rootBundle.load('assets/fonts/NotoSans-Bold.ttf'),
      );
      final math = TtfParser(
        await rootBundle.load('assets/fonts/NotoSansMath-Regular.ttf'),
      );
      for (final rune
          in 'KerfPlan 0123456789 Каркас Ёж Стойка café façade Maße × — · ≈ \' " 1/16'
              .runes) {
        expect(
          regular.charToGlyphIndexMap.containsKey(rune) ||
              math.charToGlyphIndexMap.containsKey(rune),
          isTrue,
        );
        expect(
          bold.charToGlyphIndexMap.containsKey(rune) ||
              math.charToGlyphIndexMap.containsKey(rune),
          isTrue,
        );
      }
    },
  );
  final cases = {
    'fixed': reportFor(
      fixed([stock(1000)], [part(400, quantity: 2, name: 'Brace')]),
    ),
    'buy': reportFor(buy(6000, [part(1800, quantity: 10, name: 'Upright')])),
    'partial': reportFor(
      fixed([stock(1000)], [part(400, quantity: 3), part(1200, id: 'large')]),
    ),
    'all_unplaced': reportFor(fixed([stock(1000)], [part(1200, quantity: 3)])),
    'large': reportFor(
      buy(6000, [part(125, quantity: 150, name: 'Short brace')]),
    ),
    'many_bars': reportFor(
      buy(1000, [part(990, quantity: 100, name: 'Upright')]),
    ),
    'trim': reportFor(fixed([stock(1000)], [part(400, quantity: 2)], trim: 10)),
    'imperial': reportFor(
      buy(2439, [part(1200, quantity: 2)]),
      unit: DisplayUnit.ftIn,
    ),
    'unicode': reportFor(
      buy(6000, [part(1800, quantity: 10, name: 'Стойка — côté')]),
      name: 'Каркас гаража',
      material: 'Сталь 40×20 · acier',
      note: 'Проверить размеры. Café, façade, Maße, 1/16".',
    ),
    'long_note': reportFor(
      fixed([stock(1000)], [part(400, quantity: 2, name: 'W' * 100)]),
      name: 'W' * 80,
      material: 'M' * 120,
      note: 'N' * 500,
    ),
  };
  for (final entry in cases.entries) {
    test(
      '${entry.key} PDF generates offline with embedded fonts and valid pages',
      () async {
        final bytes = await HttpOverrides.runZoned(
          () => CutReportPdf().build(entry.value),
          createHttpClient: (_) =>
              throw StateError('Report must not access a network'),
        );
        expect(bytes.length, greaterThan(1000));
        expect(ascii.decode(bytes.take(5).toList()), '%PDF-');
        final content = latin1.decode(bytes);
        expect(content, contains('/FontFile2'));
        final pages = RegExp(r'/Type\s*/Page\b').allMatches(content).length;
        expect(pages, greaterThanOrEqualTo(1));
        if (entry.key == 'large' || entry.key == 'many_bars') {
          expect(pages, greaterThan(1));
        }
        // Optional local QA artifacts, never enabled or called by the app.
        const sampleDirectory = String.fromEnvironment('REPORT_SAMPLE_DIR');
        if (sampleDirectory.isNotEmpty) {
          await Directory(sampleDirectory).create(recursive: true);
          await File('$sampleDirectory/${entry.key}.pdf').writeAsBytes(bytes);
        }
      },
    );
  }
}
