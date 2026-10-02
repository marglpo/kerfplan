import '../support/app_ready.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/app/app.dart';
import 'package:kerfplan/app/router.dart';
import 'package:kerfplan/app/billing/billing_providers.dart';
import 'package:kerfplan/data/db/database_provider.dart';
import 'package:kerfplan/domain/billing/billing_gateway.dart';
import 'package:kerfplan/domain/billing/billing_product.dart';
import 'package:kerfplan/domain/billing/entitlements.dart';
import 'package:kerfplan/presentation/billing/pro_screen.dart';

import '../support/optimization_fixture.dart';
import 'billing_fakes.dart';

void main() {
  late BillingFixture b;
  late OptimizationFixture f;
  setUp(() async {
    b = BillingFixture();
    f = OptimizationFixture();
    await f.initialize();
  });
  tearDown(() async {
    await b.close();
    await f.close();
  });
  Future<ProviderContainer> start(
    WidgetTester tester, {
    String route = '/pro',
  }) async {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(f.db),
        billingControllerProvider.overrideWithValue(b.controller),
        entitlementRepositoryProvider.overrideWithValue(b.cache),
      ],
    );
    addTearDown(container.dispose);
    container.read(routerProvider).go(route);
    await completeOnboarding(f.db);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const KerfPlanApp(),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  Future<void> tap(WidgetTester tester, String text) async {
    if (find.text(text).evaluate().isEmpty) {
      await tester.scrollUntilVisible(
        find.text(text),
        200,
        scrollable: find
            .descendant(
              of: find.byType(ListView).first,
              matching: find.byType(Scrollable),
            )
            .first,
      );
    }
    final button = find.text(text).last;
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pumpAndSettle();
  }

  testWidgets('Free paywall shows both Play-localized prices and restores', (
    tester,
  ) async {
    await start(tester);
    expect(find.text('Unlock Lifetime Pro — ¥1,234'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Remove Ads — €4,20'), 200);
    expect(find.text('Remove Ads — €4,20'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Restore purchases'), 200);
    expect(find.text('Restore purchases'), findsOneWidget);
  });
  for (final product in BillingProduct.values) {
    testWidgets('${product.id} owned state offers only applicable upgrades', (
      tester,
    ) async {
      b.gateway.purchases = [purchase(product)];
      await start(tester);
      if (product == BillingProduct.lifetimePro) {
        expect(find.text('Lifetime Pro active'), findsOneWidget);
        expect(find.textContaining('Unlock Lifetime Pro —'), findsNothing);
        await tester.scrollUntilVisible(
          find.text('Included with Lifetime Pro'),
          200,
        );
      } else {
        expect(find.text('Unlock Lifetime Pro — ¥1,234'), findsOneWidget);
        await tester.scrollUntilVisible(find.text('Ad-free'), 200);
        expect(find.textContaining('Remove Ads —'), findsNothing);
      }
    });
  }
  testWidgets('pending purchase is explained without granting Pro', (
    tester,
  ) async {
    await start(tester);
    b.gateway.events.add([
      purchase(BillingProduct.lifetimePro, status: StorePurchaseStatus.pending),
    ]);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.textContaining('Your purchase is waiting'),
      200,
    );
    expect(b.cache.value.isPro, isFalse);
  });
  testWidgets('unavailable store has safe Retry and cached Pro stays active', (
    tester,
  ) async {
    b.gateway.available = false;
    b.cache.value = const Entitlements(lifetimeProOwned: true);
    await start(tester);
    expect(find.text('Lifetime Pro active'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Purchases are unavailable right now.'),
      200,
    );
    await tap(tester, 'Retry');
    expect(b.cache.value.isPro, isTrue);
  });
  for (final missing in BillingProduct.values) {
    testWidgets('missing ${missing.id} disables only that product', (
      tester,
    ) async {
      b.gateway.products.removeWhere((p) => p.product == missing);
      await start(tester);
      await tester.scrollUntilVisible(
        find.text('Temporarily unavailable.'),
        200,
      );
      final disabled = tester.widget<FilledButton>(
        find.ancestor(
          of: find.text('Temporarily unavailable.'),
          matching: find.byType(FilledButton),
        ),
      );
      expect(disabled.onPressed, isNull);
      final available = find.text(
        missing == BillingProduct.removeAds
            ? 'Unlock Lifetime Pro — ¥1,234'
            : 'Remove Ads — €4,20',
      );
      await tester.ensureVisible(available);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<FilledButton>(
              find.ancestor(of: available, matching: find.byType(FilledButton)),
            )
            .onPressed,
        isNotNull,
      );
    });
  }
  testWidgets('purchase cancellation is calm and never grants', (tester) async {
    await start(tester);
    await tap(tester, 'Unlock Lifetime Pro — ¥1,234');
    b.gateway.events.add([
      purchase(
        BillingProduct.lifetimePro,
        status: StorePurchaseStatus.canceled,
      ),
    ]);
    await tester.pumpAndSettle();
    expect(b.cache.value.isPro, isFalse);
    expect(
      find.text('Couldn’t complete the purchase. Try again.'),
      findsNothing,
    );
  });
  testWidgets(
    'Restore success updates cached state and displays real outcome',
    (tester) async {
      await start(tester);
      b.gateway.purchases = [purchase(BillingProduct.lifetimePro)];
      await tap(tester, 'Restore purchases');
      expect(b.cache.value.isPro, isTrue);
      await tester.ensureVisible(find.text('Lifetime Pro restored'));
      await tester.pumpAndSettle();
      expect(find.text('Lifetime Pro restored'), findsOneWidget);
    },
  );
  testWidgets(
    'Restore failure preserves ownership and hides technical errors',
    (tester) async {
      b.gateway.available = false;
      b.cache.value = const Entitlements(lifetimeProOwned: true);
      await start(tester);
      await tap(tester, 'Restore purchases');
      expect(
        find.text('Couldn’t restore purchases. Try again.'),
        findsOneWidget,
      );
      expect(find.textContaining(testToken), findsNothing);
      expect(b.cache.value.isPro, isTrue);
    },
  );
  for (final owned in [
    const Entitlements(),
    const Entitlements(removeAdsOwned: true),
    const Entitlements(lifetimeProOwned: true),
  ]) {
    testWidgets(
      'Settings entitlement state pro=${owned.isPro} adFree=${owned.isAdFree}',
      (tester) async {
        b.gateway.available = false;
        b.cache.value = owned;
        await start(tester, route: '/settings');
        final label = owned.isPro
            ? 'Lifetime Pro active'
            : owned.isAdFree
            ? 'Ad-free'
            : 'KerfPlan Free';
        await tester.ensureVisible(find.text(label));
        await tester.pumpAndSettle();
        expect(find.text(label), findsOneWidget);
        if (!owned.isPro) {
          await tap(tester, owned.isAdFree ? 'View Pro' : 'Upgrade');
          expect(find.byType(ProScreen), findsOneWidget);
          expect(b.gateway.subscriptions, 1);
        }
      },
    );
  }
  testWidgets('Settings Restore uses application controller', (tester) async {
    await start(tester, route: '/settings');
    final before = b.gateway.queries;
    b.gateway.purchases = [purchase(BillingProduct.removeAds)];
    await tap(tester, 'Restore purchases');
    expect(b.gateway.queries, before + 1);
    expect(b.cache.value.isAdFree, isTrue);
    expect(b.gateway.subscriptions, 1);
  });
  testWidgets('Firebase failure leaves Home, Project and Calculate usable', (
    tester,
  ) async {
    b.verifier.prepareFails = true;
    b.cache.value = const Entitlements(lifetimeProOwned: true);
    await f.stock(1000);
    await f.part(400);
    final container = await start(tester, route: '/');
    expect(find.text('Workshop'), findsOneWidget);
    await tap(tester, 'Workshop');
    await tap(tester, 'Calculate');
    expect(find.text('Cut plan'), findsOneWidget);
    expect(b.cache.value.isPro, isTrue);
    container.read(routerProvider).go('/');
    await tester.pumpAndSettle();
    expect(find.text('Workshop'), findsOneWidget);
  });
  testWidgets(
    'small landscape paywall scrolls without overflow and has large actions',
    (tester) async {
      tester.view.physicalSize = const Size(640, 360);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await start(tester);
      await tester.scrollUntilVisible(
        find.text('Unlock Lifetime Pro — ¥1,234'),
        160,
      );
      final button = find.ancestor(
        of: find.text('Unlock Lifetime Pro — ¥1,234'),
        matching: find.byType(FilledButton),
      );
      expect(tester.getSize(button).height, greaterThanOrEqualTo(48));
      expect(tester.takeException(), isNull);
    },
  );
}
