import '../units/length.dart';
import 'cut_project.dart';
import 'inventory_mode.dart';
import 'stock_item.dart';

/// A single-part feasibility hint, not a cutting calculation. No trailing kerf.
abstract final class PartFit {
  static Length? largestUsable(CutProject project, Iterable<StockItem> stock) {
    final Length? largest;
    if (project.inventoryMode == InventoryMode.buy) {
      largest = project.buyStockLength;
    } else {
      largest = stock.fold<Length?>(
        null,
        (max, row) => max == null || row.length > max ? row.length : max,
      );
    }
    if (largest == null) return null;
    // BigInt prevents overflow when trims exceed the entire stock length.
    final usable =
        BigInt.from(largest.ticks) -
        BigInt.from(project.endTrim.ticks) * BigInt.two;
    return Length.fromTicks(usable < BigInt.zero ? 0 : usable.toInt());
  }

  static bool tooLong(Length part, Length? usable) =>
      usable != null && part > usable;
}
