import '../units/length.dart';
import 'part_input.dart';

/// Immutable part entity. Drift's generated row is named PartLine.
final class PartItem {
  PartItem({
    required this.id,
    required this.projectId,
    required Length length,
    required int quantity,
    String? name,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  }) : _input = PartInput(length: length, quantity: quantity, name: name) {
    if (sortOrder < 0) throw RangeError.value(sortOrder, 'sortOrder');
  }

  final String id;
  final String projectId;
  final PartInput _input;
  Length get length => _input.length;
  int get quantity => _input.quantity;
  String? get name => _input.name;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
}
