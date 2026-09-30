import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/billing/billing_providers.dart';
import '../../l10n/app_localizations.dart';
import 'billing_feedback.dart';

class BillingSettingsSection extends ConsumerWidget {
  const BillingSettingsSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final controller = ref.watch(billingControllerProvider);
    final state =
        ref.watch(billingStateProvider).asData?.value ?? controller.state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(height: 48),
        Text(l.proTitle, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ref
            .watch(entitlementsProvider)
            .when(
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => Text(l.billingUnavailable),
              data: (owned) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    owned.isPro
                        ? l.proActive
                        : owned.isAdFree
                        ? l.adFreeActive
                        : l.kerfPlanFree,
                  ),
                  if (!owned.isPro)
                    OutlinedButton(
                      onPressed: () => context.push('/pro'),
                      child: Text(owned.isAdFree ? l.viewPro : l.upgrade),
                    ),
                ],
              ),
            ),
        OutlinedButton(
          onPressed: state.busy ? null : controller.restore,
          child: Text(l.restorePurchases),
        ),
        BillingFeedback(state: state),
      ],
    );
  }
}
