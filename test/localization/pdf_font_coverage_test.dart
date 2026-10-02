import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/pdf.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('bundled regular and bold Noto fonts cover all ten languages', () async {
    final regular = TtfParser(
      await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'),
    );
    final bold = TtfParser(
      await rootBundle.load('assets/fonts/NotoSans-Bold.ttf'),
    );
    final math = TtfParser(
      await rootBundle.load('assets/fonts/NotoSansMath-Regular.ttf'),
    );
    const samples =
        'áéíóúñ¿ äöüß éèêàçœ ãõçáê àèéìòù '
        'ąćęłńóśźż Жщяй çğıİöşü ЄєІіЇїҐґ';
    for (final rune in samples.runes) {
      expect(
        regular.charToGlyphIndexMap.containsKey(rune) ||
            math.charToGlyphIndexMap.containsKey(rune),
        isTrue,
        reason: 'Regular font missing U+${rune.toRadixString(16)}',
      );
      expect(
        bold.charToGlyphIndexMap.containsKey(rune) ||
            math.charToGlyphIndexMap.containsKey(rune),
        isTrue,
        reason: 'Bold font missing U+${rune.toRadixString(16)}',
      );
    }
  });
}
