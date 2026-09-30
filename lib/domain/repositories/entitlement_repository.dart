import '../billing/billing_product.dart';
import '../billing/entitlements.dart';

abstract interface class EntitlementRepository {
  Stream<Entitlements> watchEntitlements();
  Future<Entitlements> getEntitlements();
  Future<void> setProductOwned(
    BillingProduct product,
    bool owned,
    DateTime verifiedAt,
  );
  Future<void> replaceFromSuccessfulReconciliation(
    Map<BillingProduct, DateTime> owned, {
    required DateTime verifiedAt,
  });
}
