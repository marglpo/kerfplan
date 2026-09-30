import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/services/export/report_file_name.dart';

void main() {
  String name(String value) => reportFileName(
    value,
    DateTime(2026, 9, 26),
    brand: 'KerfPlan',
    fallback: 'Cut Plan',
  );
  test('useful name includes supplied date and PDF extension', () {
    expect(name('Garage Frame'), 'KerfPlan_Garage_Frame_2026-09-26.pdf');
  });
  test('invalid punctuation and repeated whitespace collapse safely', () {
    expect(name('Frame / A:B?*'), 'KerfPlan_Frame_A_B_2026-09-26.pdf');
    expect(name('  Frame  ___ A  '), 'KerfPlan_Frame_A_2026-09-26.pdf');
  });
  test('blank and invalid names fall back without path traversal', () {
    for (final value in ['', '  ', '../:?*\\', '\u0000']) {
      expect(name(value), 'KerfPlan_Cut_Plan_2026-09-26.pdf');
    }
  });
  test('long names are bounded while preserving Cyrillic', () {
    expect(name('Каркас гаража'), 'KerfPlan_Каркас_гаража_2026-09-26.pdf');
    expect(name('a' * 500).length, lessThan(90));
  });
}
