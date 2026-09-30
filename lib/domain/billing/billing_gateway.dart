import 'billing_product.dart';

enum StorePurchaseStatus { pending, purchased, restored, canceled, error }

class StoreProduct {
  const StoreProduct(this.product, this.price);
  final BillingProduct product;

  /// Already localized by Google Play. Never format a numeric price ourselves.
  final String price;
}

class StorePurchase {
  const StorePurchase(this.productId, this.status, {this.token});
  final String productId;
  final StorePurchaseStatus status;

  /// Transient memory only. Never persisted or included in errors/logs.
  final String? token;
}

class BillingFailure implements Exception {
  const BillingFailure();
  @override
  String toString() => 'Billing unavailable';
}

abstract interface class BillingGateway {
  Stream<List<StorePurchase>> get purchaseStream;
  Future<bool> isAvailable();
  Future<List<StoreProduct>> queryProducts();

  /// Throws unless the complete current ownership query succeeded.
  Future<List<StorePurchase>> queryCurrentPurchases();
  Future<bool> buyNonConsumable(BillingProduct product);
  Future<void> finishVerifiedPurchase(StorePurchase purchase);
}
