import 'package:drift/drift.dart';

import '../../domain/billing/billing_product.dart';
import '../../domain/billing/entitlements.dart';
import '../../domain/repositories/entitlement_repository.dart';
import '../db/app_database.dart';

class DriftEntitlementRepository implements EntitlementRepository {
  DriftEntitlementRepository(this.db);
  final AppDatabase db;

  Entitlements _map(List<EntitlementCacheData> rows) => Entitlements(
    removeAdsOwned: rows.any(
      (r) => r.productId == BillingProduct.removeAds.id && r.owned,
    ),
    lifetimeProOwned: rows.any(
      (r) => r.productId == BillingProduct.lifetimePro.id && r.owned,
    ),
  );
  @override
  Stream<Entitlements> watchEntitlements() =>
      db.select(db.entitlementCache).watch().map(_map).distinct();
  @override
  Future<Entitlements> getEntitlements() async =>
      _map(await db.select(db.entitlementCache).get());
  @override
  Future<void> setProductOwned(
    BillingProduct product,
    bool owned,
    DateTime verifiedAt,
  ) async {
    await db
        .into(db.entitlementCache)
        .insertOnConflictUpdate(
          EntitlementCacheCompanion.insert(
            productId: product.id,
            owned: Value(owned),
            lastVerifiedAt: Value(verifiedAt.toUtc()),
          ),
        );
  }

  @override
  Future<void> replaceFromSuccessfulReconciliation(
    Map<BillingProduct, DateTime> owned, {
    required DateTime verifiedAt,
  }) => db.transaction(() async {
    for (final product in BillingProduct.values) {
      await setProductOwned(
        product,
        owned.containsKey(product),
        owned[product] ?? verifiedAt,
      );
    }
  });
}
