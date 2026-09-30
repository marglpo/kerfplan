import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/stock_input.dart';
import '../domain/optimizer/optimization_result.dart';
import '../domain/repositories/stock_repository.dart';
import '../domain/units/length.dart';
import 'stock_providers.dart';

/// Preserve first appearance in bar order; eligibility belongs to the optimizer.
List<StockInput> groupReusableLeftovers(OptimizationResult result) {
  final quantities = <int, int>{};
  for (final bar in result.bars) {
    if (bar.tailLeftover.ticks > 0 && bar.isTailReusable) {
      quantities.update(
        bar.tailLeftover.ticks,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }
  }
  final inputs = <StockInput>[];
  for (final entry in quantities.entries) {
    // Keep the existing per-row quantity limit even for very large cut plans.
    var remaining = entry.value;
    while (remaining > 0) {
      final quantity = remaining > StockInput.maxQuantity
          ? StockInput.maxQuantity
          : remaining;
      inputs.add(
        StockInput(length: Length.fromTicks(entry.key), quantity: quantity),
      );
      remaining -= quantity;
    }
  }
  return List.unmodifiable(inputs);
}

final reusableLeftoversProvider = Provider<ReusableLeftovers>(
  (ref) => ReusableLeftovers(ref.watch(stockRepositoryProvider)),
);

final class ReusableLeftovers {
  const ReusableLeftovers(this.stock);
  final StockRepository stock;

  Future<void> addToStock(String projectId, OptimizationResult result) =>
      stock.addStockBatch(projectId, groupReusableLeftovers(result));
}
