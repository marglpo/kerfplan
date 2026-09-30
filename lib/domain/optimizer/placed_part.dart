import '../units/length.dart';

final class PlacedPart {
  const PlacedPart({
    required this.sourcePartId,
    required this.name,
    required this.instanceIndex,
    required this.sourceStableOrder,
    required this.orderIndex,
    required this.length,
    required this.kerfAfter,
  });

  final String sourcePartId;
  final String? name;
  final int instanceIndex;
  final int sourceStableOrder;
  final int orderIndex;
  final Length length;
  final Length kerfAfter;
}
