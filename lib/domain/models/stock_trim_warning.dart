import '../units/length.dart';

enum StockTrimWarning { none, someUnusable, allUnusable }

/// Pass only the active stock lengths. Missing stock is not an unusable-stock
/// warning. Subtraction avoids overflowing when a valid trim is doubled.
StockTrimWarning stockTrimWarning(Iterable<Length> stock, Length endTrim) {
  var total = 0;
  var unusable = 0;
  for (final length in stock) {
    total++;
    if (length.ticks - endTrim.ticks <= endTrim.ticks) unusable++;
  }
  if (unusable == 0) return StockTrimWarning.none;
  return unusable == total
      ? StockTrimWarning.allUnusable
      : StockTrimWarning.someUnusable;
}
