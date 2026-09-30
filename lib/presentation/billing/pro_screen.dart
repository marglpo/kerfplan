import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/billing/billing_controller.dart';
import '../../app/billing/billing_providers.dart';
import '../../domain/billing/billing_product.dart';
import '../../l10n/app_localizations.dart';
import 'billing_feedback.dart';

class ProScreen extends ConsumerWidget {
  const ProScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final controller = ref.watch(billingControllerProvider);
    final state =
        ref.watch(billingStateProvider).asData?.value ?? controller.state;
    final cached = ref.watch(entitlementsProvider);
    final entitlements = cached.asData?.value;
    return Scaffold(
      appBar: AppBar(title: Text(l.proTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              l.upgradeOnce,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(l.noSubscription),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l.lifetimePro,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    for (final benefit in [
                      l.benefitUnlimitedProjects,
                      l.benefitMultipleStocks,
                      l.benefitPdf,
                      l.endTrimEachEnd,
                      l.benefitReuseLeftovers,
                      l.benefitNoAds,
                    ])
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(benefit),
                      ),
                    const SizedBox(height: 16),
                    if (entitlements?.isPro == true)
                      Text(l.proActive)
                    else
                      _PurchaseButton(
                        product: BillingProduct.lifetimePro,
                        state: state,
                        enabled: entitlements != null,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l.removeAds,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(l.removeAdsDescription),
                    const SizedBox(height: 16),
                    if (entitlements?.isPro == true)
                      Text(l.includedWithPro)
                    else if (entitlements?.isAdFree == true)
                      Text(l.adFreeActive)
                    else
                      _PurchaseButton(
                        product: BillingProduct.removeAds,
                        state: state,
                        enabled: entitlements != null,
                      ),
                  ],
                ),
              ),
            ),
            BillingFeedback(state: state),
            if (cached.hasError) Text(l.billingUnavailable),
            if (state.phase == BillingPhase.unavailable ||
                state.phase == BillingPhase.error ||
                cached.hasError)
              OutlinedButton(
                onPressed: state.busy
                    ? null
                    : () {
                        ref.invalidate(entitlementsProvider);
                        controller.refreshEntitlements();
                      },
                child: Text(l.retry),
              ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: state.busy ? null : controller.restore,
              child: Text(l.restorePurchases),
            ),
          ],
        ),
      ),
    );
  }
}

class _PurchaseButton extends ConsumerWidget {
  const _PurchaseButton({
    required this.product,
    required this.state,
    required this.enabled,
  });
  final BillingProduct product;
  final BillingState state;
  final bool enabled;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final details = state.products[product];
    return FilledButton(
      style: FilledButton.styleFrom(minimumSize: const Size(64, 48)),
      onPressed: enabled && state.canBuy && details != null
          ? () => ref.read(billingControllerProvider).buy(product)
          : null,
      child: Text(
        details == null
            ? l.productUnavailable
            : product == BillingProduct.lifetimePro
            ? l.unlockLifetimePro(details.price)
            : l.removeAdsCta(details.price),
      ),
    );
  }
}
