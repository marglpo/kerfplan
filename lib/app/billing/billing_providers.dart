import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/billing/firebase_purchase_verification_client.dart';
import '../../data/billing/play_billing_gateway.dart';
import '../../data/db/database_provider.dart';
import '../../data/repositories/drift_entitlement_repository.dart';
import '../../domain/billing/billing_gateway.dart';
import '../../domain/billing/entitlements.dart';
import '../../domain/billing/purchase_verification_client.dart';
import '../../domain/repositories/entitlement_repository.dart';
import 'billing_controller.dart';

final entitlementRepositoryProvider = Provider<EntitlementRepository>(
  (ref) => DriftEntitlementRepository(ref.watch(appDatabaseProvider)),
);
final entitlementsProvider = StreamProvider<Entitlements>(
  (ref) => ref.watch(entitlementRepositoryProvider).watchEntitlements(),
  retry: (_, _) => null,
);
final billingGatewayProvider = Provider<BillingGateway>(
  (ref) => PlayBillingGateway(),
);
final purchaseVerificationProvider = Provider<PurchaseVerificationClient>(
  (ref) => FirebasePurchaseVerificationClient(),
);
final billingControllerProvider = Provider<BillingController>((ref) {
  final controller = BillingController(
    ref.watch(billingGatewayProvider),
    ref.watch(purchaseVerificationProvider),
    ref.watch(entitlementRepositoryProvider),
  );
  ref.onDispose(() => unawaited(controller.dispose()));
  return controller;
});
final billingStateProvider = StreamProvider<BillingState>(
  (ref) => ref.watch(billingControllerProvider).states,
);
