/// Filename punctuation is technical syntax. The brand and fallback come from
/// localization. Limit Unicode code points without splitting surrogate pairs.
String reportFileName(
  String name,
  DateTime generatedAt, {
  required String brand,
  required String fallback,
}) {
  String clean(String value) => value
      .replaceAll(RegExp(r'[^\p{L}\p{N}]+', unicode: true), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');
  var stem = clean(String.fromCharCodes(name.runes.take(48)));
  if (stem.isEmpty) stem = clean(fallback);
  final date = generatedAt.toLocal();
  final stamp =
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
  return '${clean(brand)}_${stem}_$stamp.pdf';
}
