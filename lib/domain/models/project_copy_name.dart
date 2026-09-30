import 'project_metadata.dart';

/// Chooses a collision-free generated name; entered metadata is never truncated.
/// [copyLabel] is supplied by localization, not persisted as an enum value.
String projectCopyName(
  String source,
  String copyLabel,
  Set<String> existingNames,
) {
  if (copyLabel.trim().isEmpty) {
    throw ArgumentError.value(copyLabel, 'copyLabel');
  }
  for (var number = 1; ; number++) {
    final suffix = ' ${copyLabel.trim()}${number == 1 ? '' : ' $number'}';
    final available = ProjectMetadata.maxNameLength - suffix.runes.length;
    if (available < 2) throw ArgumentError('Copy label is too long');
    final base = source.runes.length <= available
        ? source
        : '${String.fromCharCodes(source.runes.take(available - 1))}…';
    final candidate = '$base$suffix';
    if (!existingNames.contains(candidate)) return candidate;
  }
}
