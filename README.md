# KerfPlan

Offline Android application for 1D linear cutting stock planning.
Flutter 3.47.5 / Dart 3.13.4, Material 3, minimum Android SDK 24.
The Flutter SDK supplies compile/target SDK 36. Android application ID and namespace
are `com.kerfplan.app`. Play Console registration must confirm availability;
production signing remains separate work.

The UI supports English, Spanish, German, French, Brazilian Portuguese,
Italian, Polish, Russian, Turkish and Ukrainian. It follows the device language
by default, with English fallback; users can select a language in Settings.
See [localization review](docs/localization_review.md) for terminology and review notes.
First-launch measurement setup recommends Metric or Imperial from the platform
locale country; the user can override it. Language and units are independent.
See [measurement setup](docs/measurement_setup.md).

## Accountless billing backend foundation

`functions/` contains Node.js 22 / TypeScript Firebase second-generation Functions,
with server-side Google Play purchase verification, acknowledgement, and RTDN.
The intended later flow is Flutter -> Google Play Billing -> Cloud Function
verification -> Google Play Developer API -> local offline entitlement cache.
Google Login is intentionally not required for MVP. The Flutter billing, App Check,
and offline entitlement clients are now implemented; live purchases require cloud
and Play configuration. The cutting core stays offline.
No cloud infrastructure has been deployed. Configuration, security, local test
commands, and manual Play/Firebase steps are in
[the billing backend setup guide](docs/billing_backend_setup.md).

The client uses the existing real FlutterFire Android configuration. See
[billing client setup](docs/billing_client_setup.md) for the required Functions
region build setting, Play Integrity/debug App Check setup and manual purchase tests.
Drift schema v2 added the local entitlement cache; schema v3 adds a nullable
language preference; schema v4 adds measurement system and onboarding state.
These upgrades preserve existing project data. `/pro` and
Settings offer purchase/restore using backend verification.
No feature gates or ads are applied in this milestone.

## Structure

- `lib/app`: app composition, provider-owned router, repository/stream providers, themes.
- `lib/domain/models`: immutable project/stock/part entities, validated inputs, shared quantity rules,
  inventory mode, initial defaults, and deterministic duplicate naming.
- `lib/domain/units`: pure-Dart Length, exact decimal conversion, and display units.
- `lib/domain/optimizer`: synchronous pure-Dart FFD, immutable inputs/results, typed failures.
- `lib/domain/repositories`: ProjectRepository, StockRepository and PartRepository contracts without
  Drift/Flutter dependencies.
- `lib/data/db`: Drift schema v4 and provider-owned persistent database.
- `lib/data/repositories`: Drift implementation and domain mapping.
- `lib/presentation`: reactive Home/Project, stock/part editors, shared length/quantity inputs,
  first-launch measurement setup, and persisted Settings.
- `lib/l10n`: ten bundled languages in ARB and generated official Flutter localization classes.

## Project CRUD

Home observes SQLite projects ordered by updatedAt descending, createdAt descending,
then id as a deterministic final tie-breaker. Projects can be created, opened,
edited, duplicated, and deleted with confirmation. Errors show localized messages
and preserve form input. IDs come from uuid in the repository.

Routes use one navigator: `/`, `/settings`, `/projects/new`,
`/projects/:projectId`, and `/projects/:projectId/edit`. The route hierarchy gives
project/edit screens the correct Back destination, including direct navigation.
Routes retrieve persisted data by ID and show a not-found state after deletion.

Names are trimmed and required, with a maximum of 80 Unicode code points.
Material and note are optional, trimmed to null when blank, and limited to 120
and 500 code points. Entered values are validated, never truncated.

New project defaults are fixed inventory, mm display units, 3 mm kerf, zero end
trim, 100 mm minimum reusable length, null buy-stock length, revision zero and
no last run. App-level default overrides remain deferred.

Metadata edits preserve createdAt, revision, lastRunId, cut configuration and
children. Timestamps are stored/read as UTC and converted to local time only for
display. Schema v1 stores Unix seconds, so rapid edits advance updatedAt by at
least one second to ensure a persisted change.

Duplication is transactional: configuration and all stock/part rows are copied
with fresh UUIDs and timestamps; revision and lastRunId are reset. Names use the
localized Copy suffix and deterministic numbered collision handling. Only generated
copy names shorten their base with an explicit ellipsis when needed to fit 80
characters; the original name is preserved. Deletion uses existing foreign-key
cascades. There is no project-count limit in this iteration.

One tick is exactly 0.0001 mm. Use `Length.fromMillimeters('25.4')` or
`Length.fromInchFraction(1, 16)` to avoid floating-point conversion. Negative
values, sub-tick precision, and signed 64-bit overflow are rejected. SQLite tick
columns remain INTEGER. Project summaries and editors use the selected display
unit; imperial inputs use exact sixteenth fractions.

## Project cut settings

`/projects/:projectId/cut-settings` edits display units, kerf, end trim per end,
and the inclusive minimum reusable tail length. `CutSettingsInput` uses the same
nonnegative Length values as the rest of the domain. All three settings permit
zero; Stock, Buy Stock and Parts still require positive lengths.

`updateCutSettings` compares persisted values and saves atomically with the existing
project mutation helper. Kerf, trim or threshold changes increment revision once
per save. Unit-only changes update the timestamp without incrementing revision.
Identical saves change neither. Other project fields and stock/part rows are preserved.

Shared length controllers rebase unit controls from exact canonical values, without
reparsing rounded display strings. Untouched non-sixteenth values retain their ticks.
Invalid pending entries must be corrected before units can change. The short forms
keep all fields mounted so validation also covers offscreen imperial controls.

Trim warnings compare pending trim with active stock only. All-unusable and partially
unusable stock are distinguished; warnings allow saving. Project, Parts fit warnings,
Stock/Buy displays and Result observe saved settings. The existing result provider
recomputes current persisted inputs. No schema, optimizer, golden-test or default
changes, result persistence, app-level settings or Pro gating are included.

## Stock input

Fixed inventory supports persisted add/edit/duplicate/delete operations with exact
Length values, quantities 1 through 9999, optional trimmed 80-character labels,
confirmation before deletion, and row/piece summaries. New and duplicate rows append
deterministically; display ordering is sortOrder, createdAt, then id.

Buy mode stores one positive length in the project, without stock rows or quantity.
Switching modes preserves both fixed rows and the buy length. A missing buy length
is allowed on mode switch and prompts the user to set it. Neither mode enforces
future Free/Pro limits.

Optimization-relevant changes atomically increment revision once and update the
project timestamp. Label-only edits update stock/project timestamps without a
revision increment. Identical stock, mode, or buy-length saves are no-ops. Project
metadata, cut settings, createdAt and lastRunId are preserved by stock mutations.

Metric input supports mm/cm/m. Dot/comma decimal separators convert through integer
arithmetic; unsupported precision is rejected, never silently rounded. All editors
(Stock, Buy Stock and Parts) share LengthInputField and LengthEditingController.
ImperialLength supplies pure-Dart exact sixteenth-inch conversion and formatting:
whole inches + fraction in inch mode, feet + inches + fraction in ftIn mode.
The inches component in ftIn must be 0..11; invalid values prompt for additional feet.
Fractions reduce for display (2/16 becomes 1/8). Values not exactly on the sixteenth
grid display rounded to the nearest sixteenth with an approximation marker.
Opening/saving an existing rounded imperial value preserves the original ticks;
focusing a field does not count as an edit. Actual length-control edits opt into
the fraction value. The editor also shows exact stored millimeters when approximate.
Decimal-inch conversion remains available in the domain layer.

Stock routes are `/projects/:projectId/stock/new`,
`/projects/:projectId/stock/:stockId/edit`, and `/projects/:projectId/stock/buy`.
Editors react safely to deleted stock/projects. Shared save forms preserve input
on failure and prevent repeated submissions. Quantity steppers have 48dp targets.

## Parts input and fit warnings

Parts have positive Length values, quantities 1..9999 and optional trimmed names
up to 100 Unicode code points. Add/edit/duplicate/delete persist through Drift.
Rows represent separate named groups; equal lengths are never automatically merged.
New and duplicate rows append deterministically, ordered by sortOrder, createdAt, id.
All optimization-relevant part changes increment the project revision exactly once
within the existing transaction helper. Name-only edits change part/project timestamps
without incrementing revision; identical saves are no-ops. Deletion requires confirmation.

Routes are `/projects/:projectId/parts/new` and
`/projects/:projectId/parts/:partId/edit`. Missing/deleted IDs show a safe not-found
state. The reactive Parts section shows row and piece counts, with no optimization
statistics. Shared form controls preserve inputs on failure and prevent double saves.

Part forms show a nonblocking warning when the part exceeds the largest active stock
length minus two end trims. Buy mode uses only the configured buy length. Missing stock
configuration produces no impossible-length claim; excessive trims clamp usable stock
to zero. No kerf is added to this standalone-part check. Warnings update when inputs
or stock configuration change and never prevent saving.

App-level Settings remains a placeholder. Save-and-add-another, reorder,
and bulk import remain deferred.

## Calculate and Result

Calculate requires parts plus Fixed stock or a positive Buy length. Oversized parts
remain eligible and become typed unplaced results. A small OptimizationCoordinator
reads project, stock and parts in one Drift read transaction through repository methods,
maps their exact lengths, IDs and sortOrder, and invokes the unchanged synchronous
FfdCutOptimizer. No isolate or new dependency is needed.

`optimizationResultProvider(projectId)` owns the transient calculation. It observes
the project's saved input signature (all repository child mutations touch updatedAt),
refreshes for saved changes and deletion, and ignores unrelated widget rebuilds.
Calculate holds one subscription until Result takes over, preventing duplicate work.
Direct `/projects/:projectId/result` navigation loads current saved inputs. Recalculate
reloads, hiding old values while pending. Edit cut list returns to Project. Failures,
missing inputs and deleted projects show localized states without technical exceptions.

Result displays actual used/buy counts, requested/placed/unplaced counts, finished and
used stock lengths, waste to one decimal percent, reusable tails, scrap, kerf and trim.
Partial and all-unplaced calculations remain valid results. Unplaced instances group
only by source ID and reason. Used bars and their ordered part lists retain optimizer
order. Stock and tail lengths respect the project's metric or imperial display unit.

The lazy bar list uses a 64dp CustomPainter diagram: exact tick segments cover the full
stock, including both trims, finished parts, kerfAfter gaps and the tail. Only canvas
coordinates use floating-point ratios. Narrow parts omit text; numbered ordered lists
below provide every length. Scrap/trim use hatching, and separate TalkBack descriptions
explain each bar without relying on colors. Geometry has independent non-pixel tests.

Schema remains v1. No results are serialized or persisted. Result history,
leftover-to-stock actions, monetization, accounts and networking are deferred.

## Offline reports and sharing

Result's Share menu offers Share text, Share PDF, and Buy-only Copy buy list.
Recalculate and Edit cut list remain available. A `CutReportData` snapshot combines
the immutable current project/result with a caller-supplied timestamp and localized
report strings. Text and PDF consume the same snapshot, reuse the existing length
formatter, and retain optimizer bar/part order and unplaced source identity.
No optimization totals are recalculated by either exporter.

`pdf` 3.13.1 builds A4 MultiPage reports in memory with settings, summary, purchase
quantity, native vector bar diagrams, ordered cuts, classified tails, unplaced
reasons and a measurement/safety reminder. Short bar lists stay together; long ones
continue under repeated bar headings. Diagrams reuse the on-screen tick geometry.
Noto Sans Regular/Bold and Noto Sans Math are bundled with their OFL license for
offline Latin/Cyrillic text and measurement symbols. This is not universal script
or emoji coverage. No remote fonts or runtime network calls are used.

`ReportShareService` centralizes `SharePlus.instance.share(ShareParams(...))`
using share_plus 13.3.0. PDFs use `XFile.fromData`, application/pdf and a sanitized,
date-based filename override. The plugin may stage an in-memory file in its private
temporary cache for the receiving app; KerfPlan creates no permanent report file.
No Downloads flow, printing UI, storage permissions or result history are added.
Dismissed/unavailable share feedback is normal; exceptions get localized errors.
PDF generation disables repeated sharing until complete. Buy copying uses the
Flutter SDK clipboard and preserves the selected units.

Local PDF layout review (Windows, no extra renderer installation):

```sh
flutter test test/export/cut_report_pdf_test.dart --dart-define=REPORT_SAMPLE_DIR=.dart_tool/report_samples
powershell -NoProfile -ExecutionPolicy Bypass -File tool/render_report_pdf.ps1
```

The script uses Windows' PDF renderer and writes review images next to optional
test samples in `.dart_tool`, outside application behavior. The execution-policy
flag applies only to that process, without changing machine configuration.
Sample reports include Cyrillic, imperial fractions, 500-character notes, partial
jobs, 150 cuts and 100 used bars. No Android device or configured AVD was available
for a live system-share-sheet smoke check; platform calls are covered by tests.

## Domain optimizer

`const FfdCutOptimizer().optimize(OptimizationInput(...))` is synchronous and takes
repository-independent snapshots of stock and part groups. It never queries storage
or mutates inputs. First Fit Decreasing is deterministic and fast but does not
guarantee the globally minimum waste solution. For example, with zero kerf and
10-unit stock, parts 6, 5, 3, 2, 2, 2 use three FFD bars although a two-bar arrangement
exists. No best-fit or local-improvement step is applied.

Parts sort by descending length, source stableOrder, instance index, then source ID.
Opened bars are tried in opening order. Fixed mode chooses the shortest usable
unopened stock, breaking ties by stableOrder, physical instance index, then source ID.
Buy mode opens a standard bar only when needed and when the part fits. Unplaced
instances retain source identity and distinguish tooLong from inventoryExhausted.

Kerf exists only between finished parts: N parts have N-1 kerfs, with no trailing
kerf even when a tail remains. Trim is removed from each end. Only placed parts and
used bars enter totals. Waste is used stock minus finished length; reusable material
is only tails at or above the inclusive threshold; scrap is waste minus reusable.
All physical lengths use integer ticks; only the derived waste percentage uses double.

Length already rejects negative measurements. The optimizer rejects invalid rows,
duplicate source IDs, missing stock configuration and unusable Buy stock with typed
failures. Unusable Fixed bars are skipped; if none fits, parts are tooLong. Aggregate
overflow beyond the existing Length range fails explicitly rather than wrapping.
Result collections are unmodifiable. Schema v1 and all optimizer golden contracts remain unchanged.

Run `dart run tool/benchmark_optimizer.dart` for the 300-part/100-bar host benchmark.
Android performance profiling and isolate decisions belong to UI integration.

## Generate and verify

```sh
flutter pub get
flutter gen-l10n
dart run build_runner build
dart format .
flutter analyze
flutter test
flutter build apk --debug --dart-define=BILLING_REGION=europe-west4
```

Do not edit generated Drift or localization Dart files by hand. See AGENTS.md
for project constraints. Keep source/helper scripts outside generated `build/`.
Debug/profile INTERNET permissions are pre-existing Flutter tooling permissions;
the main manifest has no INTERNET permission.

## Verified state

The optimizer baseline has 196 tests. Integration adds 37 tests covering persisted
snapshot mapping, provider reuse/refresh, Calculate enablement, Result success/error
flows, grouping, geometry, TalkBack, lazy bars and small screens. Optimizer golden
tests are unchanged. Existing permanent-placeholder UI assertions now reflect the
working Calculate action.
Project cut settings add 56 tests for zero/negative validation, exact unit rebasing,
atomic revisions and rollback, active-stock trim warnings, optimizer integration,
live UI formatting, navigation, save failures and small-screen dark-mode forms.
Reports add 44 tests for text/snapshots, safe filenames, offline PDF generation,
font coverage, sharing parameters/cancellation/errors, clipboard, busy states,
accessibility and small screens. All 289 pre-export tests remain unchanged.

The installed toolchain emits Java native-access and SDK XML-version warnings. Pub reports five newer packages outside the current compatible
constraints. These notices do not prevent verification; no SDK/JDK/Gradle or
unrelated dependency upgrades were made in this iteration.
