enum ProjectValidationError {
  nameRequired,
  nameTooLong,
  materialTooLong,
  noteTooLong,
}

final class ProjectValidationException implements Exception {
  const ProjectValidationException(this.error);
  final ProjectValidationError error;
}

/// Trims and validates at the domain boundary. Limits count Unicode code points.
final class ProjectMetadata {
  const ProjectMetadata._(this.name, this.material, this.note);

  static const maxNameLength = 80;
  static const maxMaterialLength = 120;
  static const maxNoteLength = 500;

  factory ProjectMetadata({
    required String name,
    String? material,
    String? note,
  }) {
    final error =
        validateName(name) ?? validateMaterial(material) ?? validateNote(note);
    if (error != null) throw ProjectValidationException(error);
    return ProjectMetadata._(name.trim(), _optional(material), _optional(note));
  }

  final String name;
  final String? material;
  final String? note;

  static ProjectValidationError? validateName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return ProjectValidationError.nameRequired;
    if (trimmed.runes.length > maxNameLength) {
      return ProjectValidationError.nameTooLong;
    }
    return null;
  }

  static ProjectValidationError? validateMaterial(String? value) =>
      (value?.trim().runes.length ?? 0) > maxMaterialLength
      ? ProjectValidationError.materialTooLong
      : null;

  static ProjectValidationError? validateNote(String? value) =>
      (value?.trim().runes.length ?? 0) > maxNoteLength
      ? ProjectValidationError.noteTooLong
      : null;

  static String? _optional(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
