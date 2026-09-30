import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/app/billing/billing_controller.dart';
import 'package:kerfplan/domain/billing/billing_gateway.dart';
import 'package:kerfplan/domain/billing/billing_product.dart';
import 'package:kerfplan/domain/billing/entitlements.dart';

import 'billing_fakes.dart';

void main() {
  late BillingFixture f;
  setUp(() {
    f = BillingFixture();
  });
  tearDown(() => f.close());
  test('Lifetime implies Pro and ad-free; Remove Ads does not imply Pro', () {
    expect(const Entitlements(lifetimeProOwned: true).isPro, isTrue);
    expect(const Entitlements(lifetimeProOwned: true).isAdFree, isTrue);
    expect(const Entitlements(removeAdsOwned: true).isPro, isFalse);
    expect(const Entitlements(removeAdsOwned: true).isAdFree, isTrue);
  });
  for (final status in [
    StorePurchaseStatus.pending,
    StorePurchaseStatus.canceled,
    StorePurchaseStatus.error,
  ]) {
    test('$status grants nothing and never verifies', () async {
      await f.start();
      await f.emit(purchase(BillingProduct.lifetimePro, status: status));
      expect(f.cache.value.isPro, isFalse);
      expect(f.verifier.calls, isEmpty);
      expect(f.gateway.finished, 0);
      expect(
        f.controller.state.notice,
        status == StorePurchaseStatus.pending
            ? BillingNotice.pending
            : status == StorePurchaseStatus.canceled
            ? BillingNotice.none
            : BillingNotice.purchaseError,
      );
    });
  }
  for (final product in BillingProduct.values) {
    for (final status in [
      StorePurchaseStatus.purchased,
      StorePurchaseStatus.restored,
    ]) {
      test(
        '$status ${product.id} verifies then writes then finalizes',
        () async {
          await f.start();
          await f.emit(purchase(product, status: status));
          expect(f.verifier.calls, [product]);
          expect(f.order, ['verify', 'cache', 'finish']);
          expect(f.cache.value.isAdFree, isTrue);
          expect(f.cache.value.isPro, product == BillingProduct.lifetimePro);
          expect(f.cache.times[product], f.verifier.time);
        },
      );
    }
  }
  test(
    'launching purchase alone grants nothing and double taps are blocked',
    () async {
      await f.start();
      await f.controller.buy(BillingProduct.lifetimePro);
      await f.controller.buy(BillingProduct.lifetimePro);
      expect(f.gateway.bought, 1);
      expect(f.cache.value.isPro, isFalse);
      await f.emit(
        purchase(
          BillingProduct.lifetimePro,
          status: StorePurchaseStatus.canceled,
        ),
      );
      expect(f.controller.state.phase, BillingPhase.idle);
    },
  );
  test('unknown products are ignored', () async {
    await f.start();
    await f.emit(
      const StorePurchase(
        'unknown',
        StorePurchaseStatus.purchased,
        token: testToken,
      ),
    );
    expect(f.verifier.calls, isEmpty);
    expect(f.cache.writes, 0);
  });
  test('resume refresh does not reopen purchase CTA while native purchase is in progress', () async {
    await f.start();
    await f.controller.buy(BillingProduct.lifetimePro);
    await f.controller.refreshEntitlements();
    await f.controller.buy(BillingProduct.lifetimePro);
    expect(f.gateway.bought, 1);
    await f.emit(
      purchase(
        BillingProduct.lifetimePro,
        status: StorePurchaseStatus.canceled,
      ),
    );
    expect(f.controller.state.canBuy, isTrue);
  });
  for (final token in [null, '', '  ', 'x' * 4097]) {
    test(
      'invalid token of length ${token?.length} never reaches verification',
      () async {
        await f.start();
        await f.emit(purchase(BillingProduct.lifetimePro, token: token));
        expect(f.verifier.calls, isEmpty);
        expect(f.cache.writes, 0);
      },
    );
  }
  test(
    'backend rejection grants nothing and keeps another cached entitlement',
    () async {
      await f.start();
      f.cache.value = const Entitlements(removeAdsOwned: true);
      f.verifier.rejected.add(BillingProduct.lifetimePro);
      await f.emit(purchase(BillingProduct.lifetimePro));
      expect(f.cache.value, const Entitlements(removeAdsOwned: true));
      expect(f.gateway.finished, 0);
    },
  );
  test('backend false or unacknowledged response grants nothing', () async {
    await f.start();
    f.verifier.owned = false;
    await f.emit(purchase(BillingProduct.lifetimePro));
    expect(f.cache.writes, 0);
    f.verifier.owned = true;
    f.verifier.acknowledged = false;
    await f.emit(purchase(BillingProduct.lifetimePro));
    expect(f.cache.writes, 0);
  });
  test('failed local write does not finalize, retry can succeed', () async {
    await f.start();
    f.cache.fail = true;
    await f.emit(purchase(BillingProduct.lifetimePro));
    expect(f.gateway.finished, 0);
    f.cache.fail = false;
    await f.emit(purchase(BillingProduct.lifetimePro));
    expect(f.cache.value.isPro, isTrue);
  });
  test(
    'duplicate stream events are idempotent with one subscription',
    () async {
      await f.start();
      f.controller.start();
      await f.emit(purchase(BillingProduct.lifetimePro));
      await f.emit(purchase(BillingProduct.lifetimePro));
      expect(f.gateway.subscriptions, 1);
      expect(f.cache.writes, 1);
      expect(f.verifier.calls, hasLength(1));
    },
  );
  test('backend failure and error state never expose raw tokens', () async {
    await f.start();
    f.verifier.failures.add(BillingProduct.lifetimePro);
    await f.emit(purchase(BillingProduct.lifetimePro));
    expect(f.controller.state.notice, BillingNotice.purchaseError);
    expect(f.controller.state.toString(), isNot(contains(testToken)));
    expect(const BillingFailure().toString(), isNot(contains(testToken)));
  });
  for (final failure in ['play', 'store', 'backend', 'firebase']) {
    test('$failure failure keeps cached Pro during refresh', () async {
      f.cache.value = const Entitlements(lifetimeProOwned: true);
      f.gateway.purchases = [purchase(BillingProduct.lifetimePro)];
      if (failure == 'play') f.gateway.available = false;
      if (failure == 'store') f.gateway.queryFails = true;
      if (failure == 'backend') {
        f.verifier.failures.add(BillingProduct.lifetimePro);
      }
      if (failure == 'firebase') f.verifier.prepareFails = true;
      expect(await f.controller.restore(), RestoreOutcome.failed);
      expect(f.cache.value.isPro, isTrue);
      expect(f.cache.replacements, 0);
    });
  }
  test('partial verification failure preserves entire cache', () async {
    f.cache.value = const Entitlements(lifetimeProOwned: true);
    f.gateway.purchases = [
      purchase(BillingProduct.removeAds),
      purchase(BillingProduct.lifetimePro),
    ];
    f.verifier.failures.add(BillingProduct.lifetimePro);
    await f.controller.restore();
    expect(f.cache.value, const Entitlements(lifetimeProOwned: true));
    expect(f.cache.replacements, 0);
  });
  final restoreCases = <List<BillingProduct>, RestoreOutcome>{
    [BillingProduct.lifetimePro]: RestoreOutcome.pro,
    [BillingProduct.removeAds]: RestoreOutcome.adFree,
    BillingProduct.values: RestoreOutcome.both,
    []: RestoreOutcome.none,
  };
  for (final entry in restoreCases.entries) {
    test('complete restore returns ${entry.value}', () async {
      f.cache.value = const Entitlements(
        lifetimeProOwned: true,
        removeAdsOwned: true,
      );
      f.gateway.purchases = entry.key.map((p) => purchase(p)).toList();
      expect(await f.controller.restore(), entry.value);
      expect(
        f.cache.value.lifetimeProOwned,
        entry.key.contains(BillingProduct.lifetimePro),
      );
      expect(
        f.cache.value.removeAdsOwned,
        entry.key.contains(BillingProduct.removeAds),
      );
      expect(f.cache.replacements, 1);
    });
  }
  test('authoritative revocation clears cache, errors do not', () async {
    f.cache.value = const Entitlements(lifetimeProOwned: true);
    f.gateway.purchases = [purchase(BillingProduct.lifetimePro)];
    f.verifier.rejected.add(BillingProduct.lifetimePro);
    expect(await f.controller.restore(), RestoreOutcome.none);
    expect(f.cache.value.isPro, isFalse);
  });
  test(
    'pending current purchase is incomplete reconciliation, keeps cache',
    () async {
      f.cache.value = const Entitlements(lifetimeProOwned: true);
      f.gateway.purchases = [
        purchase(
          BillingProduct.lifetimePro,
          status: StorePurchaseStatus.pending,
        ),
      ];
      expect(await f.controller.restore(), RestoreOutcome.pending);
      expect(f.cache.value.isPro, isTrue);
    },
  );
  test(
    'concurrent startup/resume refresh uses one current-ownership query',
    () async {
      f.gateway.gate = Completer<void>();
      final first = f.controller.refreshEntitlements();
      final second = f.controller.refreshEntitlements();
      expect(identical(first, second), isTrue);
      await Future<void>.delayed(Duration.zero);
      expect(f.gateway.queries, 1);
      f.gateway.gate!.complete();
      await first;
    },
  );
  test(
    'purchase event racing with empty reconciliation cannot be cleared',
    () async {
      f.gateway.gate = Completer<void>();
      f.controller.start();
      await Future<void>.delayed(Duration.zero);
      f.gateway.events.add([purchase(BillingProduct.lifetimePro)]);
      f.gateway.gate!.complete();
      await f.controller.refreshEntitlements();
      await Future<void>.delayed(Duration.zero);
      expect(f.cache.replacements, 0);
      expect(f.cache.value.isPro, isTrue);
    },
  );
  for (final products in [
    BillingProduct.values,
    [BillingProduct.lifetimePro],
    [BillingProduct.removeAds],
  ]) {
    test(
      'product mapping preserves prices and ignores order: $products',
      () async {
        f.gateway.products = products.reversed
            .map((p) => StoreProduct(p, 'price-${p.id}'))
            .toList();
        await f.controller.refreshEntitlements();
        for (final product in products) {
          expect(
            f.controller.state.products[product]?.price,
            'price-${product.id}',
          );
        }
        expect(f.controller.state.products.length, products.length);
      },
    );
  }
  test('cached Pro available before slow refresh finishes', () async {
    f.cache.value = const Entitlements(lifetimeProOwned: true);
    f.gateway.gate = Completer<void>();
    final refreshing = f.controller.refreshEntitlements();
    expect((await f.cache.getEntitlements()).isPro, isTrue);
    f.gateway.gate!.complete();
    await refreshing;
  });
  test('dispose cancels subscription', () async {
    await f.start();
    await f.controller.dispose();
    expect(f.gateway.events.hasListener, isFalse);
  });
}
