import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/project_providers.dart';
import '../../domain/models/cut_project.dart';
import '../../domain/units/length.dart';
import '../../l10n/app_localizations.dart';
import '../projects/project_state_view.dart';
import '../shared/inputs/length_input.dart';
import '../shared/widgets/save_form.dart';
import 'stock_preset_chips.dart';

class BuyStockScreen extends ConsumerWidget {
  const BuyStockScreen({super.key, required this.projectId});
  final String projectId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ProjectStateView(
      projectId: projectId,
      builder: (project) => Scaffold(
        appBar: AppBar(title: Text(l10n.setBuyStockLength)),
        body: SafeArea(
          child: _BuyLengthForm(
            key: ValueKey(project.id),
            project: project,
            onSubmit: (length) async {
              await ref
                  .read(projectRepositoryProvider)
                  .setBuyStockLength(projectId, length);
              if (context.mounted) context.go('/projects/$projectId');
            },
          ),
        ),
      ),
    );
  }
}

class _BuyLengthForm extends StatefulWidget {
  const _BuyLengthForm({
    super.key,
    required this.project,
    required this.onSubmit,
  });
  final CutProject project;
  final Future<void> Function(Length) onSubmit;
  @override
  State<_BuyLengthForm> createState() => _BuyLengthFormState();
}

class _BuyLengthFormState extends State<_BuyLengthForm> {
  late final LengthEditingController _length;
  @override
  void initState() {
    super.initState();
    _length = LengthEditingController(
      unit: widget.project.displayUnit,
      initialLength: widget.project.buyStockLength,
    );
  }

  @override
  void dispose() {
    _length.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SaveForm(
      submitLabel: l10n.save,
      errorMessage: l10n.stockSaveError,
      onSubmit: () => widget.onSubmit(_length.length),
      fields: (enabled) => [
        LengthInputField(controller: _length, enabled: enabled),
        const SizedBox(height: 16),
        StockPresetChips(controller: _length, enabled: enabled),
        const SizedBox(height: 16),
        Text(l10n.buyStockHelper),
      ],
    );
  }
}
