import '../models/part_input.dart';
import '../models/part_item.dart';

abstract interface class PartRepository {
  Stream<List<PartItem>> watchParts(String projectId);
  Future<List<PartItem>> getPartLines(String projectId);
  Future<PartItem?> getPart(String id);
  Future<PartItem> createPart(String projectId, PartInput input);
  Future<void> updatePart(String id, PartInput input);
  Future<PartItem> duplicatePart(String id);
  Future<void> deletePart(String id);
}

final class PartNotFoundException implements Exception {
  const PartNotFoundException(this.id);
  final String id;
}
