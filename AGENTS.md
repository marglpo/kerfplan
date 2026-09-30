# KerfPlan agent instructions

1. This is a Flutter/Dart Android-first project.
2. Core app functionality must work offline.
3. No backend unless explicitly approved.
4. No Firebase unless explicitly approved.
5. No network API unless explicitly approved.
6. No accounts, login, or cloud sync.
7. 1D cutting only; never add 2D panel nesting to this app.
8. The optimizer must be deterministic.
9. Never store physical lengths as double, including in SQLite.
10. Canonical lengths use integer ticks: 1 tick = 0.0001 mm.
11. The domain optimizer must remain pure Dart without Flutter dependencies.
12. Avoid overengineering; keep domain / data / presentation understandable.
13. Do not add dependencies without a real need.
14. Do not add Android permissions without explicit justification.
15. All user-visible strings belong in ARB localization files.
16. Use Material 3.
17. Android minimum SDK is 24.
18. Run formatting, analyzer, and tests after meaningful changes.
19. Never manually modify generated files; use their generators.
20. Preserve working code when making future changes.
21. No ads on result screens when monetization is later implemented.
22. No subscription in MVP.
23. Do not implement features outside the current task scope.

Production application ID and namespace are `com.kerfplan.app`.
Do not change signing or permissions incidentally.
Use Riverpod and go_router, with Drift for local storage. Do not introduce DI
frameworks, trivial use cases, or repository abstractions without actual consumers.
The database provider owns its connection and closes it on container disposal.

Length accepts exact decimal millimeter strings and integer inch fractions.
Negative lengths, sub-tick precision, and signed 64-bit overflow are errors.
Never convert through double as an intermediate representation.

Optimizer invariants: keep the optimizer pure Dart. Kerf exists only between
finished parts, never after the final part; a single exact-fit part needs no
kerf. End trim is removed from each end. Preserve the deterministic FFD baseline
and do not change the heuristic without updating its numeric golden tests.

Standard verification commands, from the repository root:

```sh
dart format .
flutter pub get
flutter gen-l10n
dart run build_runner build
flutter analyze
flutter test
```

Generate localization after editing ARB. Generate Drift after editing tables.
Do not commit automatically; leave changes available for review.

The explicitly approved `functions/` backend verifies accountless Google Play
purchases. Core cutting stays offline; do not add unrelated backend/cloud features.
Keep product IDs `remove_ads` and `lifetime_pro` stable. Both are one-time,
non-consumable purchases: never consume them. Backend Google Play verification,
not client purchase claims, authorizes ownership. Never log or persist raw purchase
tokens or commit service-account keys. Production callable verification requires
App Check. Google Login and Firebase Auth are not part of MVP. Subscriptions need
explicit approval. Keep Firestore inaccessible to clients.

Backend verification, inside `functions/`: `npm install`, `npm run build`,
`npm test`, `npm run lint`. Use Node.js 22 for deployment. Do not deploy without
explicit authorization and real configuration; see `docs/billing_backend_setup.md`.

The approved Flutter billing client uses Firebase Core/App Check/callable Functions
and Google Play Billing without login. Drift schema v2 adds a local entitlement
cache; migrations must preserve existing project data. Failed/offline/partial
reconciliation must never clear cached ownership. Grant only after same-product
backend verification; keep acknowledgement server-side. Production App Check uses
Play Integrity; debug provider is explicit development-only. Configure the real
Functions region, never guess Firebase credentials. See `docs/billing_client_setup.md`.
Feature gating and ads remain outside this milestone.
