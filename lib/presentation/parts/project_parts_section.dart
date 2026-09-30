import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/part_providers.dart';
import '../../domain/models/cut_project.dart';
import '../../l10n/app_localizations.dart';
import 'part_card.dart';

class ProjectPartsSection extends ConsumerWidget {
  const ProjectPartsSection({super.key, required this.project});
  final CutProject project;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ref
        .watch(partsProvider(project.id))
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Column(
            children: [
              Text(l10n.partLoadError),
              TextButton(
                onPressed: () => ref.invalidate(partsProvider(project.id)),
                child: Text(l10n.retry),
              ),
            ],
          ),
          data: (items) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.partsSectionTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  if (items.isEmpty)
                    Text(l10n.noPartsYet)
                  else ...[
                    Text(
                      l10n.partSummary(items.length),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      l10n.totalPieces(
                        items.fold(0, (total, part) => total + part.quantity),
                      ),
                    ),
                    for (final part in items)
                      PartCard(
                        key: ValueKey(part.id),
                        part: part,
                        unit: project.displayUnit,
                      ),
                  ],
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () =>
                        context.go('/projects/${project.id}/parts/new'),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addPart),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
