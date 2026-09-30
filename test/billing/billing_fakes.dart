import 'dart:async';

import 'package:kerfplan/app/billing/billing_controller.dart';
import 'package:kerfplan/domain/billing/billing_gateway.dart';
import 'package:kerfplan/domain/billing/billing_product.dart';
import 'package:kerfplan/domain/billing/entitlements.dart';
import 'package:kerfplan/domain/billing/purchase_verification_client.dart';
import 'package:kerfplan/domain/repositories/entitlement_repository.dart';

const testToken = 'test-token-never-display';
StorePurchase purchase(
  BillingProduct product, {
  StorePurchaseStatus status = StorePurchaseStatus.purchased,
  String? token = testToken,
}) => StorePurchase(product.id, status, token: token);

class FakeBillingGateway implements BillingGateway {
  final events = StreamController<List<StorePurchase>>.broadcast(sync: true);
  bool available = true;
  bool queryFails = false;
  bool buyResult = true;
  bool buyFails = false;
  List<StorePurchase> purchases = [];
  List<StoreProduct> products = [
    const StoreProduct(BillingProduct.removeAds, '€4,20'),
    const StoreProduct(BillingProduct.lifetimePro, '¥1,234'),
  ];
  int queries = 0, subscriptions = 0, bought = 0, finished = 0;
  final List<String> order;
  Completer<void>? gate;
  FakeBillingGateway([List<String>? order]) : order = order ?? [];
  @override
  Stream<List<StorePurchase>> get purchaseStream {
    subscriptions++;
    return events.stream;
  }

  @override
  Future<bool> isAvailable() async => available;
  @override
  Future<List<StoreProduct>> queryProducts() async => products;
  @override
  Future<List<StorePurchase>> queryCurrentPurchases() async {
    queries++;
    await gate?.future;
    if (queryFails) throw StateError(testToken);
    return purchases;
  }

  @override
  Future<bool> buyNonConsumable(BillingProduct product) async {
    bought++;
    if (buyFails) throw StateError(testToken);
    return buyResult;
  }

  @override
  Future<void> finishVerifiedPurchase(StorePurchase purchase) async {
    finished++;
    order.add('finish');
  }
}

class FakeVerificationClient implements PurchaseVerificationClient {
  final List<String> order;
  FakeVerificationClient([List<String>? order]) : order = order ?? [];
  bool prepareFails = false;
  bool owned = true;
  bool acknowledged = true;
  final failures = <BillingProduct>{};
  final rejected = <BillingProduct>{};
  final calls = <BillingProduct>[];
  Completer<void>? gate;
  final time = DateTime.utc(2026, 9, 28, 1, 2, 3);
  @override
  Future<void> prepare() async {
    if (prepareFails) throw StateError(testToken);
  }

  @override
  Future<VerifiedPurchase> verifyPurchase(
    BillingProduct product,
    String token,
  ) async {
    calls.add(product);
    order.add('verify');
    await gate?.future;
    if (failures.contains(product)) throw StateError(testToken);
    if (rejected.contains(product)) throw const PurchaseRejected();
    return VerifiedPurchase(
      product: product,
      owned: owned,
      verifiedAt: time,
      acknowledged: acknowledged,
    );
  }
}

class FakeEntitlementRepository implements EntitlementRepository {
  final List<String> order;
  FakeEntitlementRepository([List<String>? order]) : order = order ?? [];
  final changes = StreamController<Entitlements>.broadcast();
  Entitlements value = const Entitlements();
  final times = <BillingProduct, DateTime>{};
  bool fail = false;
  int writes = 0, replacements = 0;
  @override
  Stream<Entitlements> watchEntitlements() async* {
    yield value;
    yield* changes.stream;
  }

  @override
  Future<Entitlements> getEntitlements() async => value;
  @override
  Future<void> setProductOwned(
    BillingProduct product,
    bool owned,
    DateTime verifiedAt,
  ) async {
    if (fail) throw StateError(testToken);
    order.add('cache');
    writes++;
    times[product] = verifiedAt;
    value = Entitlements(
      removeAdsOwned: product == BillingProduct.removeAds
          ? owned
          : value.removeAdsOwned,
      lifetimeProOwned: product == BillingProduct.lifetimePro
          ? owned
          : value.lifetimeProOwned,
    );
    changes.add(value);
  }

  @override
  Future<void> replaceFromSuccessfulReconciliation(
    Map<BillingProduct, DateTime> owned, {
    required DateTime verifiedAt,
  }) async {
    if (fail) throw StateError(testToken);
    replacements++;
    value = Entitlements(
      removeAdsOwned: owned.containsKey(BillingProduct.removeAds),
      lifetimeProOwned: owned.containsKey(BillingProduct.lifetimePro),
    );
    changes.add(value);
  }
}

class BillingFixture {
  final order = <String>[];
  late final gateway = FakeBillingGateway(order);
  late final verifier = FakeVerificationClient(order);
  late final cache = FakeEntitlementRepository(order);
  late final controller = BillingController(gateway, verifier, cache);
  Future<void> start() async {
    controller.start();
    await controller.refreshEntitlements();
  }

  Future<void> emit(StorePurchase event) async {
    gateway.events.add([event]);
    await Future<void>.delayed(Duration.zero);
  }

  Future<void> close() async {
    await controller.dispose();
    await gateway.events.close();
    await cache.changes.close();
  }
}
