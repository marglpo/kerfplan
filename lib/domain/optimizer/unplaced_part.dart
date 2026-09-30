import '../units/length.dart';

enum UnplacedReason { tooLong, inventoryExhausted }

final class UnplacedPart {
  const UnplacedPart({
    required this.sourcePartId,
    required this.name,
    required this.instanceIndex,
    required this.sourceStableOrder,
    required this.length,
    required this.reason,
  });

  final String sourcePartId;
  final String? name;
  final int instanceIndex;
  final int sourceStableOrder;
  final Length length;
  final UnplacedReason reason;
}
