import '../models/stock_input.dart';
import '../models/stock_item.dart';

abstract interface class StockRepository {
  Stream<List<StockItem>> watchStockLines(String projectId);
  Future<List<StockItem>> getStockLines(String projectId);
  Future<StockItem?> getStockLine(String id);
  Future<StockItem> createStockLine(String projectId, StockInput input);

  /// Appends all rows atomically, touching the project once. Empty is a no-op.
  Future<void> addStockBatch(String projectId, List<StockInput> items);
  Future<void> updateStockLine(String id, StockInput input);
  Future<StockItem> duplicateStockLine(String id);
  Future<void> deleteStockLine(String id);
}

final class StockNotFoundException implements Exception {
  const StockNotFoundException(this.id);
  final String id;
}
