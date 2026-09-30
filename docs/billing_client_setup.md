# Flutter billing client

## Implemented

The existing generated `lib/firebase_options.dart`, Android `google-services.json`,
and FlutterFire Gradle integration identify Firebase project `kerfplan` and Android
package `com.kerfplan.app`. These were present before this milestone and were not
fabricated or manually edited. Their existence does not prove the backend, App
Check, signing fingerprints, or Play products are ready for real transactions.

The root application owns one billing controller/purchase-stream subscription.
Startup exposes the Drift entitlement cache immediately and launches reconciliation
after the first frame. Home/Project/Calculate never wait for Firebase or Play.
Resume and manual Restore coalesce concurrent refreshes; there is no polling.

`PlayBillingGateway` wraps the official plugins. Products are mapped by their IDs,
with the exact localized `ProductDetails.price`. Purchases use `buyNonConsumable`.
Android tokens come from `GooglePlayPurchaseDetails.billingClientPurchase.purchaseToken`;
receipt strings, prices, client status and order IDs are not ownership proof.
`queryPastPurchases` in Android plugin 0.5.3 calls `queryPurchases`, not consumed
purchase history. The plugin internally queries both in-app and subscription types;
KerfPlan filters strictly to its two one-time products and never offers subscriptions.

`FirebasePurchaseVerificationClient` initializes the generated options, activates
App Check, and uses the official callable SDK's `verifyPlayPurchase` method.
There is no hand-written HTTP protocol or direct Firestore access. Production uses
`AndroidPlayIntegrityProvider`; debug is an explicit, debug-build-only opt-in.
Reconciliation first requests a fresh App Check token. Failed/timeout exchanges
preserve cache, including when a store could otherwise return an empty snapshot.
Tokens are attached to callable requests by the Firebase SDK, never manually.

Only a strictly parsed, same-product backend response with `owned: true` and
`acknowledged: true` grants a local entitlement. Pending/cancelled/error and invalid
tokens do not grant anything. Backend `purchaseVoided`/`purchaseNotPurchased`
rejections are authoritative nonownership during reconciliation; other errors,
including product mismatch and malformed responses, make the run incomplete.
Any incomplete run preserves the entire existing cache. A complete successful
empty query can clear it. Multiple tokens for one product are combined so one
revoked token cannot erase another valid purchase of that product.

Purchase events and cache reconciliation run through one serialized queue. Events
arriving during a refresh invalidate that snapshot before replacement. Duplicate
successful events are deduplicated in memory. Raw tokens are transient method/event
values only: never persisted, logged, used in route state, or included in UI errors.
App restart obtains current tokens from Google Play again.

## Acknowledgement and completion

The backend acknowledges after its own verified persistence. The Flutter client
writes the cache only after the acknowledged response. Inspection of the resolved
`in_app_purchase_android` 0.5.3 implementation confirms `completePurchase` only
checks acknowledgement and calls Play acknowledgement if the supplied old details
say it is pending. There is no Android local transaction queue to finalize.
Therefore `finishVerifiedPurchase` requires no additional native call on Android.
Calling `completePurchase` on stale pre-backend details would issue a duplicate
acknowledgement. No consumption API is called. Revisit this adapter if plugin
semantics change or another platform is added; do not generalize this to iOS.

## Local database migration

Drift v1 -> v2 only creates `entitlement_cache(product_id, owned, last_verified_at)`.
No original tables, measurements, revisions or relationships are rewritten.
`test/fixtures/schema_v1.sqlite` is a populated database captured using the actual
v1 AppDatabase before migration. The migration test compares every original row,
checks the schema version, and exercises foreign-key cascades. The guarded capture
script in `tool/` documents fixture provenance; do not regenerate it with v2.

Missing cache rows mean Free. Lifetime Pro implies Pro and ad-free; Remove Ads
alone only implies ad-free. Timestamps are UTC. Full reconciliation replaces both
product states atomically. No token, order ID, receipt, price, account or profile
is stored. The cache survives offline startup and database reopen. It is offline
UX state, not a tamper-resistant substitute for server verification.

## UI and scope

`/pro` shows Lifetime Pro and Remove Ads with Play-localized prices, existing
ownership, pending/error feedback, Retry and Restore. A missing product disables
only that offer. Settings uses the same controller and displays Free, Ad-free or
Lifetime Pro active. No current feature is restricted; projects, stock, PDF, trim,
leftovers and all calculations remain available. No advertising is implemented.

The Android main manifest now declares INTERNET specifically for the approved
Firebase/App Check/callable integration. The Play Billing permission is supplied
by the official plugin manifest. No runtime/storage permission was added.

## Required real configuration and manual tests

1. Preserve the real Firebase Android registration for `com.kerfplan.app`. If
   selecting a different approved project, run `flutterfire configure` for the
   real project; never hand-write options or credentials. Do not add Firebase Auth
   or Google Sign-In. No in-app account is needed.
2. Finish the server-side IAM, RTDN and deployment steps in
   [billing_backend_setup.md](billing_backend_setup.md). This milestone does not
   deploy anything or claim a live callable test.
3. Use the approved production region **`europe-west4`** at build/run:

   ```sh
   flutter run --dart-define=BILLING_REGION=europe-west4
   flutter build apk --debug --dart-define=BILLING_REGION=europe-west4
   ```

   The backend receives `BILLING_REGION=europe-west4` from the local, ignored
   `functions/.env.kerfplan` file. Both second-generation functions share that
   parameter. Recreate this nonsecret setting in deployment checkouts, and confirm
   the deployed callable is in `europe-west4` before live testing. Firestore is
   planned for the same region. With the Flutter define absent, billing reports
   unavailable and core workflows/cached entitlements continue working; there is
   no implicit default region.
4. Register App Check / Play Integrity for the existing Firebase Android app and
   production signing fingerprints. The backend `BILLING_ANDROID_APP_ID` must equal
   this registration's Firebase App ID. Keep backend App Check enforcement on.
5. For development only, opt in explicitly:

   ```sh
   flutter run --dart-define=BILLING_REGION=europe-west4 --dart-define=APP_CHECK_DEBUG=true
   ```

   Register the official SDK-generated debug token in Firebase Console for that
   Android app. Never commit the token. Release/profile builds cannot select the
   debug provider through this flag. Production uses Play Integrity.
6. Configure/activate Play one-time non-consumable products `remove_ads` and
   `lifetime_pro`, licensed testers and a suitable Play-distributed test build.
   A normal locally sideloaded APK does not prove real billing works. Prices are
   configured only in Play Console.
7. On an eligible Android installation, test product prices, cancellation, pending
   payment, purchase, server verification/acknowledgement, restart/offline cache,
   restore, refund/revocation reconciliation, and backend/App Check failures.
   These live smoke tests remain manual until infrastructure, deployment and an
   eligible tester installation are confirmed. A failed verification must never
   silently grant Pro or strip previously verified offline ownership.

Local verification uses fake gateways/verification clients; ordinary Flutter tests
need no live Firebase services. Tests cover migration/rollback, cache reopen,
purchase ordering, restoration, response validation, races, paywall, Settings,
small-screen behavior and unchanged core workflows. Run the Flutter commands in
AGENTS.md plus `flutter build apk --debug --dart-define=BILLING_REGION=europe-west4`,
and the backend build/test/lint suite.

Feature gates, ads/UMP, subscriptions, local notifications, accounts, result history
and other monetization UI are deliberately deferred.

References: [official purchase plugin](https://pub.dev/packages/in_app_purchase),
[App Check Flutter providers](https://firebase.google.com/docs/app-check/flutter/default-providers),
[development debug provider](https://firebase.google.com/docs/app-check/flutter/debug-provider).
