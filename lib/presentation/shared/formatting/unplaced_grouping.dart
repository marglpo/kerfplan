import '../../../domain/optimizer/unplaced_part.dart';

/// Presentation grouping retains identity and the first occurrence's order.
List<({UnplacedPart part, int quantity})> groupUnplaced(
  List<UnplacedPart> parts,
) {
  final groups =
      <(String, UnplacedReason), ({UnplacedPart part, int quantity})>{};
  for (final part in parts) {
    final key = (part.sourcePartId, part.reason);
    final old = groups[key];
    groups[key] = (part: old?.part ?? part, quantity: (old?.quantity ?? 0) + 1);
  }
  return List.unmodifiable(groups.values);
}
