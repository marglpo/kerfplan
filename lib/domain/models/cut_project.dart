import '../units/display_unit.dart';
import '../units/length.dart';
import 'inventory_mode.dart';

/// Persisted project state, independent of Flutter and Drift.
final class CutProject {
  const CutProject({
    required this.id,
    required this.name,
    required this.material,
    required this.note,
    required this.inventoryMode,
    required this.displayUnit,
    required this.kerf,
    required this.endTrim,
    required this.minReusable,
    required this.buyStockLength,
    required this.revision,
    required this.lastRunId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String? material;
  final String? note;
  final InventoryMode inventoryMode;
  final DisplayUnit displayUnit;
  final Length kerf;
  final Length endTrim;
  final Length minReusable;
  final Length? buyStockLength;
  final int revision;
  final String? lastRunId;
  final DateTime createdAt;
  final DateTime updatedAt;
}
