enum QuantityError { required, invalid, tooLarge }

final class QuantityException implements Exception {
  const QuantityException(this.error);
  final QuantityError error;
}

abstract final class Quantity {
  static const maximum = 9999;

  static void validate(int value) {
    if (value < 1) throw const QuantityException(QuantityError.invalid);
    if (value > maximum) throw const QuantityException(QuantityError.tooLarge);
  }

  static int parse(String text) {
    final value = text.trim();
    if (value.isEmpty) throw const QuantityException(QuantityError.required);
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      throw const QuantityException(QuantityError.invalid);
    }
    final parsed = int.tryParse(value);
    if (parsed == null) throw const QuantityException(QuantityError.tooLarge);
    validate(parsed);
    return parsed;
  }
}
