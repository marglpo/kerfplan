import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';
import '../../domain/billing/billing_gateway.dart';
import '../../domain/billing/billing_product.dart';
import '../../domain/billing/purchase_verification_client.dart';

class FirebasePurchaseVerificationClient implements PurchaseVerificationClient {
  static const region = String.fromEnvironment('BILLING_REGION');
  static const useDebugAppCheck =
      kDebugMode && bool.fromEnvironment('APP_CHECK_DEBUG');
  Future<void>? _initializing;
  bool _ready = false;

  @override
  Future<void> prepare() async {
    try {
      await _ensureInitialized();
      // A cached/empty Play response must not strip offline ownership. Require a
      // fresh App Check exchange before considering reconciliation authoritative.
      final token = await FirebaseAppCheck.instance
          .getToken(true)
          .timeout(const Duration(seconds: 25));
      if (token == null || token.isEmpty) throw const BillingFailure();
    } catch (_) {
      throw const BillingFailure();
    }
  }

  Future<void> _ensureInitialized() {
    if (_ready) return Future.value();
    return _initializing ??= _initialize().whenComplete(() {
      _initializing = null;
    });
  }

  Future<void> _initialize() async {
    try {
      if (region.isEmpty) throw const BillingFailure();
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      await FirebaseAppCheck.instance.activate(
        providerAndroid: useDebugAppCheck
            ? const AndroidDebugProvider()
            : const AndroidPlayIntegrityProvider(),
      );
      _ready = true;
    } catch (_) {
      throw const BillingFailure();
    }
  }

  @override
  Future<VerifiedPurchase> verifyPurchase(
    BillingProduct product,
    String token,
  ) async {
    try {
      await _ensureInitialized();
      final callable = FirebaseFunctions.instanceFor(region: region)
          .httpsCallable(
            'verifyPlayPurchase',
            options: HttpsCallableOptions(timeout: const Duration(seconds: 45)),
          );
      final response = await callable.call<Object?>({
        'productId': product.id,
        'purchaseToken': token,
      });
      return VerifiedPurchase.parse(response.data, product);
    } on FirebaseFunctionsException catch (error) {
      final details = error.details;
      if (error.code == 'failed-precondition' &&
          details is Map &&
          const [
            'purchaseVoided',
            'purchaseNotPurchased',
          ].contains(details['reason'])) {
        throw const PurchaseRejected();
      }
      throw const BillingFailure();
    } catch (_) {
      throw const BillingFailure();
    }
  }
}
