import 'dart:async';

import '../../domain/billing/billing_gateway.dart';
import '../../domain/billing/billing_product.dart';
import '../../domain/billing/purchase_verification_client.dart';
import '../../domain/repositories/entitlement_repository.dart';

enum BillingPhase {
  idle,
  loading,
  purchasing,
  pending,
  verifying,
  restoring,
  unavailable,
  error,
}

enum BillingNotice {
  none,
  purchased,
  pending,
  purchaseError,
  restoreError,
  proRestored,
  adFreeRestored,
  purchasesRestored,
  nothingToRestore,
}

enum RestoreOutcome { pro, adFree, both, none, pending, failed }

class BillingState {
  BillingState({
    this.phase = BillingPhase.idle,
    this.notice = BillingNotice.none,
    this.purchaseInProgress = false,
    Map<BillingProduct, StoreProduct> products = const {},
  }) : products = Map.unmodifiable(products);
  final BillingPhase phase;
  final BillingNotice notice;
  final bool purchaseInProgress;
  final Map<BillingProduct, StoreProduct> products;
  bool get busy => switch (phase) {
    BillingPhase.loading ||
    BillingPhase.purchasing ||
    BillingPhase.verifying ||
    BillingPhase.restoring => true,
    _ => false,
  };
  bool get canBuy =>
      !busy &&
      !purchaseInProgress &&
      phase != BillingPhase.pending &&
      phase != BillingPhase.unavailable;
}

/// One application-scoped purchase subscription. Network work never blocks Home.
/// Stream mutations and reconciliation cache replacement are serialized.
class BillingController {
  BillingController(
    this.gateway,
    this.verifier,
    this.cache, {
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;
  final BillingGateway gateway;
  final PurchaseVerificationClient verifier;
  final EntitlementRepository cache;
  final DateTime Function() _now;
  final _changes = StreamController<BillingState>.broadcast();
  final _finished = <String>{};
  StreamSubscription<List<StorePurchase>>? _subscription;
  Future<void> _queue = Future.value();
  Future<RestoreOutcome>? _refresh;
  bool _started = false;
  bool _disposed = false;
  int _eventEpoch = 0;
  BillingProduct? _activePurchase;
  BillingState state = BillingState();

  Stream<BillingState> get states => Stream.multi((sink) {
    final sub = _changes.stream.listen(
      sink.add,
      onError: sink.addError,
      onDone: sink.close,
    );
    sink.add(state);
    sink.onCancel = sub.cancel;
  }, isBroadcast: true);

  void start() {
    if (_started || _disposed) return;
    _started = true;
    try {
      _subscription = gateway.purchaseStream.listen(
        (events) {
          _eventEpoch++;
          unawaited(
            _serial(() async {
              for (final event in events) {
                await _handle(event);
              }
            }),
          );
        },
        onError: (Object _, StackTrace _) {
          _emit(BillingPhase.error, BillingNotice.purchaseError);
        },
      );
    } catch (_) {
      _emit(BillingPhase.unavailable);
    }
    unawaited(refreshEntitlements());
  }

  Future<T> _serial<T>(Future<T> Function() action) {
    final result = _queue.then((_) => action());
    _queue = result.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return result;
  }

  void _emit(
    BillingPhase phase, [
    BillingNotice notice = BillingNotice.none,
    Map<BillingProduct, StoreProduct>? products,
  ]) {
    if (_disposed) return;
    state = BillingState(
      phase: phase,
      notice: notice,
      purchaseInProgress: _activePurchase != null,
      products: products ?? state.products,
    );
    _changes.add(state);
  }

  Future<void> buy(BillingProduct product) async {
    if (_disposed || !state.canBuy || !state.products.containsKey(product)) {
      return;
    }
    _activePurchase = product;
    _emit(BillingPhase.purchasing);
    try {
      if (!await gateway.buyNonConsumable(product)) {
        _activePurchase = null;
        _emit(BillingPhase.idle);
      }
      // Store launch success is not ownership. Wait for the purchase stream.
    } catch (_) {
      _activePurchase = null;
      _emit(BillingPhase.error, BillingNotice.purchaseError);
    }
  }

  bool _validToken(String? token) =>
      token != null &&
      token.isNotEmpty &&
      token.length <= 4096 &&
      !RegExp(r'\s').hasMatch(token);

  Future<void> _handle(StorePurchase event) async {
    if (_disposed) return;
    final product = BillingProduct.fromId(event.productId);
    if (product == null) return;
    if (product == _activePurchase &&
        event.status != StorePurchaseStatus.pending) {
      _activePurchase = null;
    }
    switch (event.status) {
      case StorePurchaseStatus.pending:
        _activePurchase = product;
        _emit(BillingPhase.pending, BillingNotice.pending);
        return;
      case StorePurchaseStatus.canceled:
        _emit(BillingPhase.idle);
        return;
      case StorePurchaseStatus.error:
        _emit(BillingPhase.error, BillingNotice.purchaseError);
        return;
      case StorePurchaseStatus.purchased:
      case StorePurchaseStatus.restored:
        break;
    }
    if (!_validToken(event.token)) {
      _emit(BillingPhase.error, BillingNotice.purchaseError);
      return;
    }
    final key = '${product.id}:${event.token}'; // Ephemeral only; never logged/persisted.
    if (_finished.contains(key)) return;
    _emit(BillingPhase.verifying);
    try {
      await verifier.prepare();
      final result = await verifier.verifyPurchase(product, event.token!);
      if (_disposed) return;
      if (!result.owned || !result.acknowledged || result.product != product) {
        throw const BillingFailure();
      }
      await cache.setProductOwned(product, true, result.verifiedAt);
      await gateway.finishVerifiedPurchase(event);
      _finished.add(key);
      _emit(BillingPhase.idle, BillingNotice.purchased);
    } catch (_) {
      // Failed/unverified events never revoke another valid cached purchase.
      _emit(BillingPhase.error, BillingNotice.purchaseError);
    }
  }

  Future<RestoreOutcome> refreshEntitlements() {
    if (_disposed) return Future.value(RestoreOutcome.failed);
    return _refresh ??= _serial(_reconcile).whenComplete(() {
      _refresh = null;
    });
  }

  Future<RestoreOutcome> restore() async {
    final result = await refreshEntitlements();
    _emit(
      result == RestoreOutcome.pending
          ? BillingPhase.pending
          : result == RestoreOutcome.failed
          ? BillingPhase.error
          : BillingPhase.idle,
      switch (result) {
        RestoreOutcome.pro => BillingNotice.proRestored,
        RestoreOutcome.adFree => BillingNotice.adFreeRestored,
        RestoreOutcome.both => BillingNotice.purchasesRestored,
        RestoreOutcome.none => BillingNotice.nothingToRestore,
        RestoreOutcome.pending => BillingNotice.pending,
        RestoreOutcome.failed => BillingNotice.restoreError,
      },
    );
    return result;
  }

  Future<RestoreOutcome> _reconcile() async {
    final epoch = _eventEpoch;
    _emit(BillingPhase.restoring);
    try {
      if (!await gateway.isAvailable()) throw const BillingFailure();
      await verifier.prepare();
      final products = await gateway.queryProducts();
      if (_disposed) return RestoreOutcome.failed;
      _emit(BillingPhase.restoring, BillingNotice.none, {
        for (final p in products) p.product: p,
      });
      final purchases = await gateway.queryCurrentPurchases();
      final owned = <BillingProduct, DateTime>{};
      final verified = <StorePurchase>[];
      final seen = <String>{};
      for (final purchase in purchases) {
        final product = BillingProduct.fromId(purchase.productId);
        if (product == null) continue;
        if (purchase.status == StorePurchaseStatus.pending) {
          _emit(BillingPhase.pending, BillingNotice.pending);
          return RestoreOutcome.pending;
        }
        if (purchase.status != StorePurchaseStatus.purchased &&
            purchase.status != StorePurchaseStatus.restored) {
          throw const BillingFailure();
        }
        if (!_validToken(purchase.token)) throw const BillingFailure();
        if (!seen.add('${product.id}:${purchase.token}')) continue;
        try {
          final result = await verifier.verifyPurchase(
            product,
            purchase.token!,
          );
          if (result.product != product ||
              (result.owned && !result.acknowledged)) {
            throw const BillingFailure();
          }
          if (result.owned) {
            owned[product] = result.verifiedAt;
            verified.add(purchase);
          }
        } on PurchaseRejected {
          // Authoritative revoked/not-purchased response, not a network failure.
        }
      }
      if (_disposed || epoch != _eventEpoch) throw const BillingFailure();
      // All store/backend checks succeeded. One atomic replacement; failures above leave cache intact.
      await cache.replaceFromSuccessfulReconciliation(
        owned,
        verifiedAt: _now().toUtc(),
      );
      if (owned.containsKey(_activePurchase)) _activePurchase = null;
      for (final purchase in verified) {
        await gateway.finishVerifiedPurchase(purchase);
      }
      _emit(BillingPhase.idle);
      if (owned.length == 2) return RestoreOutcome.both;
      if (owned.containsKey(BillingProduct.lifetimePro)) {
        return RestoreOutcome.pro;
      }
      if (owned.containsKey(BillingProduct.removeAds)) {
        return RestoreOutcome.adFree;
      }
      return RestoreOutcome.none;
    } catch (_) {
      _emit(BillingPhase.unavailable);
      return RestoreOutcome.failed;
    }
  }

  Future<void> dispose() async {
    _disposed = true;
    await _subscription?.cancel();
    _finished.clear();
    await _changes.close();
  }
}
