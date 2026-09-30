import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '../../domain/billing/billing_gateway.dart';
import '../../domain/billing/billing_product.dart';

StorePurchase mapPlayPurchase(PurchaseDetails purchase) => StorePurchase(
  purchase.productID,
  switch (purchase.status) {
    PurchaseStatus.pending => StorePurchaseStatus.pending,
    PurchaseStatus.purchased => StorePurchaseStatus.purchased,
    PurchaseStatus.restored => StorePurchaseStatus.restored,
    PurchaseStatus.canceled => StorePurchaseStatus.canceled,
    PurchaseStatus.error => StorePurchaseStatus.error,
  },
  token: purchase is GooglePlayPurchaseDetails
      ? purchase.billingClientPurchase.purchaseToken
      : null,
);

class PlayBillingGateway implements BillingGateway {
  final _products = <BillingProduct, ProductDetails>{};
  bool get _supported => !kIsWeb && Platform.isAndroid;
  InAppPurchase get _store => InAppPurchase.instance;
  @override
  Stream<List<StorePurchase>> get purchaseStream => _supported
      ? _store.purchaseStream.map(
          (batch) => batch.map(mapPlayPurchase).toList(),
        )
      : const Stream.empty();
  @override
  Future<bool> isAvailable() async {
    try {
      return _supported && await _store.isAvailable();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<StoreProduct>> queryProducts() async {
    try {
      final response = await _store.queryProductDetails({
        for (final p in BillingProduct.values) p.id,
      });
      if (response.error != null) throw const BillingFailure();
      _products.clear();
      for (final detail in response.productDetails) {
        final product = BillingProduct.fromId(detail.id);
        if (product != null) _products[product] = detail;
      }
      return [
        for (final entry in _products.entries)
          StoreProduct(entry.key, entry.value.price),
      ];
    } catch (_) {
      throw const BillingFailure();
    }
  }

  @override
  Future<List<StorePurchase>> queryCurrentPurchases() async {
    try {
      final response = await _store
          .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>()
          .queryPastPurchases();
      if (response.error != null) throw const BillingFailure();
      return response.pastPurchases.map(mapPlayPurchase).toList();
    } catch (_) {
      throw const BillingFailure();
    }
  }

  @override
  Future<bool> buyNonConsumable(BillingProduct product) async {
    try {
      final detail = _products[product];
      if (detail == null) throw const BillingFailure();
      return await _store.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: detail),
      );
    } catch (_) {
      throw const BillingFailure();
    }
  }

  @override
  Future<void> finishVerifiedPurchase(StorePurchase purchase) async {
    // Android 0.5.3 completePurchase ONLY acknowledges (or returns when already
    // acknowledged). There is no local transaction queue to finish. The backend
    // has acknowledged before cache write; calling it on stale PurchaseDetails
    // would acknowledge twice. The next Play query reflects server acknowledgement.
  }
}
