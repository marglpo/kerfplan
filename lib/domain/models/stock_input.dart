import '../units/length.dart';
import 'quantity.dart';

enum StockValidationError {
  lengthPositive,
  quantityRequired,
  quantityInvalid,
  quantityTooLarge,
  labelTooLong,
}

final class StockValidationException implements Exception {
  const StockValidationException(this.error);
  final StockValidationError error;
}

final class StockInput {
  const StockInput._(this.length, this.quantity, this.label);

  static const maxQuantity = Quantity.maximum;
  static const maxLabelLength = 80;

  factory StockInput({
    required Length length,
    required int quantity,
    String? label,
  }) {
    if (length.ticks <= 0) {
      throw const StockValidationException(StockValidationError.lengthPositive);
    }
    validateQuantity(quantity);
    final normalized = label?.trim();
    if (validateLabel(normalized) case final error?) {
      throw StockValidationException(error);
    }
    return StockInput._(
      length,
      quantity,
      normalized == null || normalized.isEmpty ? null : normalized,
    );
  }

  final Length length;
  final int quantity;
  final String? label;

  static StockValidationException _quantityError(QuantityException error) =>
      StockValidationException(switch (error.error) {
        QuantityError.required => StockValidationError.quantityRequired,
        QuantityError.invalid => StockValidationError.quantityInvalid,
        QuantityError.tooLarge => StockValidationError.quantityTooLarge,
      });

  static void validateQuantity(int quantity) {
    try {
      Quantity.validate(quantity);
    } on QuantityException catch (error) {
      throw _quantityError(error);
    }
  }

  static int parseQuantity(String text) {
    try {
      return Quantity.parse(text);
    } on QuantityException catch (error) {
      throw _quantityError(error);
    }
  }

  static StockValidationError? validateLabel(String? label) =>
      (label?.trim().runes.length ?? 0) > maxLabelLength
      ? StockValidationError.labelTooLong
      : null;
}
