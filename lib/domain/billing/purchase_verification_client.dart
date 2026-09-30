import 'billing_gateway.dart';
import 'billing_product.dart';

class VerifiedPurchase {
  const VerifiedPurchase({
    required this.product,
    required this.owned,
    required this.verifiedAt,
    required this.acknowledged,
  });
  final BillingProduct product;
  final bool owned;
  final DateTime verifiedAt;
  final bool acknowledged;

  static VerifiedPurchase parse(Object? data, BillingProduct expected) {
    if (data is! Map ||
        data['productId'] != expected.id ||
        data['owned'] is! bool ||
        data['acknowledged'] is! bool ||
        data['verifiedAt'] is! String) {
      throw const BillingFailure();
    }
    final text = data['verifiedAt'] as String;
    final time = DateTime.tryParse(text);
    if (time == null ||
        !RegExp(r'(Z|[+-]\d{2}:\d{2})$').hasMatch(text) ||
        (data['owned'] == true && data['acknowledged'] != true)) {
      throw const BillingFailure();
    }
    return VerifiedPurchase(
      product: expected,
      owned: data['owned'] as bool,
      verifiedAt: time.toUtc(),
      acknowledged: data['acknowledged'] as bool,
    );
  }
}

/// Only known backend rejection codes can remove ownership during reconciliation.
class PurchaseRejected implements Exception {
  const PurchaseRejected();
  @override
  String toString() => 'Purchase does not grant ownership';
}

abstract interface class PurchaseVerificationClient {
  Future<void> prepare();
  Future<VerifiedPurchase> verifyPurchase(BillingProduct product, String token);
}
