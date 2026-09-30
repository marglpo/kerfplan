import '../units/length.dart';
import 'stock_input.dart';

/// Immutable stock entity. Drift's generated row is named StockLine.
final class StockItem {
  StockItem({
    required this.id,
    required this.projectId,
    required Length length,
    required int quantity,
    String? label,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  }) : _input = StockInput(length: length, quantity: quantity, label: label) {
    if (sortOrder < 0) throw RangeError.value(sortOrder, 'sortOrder');
  }

  final String id;
  final String projectId;
  final StockInput _input;
  Length get length => _input.length;
  int get quantity => _input.quantity;
  String? get label => _input.label;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
}
