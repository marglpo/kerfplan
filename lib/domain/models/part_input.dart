import '../units/length.dart';
import 'quantity.dart';

enum PartValidationError { lengthPositive, nameTooLong }

final class PartValidationException implements Exception {
  const PartValidationException(this.error);
  final PartValidationError error;
}

final class PartInput {
  const PartInput._(this.length, this.quantity, this.name);
  static const maxNameLength = 100;

  factory PartInput({
    required Length length,
    required int quantity,
    String? name,
  }) {
    if (length.ticks <= 0) {
      throw const PartValidationException(PartValidationError.lengthPositive);
    }
    Quantity.validate(quantity);
    if (validateName(name) case final error?) {
      throw PartValidationException(error);
    }
    final normalized = name?.trim();
    return PartInput._(
      length,
      quantity,
      normalized == null || normalized.isEmpty ? null : normalized,
    );
  }

  final Length length;
  final int quantity;
  final String? name;

  static PartValidationError? validateName(String? name) =>
      (name?.trim().runes.length ?? 0) > maxNameLength
      ? PartValidationError.nameTooLong
      : null;
}
