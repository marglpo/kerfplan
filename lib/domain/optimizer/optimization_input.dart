import '../models/inventory_mode.dart';
import '../units/length.dart';

/// Repository-independent snapshot. Validation occurs at the optimizer boundary.
/// Length already rejects negative measurements and signed 64-bit overflow.
final class OptimizationInput {
  OptimizationInput({
    required this.mode,
    Iterable<OptimizationStock> fixedStock = const [],
    this.buyStockLength,
    required Iterable<OptimizationPartGroup> parts,
    required this.kerf,
    required this.endTrim,
    required this.minReusable,
  }) : fixedStock = List.unmodifiable(fixedStock),
       parts = List.unmodifiable(parts);

  final InventoryMode mode;
  final List<OptimizationStock> fixedStock;
  final Length? buyStockLength;
  final List<OptimizationPartGroup> parts;
  final Length kerf;
  final Length endTrim;
  final Length minReusable;
}

final class OptimizationStock {
  const OptimizationStock({
    required this.sourceStockId,
    required this.length,
    required this.quantity,
    required this.stableOrder,
  });

  final String sourceStockId;
  final Length length;
  final int quantity;
  final int stableOrder;
}

final class OptimizationPartGroup {
  const OptimizationPartGroup({
    required this.sourcePartId,
    this.name,
    required this.length,
    required this.quantity,
    required this.stableOrder,
  });

  final String sourcePartId;
  final String? name;
  final Length length;
  final int quantity;
  final int stableOrder;
}
