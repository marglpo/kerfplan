import 'package:flutter/material.dart';

import '../../domain/models/cut_project.dart';
import '../../domain/models/project_metadata.dart';
import '../../l10n/app_localizations.dart';
import '../shared/widgets/save_form.dart';

class ProjectMetadataForm extends StatefulWidget {
  const ProjectMetadataForm({
    super.key,
    this.initialProject,
    required this.submitLabel,
    required this.onSubmit,
  });
  final CutProject? initialProject;
  final String submitLabel;
  final Future<void> Function(ProjectMetadata) onSubmit;
  @override
  State<ProjectMetadataForm> createState() => _ProjectMetadataFormState();
}

class _ProjectMetadataFormState extends State<ProjectMetadataForm> {
  late final TextEditingController _name;
  late final TextEditingController _material;
  late final TextEditingController _note;
  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initialProject?.name);
    _material = TextEditingController(text: widget.initialProject?.material);
    _note = TextEditingController(text: widget.initialProject?.note);
  }

  @override
  void dispose() {
    _name.dispose();
    _material.dispose();
    _note.dispose();
    super.dispose();
  }

  String? _error(ProjectValidationError? error) {
    final l10n = AppLocalizations.of(context);
    return switch (error) {
      null => null,
      ProjectValidationError.nameRequired => l10n.projectNameRequired,
      ProjectValidationError.nameTooLong => l10n.projectNameTooLong,
      ProjectValidationError.materialTooLong => l10n.materialTooLong,
      ProjectValidationError.noteTooLong => l10n.noteTooLong,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SaveForm(
      submitLabel: widget.submitLabel,
      errorMessage: l10n.projectSaveError,
      onSubmit: () => widget.onSubmit(
        ProjectMetadata(
          name: _name.text,
          material: _material.text,
          note: _note.text,
        ),
      ),
      fields: (enabled) => [
        TextFormField(
          key: const ValueKey('project-name'),
          controller: _name,
          enabled: enabled,
          decoration: InputDecoration(
            labelText: l10n.projectNameLabel,
            hintText: l10n.projectNameHint,
            errorMaxLines: 3,
          ),
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
          validator: (value) =>
              _error(ProjectMetadata.validateName(value ?? '')),
        ),
        const SizedBox(height: 20),
        TextFormField(
          key: const ValueKey('project-material'),
          controller: _material,
          enabled: enabled,
          decoration: InputDecoration(
            labelText: l10n.materialLabel,
            hintText: l10n.materialHint,
            errorMaxLines: 3,
          ),
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
          validator: (value) => _error(ProjectMetadata.validateMaterial(value)),
        ),
        const SizedBox(height: 20),
        TextFormField(
          key: const ValueKey('project-note'),
          controller: _note,
          enabled: enabled,
          decoration: InputDecoration(
            labelText: l10n.noteLabel,
            hintText: l10n.noteHint,
            errorMaxLines: 3,
          ),
          textCapitalization: TextCapitalization.sentences,
          minLines: 3,
          maxLines: 6,
          validator: (value) => _error(ProjectMetadata.validateNote(value)),
        ),
      ],
    );
  }
}
