import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/part_providers.dart';
import '../../domain/models/part_item.dart';
import '../../domain/units/display_unit.dart';
import '../../l10n/app_localizations.dart';
import '../shared/inputs/length_input.dart';

enum _PartAction { duplicate, delete }

class PartCard extends ConsumerStatefulWidget {
  const PartCard({super.key, required this.part, required this.unit});
  final PartItem part;
  final DisplayUnit unit;
  @override
  ConsumerState<PartCard> createState() => _PartCardState();
}

class _PartCardState extends ConsumerState<PartCard> {
  bool _busy = false;
  Future<void> _act(_PartAction action) async {
    if (_busy) return;
    final part = widget.part;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (action == _PartAction.delete) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.deletePartTitle),
          content: Text(
            l10n.deletePartMessage(
              part.name == null
                  ? displayLength(l10n, part.length, widget.unit)
                  : l10n.namedPartLength(
                      part.name!,
                      displayLength(l10n, part.length, widget.unit),
                    ),
              part.quantity,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.delete),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }
    setState(() => _busy = true);
    try {
      final repository = ref.read(partRepositoryProvider);
      if (action == _PartAction.duplicate) {
        await repository.duplicatePart(part.id);
      } else {
        await repository.deletePart(part.id);
        if (messenger.mounted) {
          messenger.showSnackBar(SnackBar(content: Text(l10n.partDeleted)));
        }
      }
    } catch (_) {
      if (messenger.mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              action == _PartAction.delete
                  ? l10n.partDeleteError
                  : l10n.partDuplicateError,
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final part = widget.part;
    final l10n = AppLocalizations.of(context);
    final length = displayLength(l10n, part.length, widget.unit);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InkWell(
                  onTap: _busy
                      ? null
                      : () => context.go(
                          '/projects/${part.projectId}/parts/${part.id}/edit',
                        ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (part.name != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            part.name!,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                        Text(
                          length,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          l10n.stockQuantity(part.quantity),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              PopupMenuButton<_PartAction>(
                enabled: !_busy,
                tooltip: l10n.stockActions(length),
                onSelected: _act,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: _PartAction.duplicate,
                    child: Text(l10n.duplicatePart),
                  ),
                  PopupMenuItem(
                    value: _PartAction.delete,
                    child: Text(l10n.delete),
                  ),
                ],
              ),
            ],
          ),
          if (_busy) const LinearProgressIndicator(),
        ],
      ),
    );
  }
}
