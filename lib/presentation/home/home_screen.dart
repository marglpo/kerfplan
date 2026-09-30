import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/project_providers.dart';
import '../../l10n/app_localizations.dart';
import '../shared/widgets/message_state.dart';
import 'project_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final projects = ref.watch(projectsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: [
          IconButton(
            tooltip: l10n.settingsTitle,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: projects.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => MessageState(
            message: l10n.projectsLoadError,
            actionLabel: l10n.retry,
            onAction: () => ref.invalidate(projectsProvider),
          ),
          data: (items) => items.isEmpty
              ? const _EmptyProjects()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length + 1,
                  itemBuilder: (context, index) => index == 0
                      ? const Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: _NewCutListButton(),
                        )
                      : ProjectCard(
                          key: ValueKey(items[index - 1].id),
                          project: items[index - 1],
                        ),
                ),
        ),
      ),
    );
  }
}

class _NewCutListButton extends StatelessWidget {
  const _NewCutListButton();

  @override
  Widget build(BuildContext context) => FilledButton.icon(
    onPressed: () => context.go('/projects/new'),
    icon: const Icon(Icons.add),
    label: Text(AppLocalizations.of(context).newCutList),
  );
}

class _EmptyProjects extends StatelessWidget {
  const _EmptyProjects();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.noProjectsTitle,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.noProjectsMessage,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const _NewCutListButton(),
            ],
          ),
        ),
      ),
    );
  }
}
