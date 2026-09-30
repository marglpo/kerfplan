# Billing backend foundation

## Done in code

- Android namespace, application ID, and MainActivity use `com.kerfplan.app`.
  SDK levels, signing, Gradle versions, and permissions are unchanged. The package
  name is intended for production, **not confirmed available**. It becomes final
  only after successfully registering the Play Console app with this ID. Installing
  this package is a separate app from the former development package; Android does
  not transfer that app's local database automatically. No database is deleted.
- Firebase second-generation callable `verifyPlayPurchase` and Pub/Sub function
  `handlePlayRtdn`, TypeScript, deployed Node.js **22**. No deployment performed.
- Products are centrally allowlisted in `functions/src/config.ts`: `remove_ads`
  and `lifetime_pro`, both one-time non-consumables. No consumption or price logic.
- The later Flutter client milestone is described in [billing_client_setup.md](billing_client_setup.md).
  It adds billing/App Check and a Drift v2 local entitlement cache without feature
  gates. Google Login and Firebase Auth remain absent. Firestore contains backend
  purchases, not project data.

## Verification contract and security

The callable accepts **only** `{ productId, purchaseToken }`. The product must be
allowlisted; token must be a nonempty, whitespace-free string of at most 4096
characters. Unknown request properties (including package name or client purchase
status) are rejected. No Auth login is required. The deployed wrapper enforces
App Check and checks the verified App Check app ID against `BILLING_ANDROID_APP_ID`.
App Check alone is not ownership proof; every verification reads Google Play.

The official `googleapis` Android Publisher v3 client calls
`purchases.productsv2.getproductpurchasev2` with the server's fixed package name.
The v2 response does not carry a package name; the package-bound API request
establishes that scope. Its returned product line item must match the requested
product, purchase state must be `PURCHASED`, and a fully refunded, consumed, or
rental item cannot grant non-consumable ownership. Pending/cancelled/unknown state
returns `owned: false`. Zero refundable quantity on a `PURCHASED` item revokes
ownership; a still-pending payment is not treated as a refund. Missing
optional refundable quantity alone is not interpreted as a refund; full-refund
RTDN supplies a durable revocation tombstone. The setup must use purchase (not
rent) options for these products.

After verified persistence, the server calls `purchases.products.acknowledge` only
when not already acknowledged. It never consumes. A transactional 60-second lease
prevents simultaneous requests from both acknowledging. API calls have 15-second
timeouts, without automatic HTTP retries. If the process crashes, retry verification
after the lease expires; Play's current acknowledgement state resolves ambiguous
success. Exactly-once delivery across the external API and Firestore cannot be
guaranteed, but repeated calls converge to one purchase document.

A successful response contains only `productId`, `owned`, `verifiedAt` (UTC ISO),
and `acknowledged`. No token, raw receipt, document ID, or Google response is returned.
Safe callable error codes are `invalid-argument`, `failed-precondition`, and
`unavailable`, with stable `details.reason` codes:
`invalidArgument`, `unsupportedProduct`, `playApiUnavailable`,
`purchaseNotPurchased`, `productMismatch`, `purchaseVoided`,
`acknowledgementFailed`, `storageFailure`.
The future Flutter client should localize these codes rather than displaying raw
server text, retry transient errors, and never interpret an error as ownership.

Acknowledgement failure leaves the verified record intact with a safe error code;
the callable returns `unavailable`, not a false acknowledgement success. Subsequent
callable or purchased RTDN retries can finish it. No raw tokens are stored for a
scheduled retry worker; RTDN retry delivery or client reconciliation must supply
the token again. Monitor repeated failures before Play's acknowledgement deadline.

## Firestore and token handling

Admin SDK uses `playPurchases/{sha256(purchaseToken)}`. SHA-256 is deterministic,
unkeyed, and calculated over the exact UTF-8 token. The hash is an internal lookup
key, not authentication. Records hold product/package, purchase state, acknowledged
flag, safe acknowledgement error, temporary lease ID/expiry, purchase time when
available, first/last verification times, voided flag, and event type/time.
No emails, device profiles, IPs, raw tokens, credentials, receipts, or Google
response blobs are stored. Full-refund-before-verification creates a tombstone
with product ID null until known; it cannot grant ownership. Transactions preserve
revocation even if verification or acknowledgement was already in flight.

`firestore.rules` denies **all** client reads and writes. Admin access bypasses
rules and must be constrained through runtime IAM. Logs contain only controlled
events, token hashes, supported product IDs, and safe error codes. Google SDK
exceptions are discarded at the boundary because they may contain request URLs
with tokens. Do not enable request-body/token debug logging in cloud operations.

## RTDN and refunds

The configured Pub/Sub topic must be private to trusted publishers. The handler
validates the package, message shape and timestamp. Purchased events query Google
and use the same verification/acknowledgement path. Pending-purchase cancellation
events mark nonownership and never grant or acknowledge. Unknown events,
subscription notifications, wrong packages, and malformed payloads are ignored
safely. Test messages log success without creating purchases.

One-time full-refund notifications (`productType = 2`, `refundType = 1`) revoke the
exact token, even before a purchase record exists. Partial quantity refunds query
current Google state and remaining quantity; they are not assumed to revoke every
item. Duplicate deliveries converge to the same record. Transient API/storage/ack
errors throw sanitized errors for Pub/Sub retry; permanent invalid purchases do
not cause poison-message retry loops. Repeated purchased events may query Google
again; there is no separate notification-history collection.

There is no account or device push connection. An offline device cannot be revoked
instantly. Later online reconciliation must stop granting a refunded token. The
Voided Purchases API can supplement RTDN with periodic reconciliation in a future
milestone; no scheduler is implemented now.

## Local verification

Use Node.js 22 (current patch; lint tooling requires at least 22.13) and npm:

```sh
cd functions
npm install
npm run build
npm test
npm run lint
```

Versions are pinned in package.json and npm-generated package-lock.json. `npm ci`
is appropriate for repeatable CI. Tests use fake publisher/repository interfaces
and a stubbed HTTP transport for official-client endpoint checks. They require
neither credentials nor network/production Firestore. They cover input security,
Google states/product mismatch, persistence-before-ack, acknowledgement failures,
idempotency/concurrency, refund races, RTDN, and safe error/log boundaries.
Firestore emulator integration is not configured; real IAM, rules deployment,
App Check/Play Integrity and Play test purchases still require cloud validation.

This workstation has Node 24; local results must be reported as such. Deployment
runtime is explicitly 22 in both package.json and firebase.json. Do not change a
machine-wide Node installation merely to suppress npm's engine notice.

## Manual cloud / Play Console steps (not completed)

1. Create or select the real Firebase / Google Cloud project. Confirm ownership,
   region, billing budget and a billing plan supporting Functions deployment
   (Firebase Blaze). Enable Firestore in the chosen region and required Functions,
   Cloud Run, Eventarc, Pub/Sub and build/artifact services as deployment requires.
2. Register the Google Play Console application with `com.kerfplan.app`; confirm
   package availability with a correctly packaged upload. Configure production
   signing separately. No production key has been created here.
3. Enable Google Play Android Developer API in the selected Cloud project. Create
   a dedicated runtime service identity and grant access to this Play app using
   Play Console users/permissions. Current documented billing permissions include
   viewing financial/order data and managing orders/subscriptions. Restrict scope
   to KerfPlan where supported, verify GET and acknowledgement with test purchases,
   and do not grant owner/editor or publishing privileges merely for billing.
4. Give the runtime identity Firestore data access (for example the appropriate
   Datastore User role), logging access, and trigger/invoker permissions required
   for second-generation delivery. Separate deployer and runtime identities.
   Use Application Default Credentials; **never create/commit a JSON key**.
5. Create and activate exactly `remove_ads` and `lifetime_pro` as one-time purchase
   products, non-consumable in the client/backend flow. Use purchase options, not
   rentals. Configure prices, licensed testers and an appropriate test track in
   Play Console. There are no subscriptions or hardcoded prices in this code.
6. Create an RTDN Pub/Sub topic. Grant Pub/Sub Publisher on that topic to
   `google-play-developer-notifications@system.gserviceaccount.com`. Restrict other
   publishers; a packageName field alone does not authenticate a publisher.
   Configure Play RTDN with the full real topic resource and enable one-time
   product notifications as well as voided notifications. The Functions trigger
   handles its subscription; do not expose an unauthenticated custom webhook.
7. Register the Android app in Firebase using the production package. Configure
   App Check with Play Integrity, including the appropriate signing fingerprints
   and distribution configuration. The Flutter App Check client now exists but
   needs real Console/provider and region setup. Do not disable enforcement
   to bypass unfinished client integration. No Firebase Auth setup is needed.
8. With the Firebase CLI available and authorized, run `firebase login` and
   `firebase use --add` in the repository to select the real project. No
   `.firebaserc`, Google services file, or fake project ID is supplied here.
9. Provide the required nonsecret Functions parameters when prompted at deploy,
   or in an ignored `functions/.env.<real-project-id>`:
   - `PLAY_RTDN_TOPIC`: existing topic name within the selected project.
   - `BILLING_REGION`: `europe-west4`, supplied in `functions/.env.kerfplan` for
     Firebase project `kerfplan`. Both second-generation functions use this
     parameter. Firestore's planned location is also `europe-west4`; its actual
     location must be confirmed in Firebase Console. Keep the Flutter build's
     `--dart-define=BILLING_REGION=europe-west4` identical. The project-specific
     environment file is local/ignored; recreate this nonsecret setting in any
     deployment checkout. Deployment and live region verification remain manual.
   - `BILLING_SERVICE_ACCOUNT`: dedicated runtime service-account email.
   - `BILLING_ANDROID_APP_ID`: Firebase Android App ID for KerfPlan (not package name).
   These are configuration values, not service-account credentials.
10. Only after explicit deployment authorization and the preceding configuration,
    run local checks and deploy `firebase deploy --only firestore:rules,functions:billing`.
    Verify callable invoker access allows the accountless client to reach App Check
    enforcement. Verify missing/invalid App Check is rejected and unrelated Firebase
    app registrations are rejected. Send a Play test notification, test both products,
    acknowledgement, cancellation and full refund, and confirm safe logs. Establish
    monitoring for Pub/Sub failures/API quotas and acknowledgement failures; review
    retry retention/dead-letter handling before launch.

No cloud deployment, live purchase verification, or emulator integration is claimed
by local unit tests. Flutter client configuration and live purchase smoke tests
are tracked in the client guide. Feature gates remain deferred. Core calculations
must remain offline.

## Official references consulted

- [One-time purchase v2 resource](https://developers.google.com/android-publisher/api-ref/rest/v3/purchases.productsv2)
- [Server acknowledgement](https://developers.google.com/android-publisher/api-ref/rest/v3/purchases.products/acknowledge)
- [RTDN message reference](https://developer.android.com/google/play/billing/rtdn-reference)
- [RTDN topic permissions and setup](https://developer.android.com/google/play/billing/getting-ready)
- [Play service-account access](https://developers.google.com/android-publisher/getting_started)
- [App Check enforcement](https://firebase.google.com/docs/app-check/cloud-functions)
- [Functions runtimes](https://firebase.google.com/docs/functions/manage-functions)
- [Second-generation Pub/Sub triggers](https://firebase.google.com/docs/functions/pubsub-events)
