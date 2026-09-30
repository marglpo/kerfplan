import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:kerfplan/data/billing/play_billing_gateway.dart';
import 'package:kerfplan/data/billing/firebase_purchase_verification_client.dart';
import 'package:kerfplan/domain/billing/billing_gateway.dart';
import 'package:kerfplan/domain/billing/billing_product.dart';
import 'package:kerfplan/domain/billing/purchase_verification_client.dart';

void main() {
  final valid = <String, Object?>{
    'productId': BillingProduct.lifetimePro.id,
    'owned': true,
    'acknowledged': true,
    'verifiedAt': '2026-09-28T01:02:03Z',
  };
  test(
    'strict response parses product, ownership, acknowledgement and UTC time',
    () {
      final result = VerifiedPurchase.parse(valid, BillingProduct.lifetimePro);
      expect(result.product, BillingProduct.lifetimePro);
      expect(result.owned, isTrue);
      expect(result.acknowledged, isTrue);
      expect(result.verifiedAt, DateTime.utc(2026, 9, 28, 1, 2, 3));
    },
  );
  final invalid = <Object?>[
    null,
    'raw-token',
    {},
    {...valid, 'productId': BillingProduct.removeAds.id},
    {...valid, 'owned': 'true'},
    {...valid, 'acknowledged': false},
    {...valid, 'verifiedAt': 'not-time'},
    {...valid, 'verifiedAt': '2026-09-28T01:02:03'},
    {...valid, 'acknowledged': 'true'},
  ];
  for (var i = 0; i < invalid.length; i++) {
    test('malformed backend response $i fails safely', () {
      expect(
        () => VerifiedPurchase.parse(invalid[i], BillingProduct.lifetimePro),
        throwsA(isA<BillingFailure>()),
      );
    });
  }
  test('valid not-owned response is authoritative without acknowledgement', () {
    expect(
      VerifiedPurchase.parse({
        ...valid,
        'owned': false,
        'acknowledged': false,
      }, BillingProduct.lifetimePro).owned,
      isFalse,
    );
  });
  test('Android token is purchaseToken, not arbitrary verificationData', () {
    final wrapper = PurchaseWrapper(
      orderId: 'order',
      packageName: 'com.kerfplan.app',
      purchaseTime: 1,
      purchaseToken: 'actual-play-token',
      signature: '',
      products: [BillingProduct.lifetimePro.id],
      isAutoRenewing: false,
      originalJson: '{}',
      isAcknowledged: false,
      purchaseState: PurchaseStateWrapper.purchased,
    );
    final native = GooglePlayPurchaseDetails(
      productID: BillingProduct.lifetimePro.id,
      verificationData: PurchaseVerificationData(
        localVerificationData: 'receipt',
        serverVerificationData: 'not-the-token',
        source: 'test',
      ),
      transactionDate: '1',
      billingClientPurchase: wrapper,
      status: PurchaseStatus.purchased,
    );
    final mapped = mapPlayPurchase(native);
    expect(mapped.token, 'actual-play-token');
    expect(mapped.status, StorePurchaseStatus.purchased);
  });
  for (final status in PurchaseStatus.values) {
    test(
      'maps plugin $status without trusting non-Android verification data',
      () {
        final mapped = mapPlayPurchase(
          PurchaseDetails(
            productID: BillingProduct.removeAds.id,
            verificationData: PurchaseVerificationData(
              localVerificationData: '',
              serverVerificationData: 'untrusted',
              source: 'other',
            ),
            transactionDate: null,
            status: status,
          ),
        );
        expect(mapped.token, isNull);
        expect(mapped.status.name, status.name);
      },
    );
  }
  test('App Check debug provider is explicit opt-in, not the default', () {
    expect(FirebasePurchaseVerificationClient.useDebugAppCheck, isFalse);
  });
  test(
    'server-acknowledged Android completion needs no native plugin call',
    () async {
      await PlayBillingGateway().finishVerifiedPurchase(
        const StorePurchase('unused', StorePurchaseStatus.purchased),
      );
    },
  );
}
