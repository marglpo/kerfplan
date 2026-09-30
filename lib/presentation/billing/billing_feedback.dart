import 'package:flutter/material.dart';

import '../../app/billing/billing_controller.dart';
import '../../l10n/app_localizations.dart';

class BillingFeedback extends StatelessWidget {
  const BillingFeedback({super.key, required this.state});
  final BillingState state;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final message = switch (state.notice) {
      BillingNotice.pending =>
        '${l.purchasePending}\n${l.purchasePendingMessage}',
      BillingNotice.purchaseError => l.purchaseError,
      BillingNotice.restoreError => l.restoreError,
      BillingNotice.proRestored => l.lifetimeProRestored,
      BillingNotice.adFreeRestored => l.adFreeRestored,
      BillingNotice.purchasesRestored => l.purchasesRestored,
      BillingNotice.nothingToRestore => l.nothingToRestore,
      BillingNotice.purchased => l.purchaseVerified,
      BillingNotice.none => switch (state.phase) {
        BillingPhase.unavailable => l.billingUnavailable,
        BillingPhase.restoring => l.restoringPurchases,
        BillingPhase.purchasing ||
        BillingPhase.verifying ||
        BillingPhase.loading => l.processingPurchase,
        _ => '',
      },
    };
    if (message.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Semantics(liveRegion: true, child: Text(message)),
    );
  }
}
