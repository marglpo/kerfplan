import '../units/length.dart';
import 'placed_part.dart';

/// Only an opened, used physical bar is included in a result.
final class OptimizationBar {
  OptimizationBar({
    required this.barIndex,
    required this.sourceStockId,
    required this.physicalStockInstanceIndex,
    required this.stockLength,
    required this.usableLength,
    required Iterable<PlacedPart> placedParts,
    required this.kerfLoss,
    required this.trimLoss,
    required this.tailLeftover,
    required this.isTailReusable,
  }) : placedParts = List.unmodifiable(placedParts);

  final int barIndex;
  final String? sourceStockId;

  /// Zero-based per stock source. Buy bars have no physical inventory identity.
  final int? physicalStockInstanceIndex;
  final Length stockLength;
  final Length usableLength;
  final List<PlacedPart> placedParts;
  final Length kerfLoss;
  final Length trimLoss;
  final Length tailLeftover;
  final bool isTailReusable;
}
