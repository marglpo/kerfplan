enum OptimizationFailure {
  invalidPart,
  invalidStock,
  noFixedStock,
  missingBuyStock,
  noUsableBuyStock,
  arithmeticOverflow,
}

/// Machine-readable failure, never a localized UI message.
final class OptimizationValidationException implements Exception {
  const OptimizationValidationException(this.reason, {this.sourceId});

  final OptimizationFailure reason;
  final String? sourceId;

  @override
  String toString() =>
      'OptimizationValidationException(${reason.name}, $sourceId)';
}
