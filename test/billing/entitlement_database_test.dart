import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/data/db/app_database.dart';
import 'package:kerfplan/data/repositories/drift_entitlement_repository.dart';
import 'package:kerfplan/domain/billing/billing_product.dart';
import 'package:kerfplan/domain/billing/entitlements.dart';

void main() {
  test('real populated v1 fixture upgrades to v2 preserving every original row and relationship', () async {
    final dir = await Directory.systemTemp.createTemp('kerfplan-v2-');
    final file = await File('test/fixtures/schema_v1.sqlite')
        .copy('${dir.path}/migration.sqlite');
    final before = <String, List<Map<String, Object?>>>{};
    final tables = ['projects', 'stock_lines', 'part_lines', 'app_settings'];
    final db = AppDatabase.withExecutor(
      NativeDatabase(
        file,
        setup: (sqlite) {
          expect(
            sqlite.select('PRAGMA user_version').single['user_version'],
            1,
          );
          expect(
            sqlite.select(
              "SELECT name FROM sqlite_master WHERE name='entitlement_cache'",
            ),
            isEmpty,
          );
          for (final table in tables) {
            before[table] = [
              for (final row in sqlite.select('SELECT * FROM $table'))
                Map.of(row),
            ];
          }
        },
      ),
    );
    try {
      final cache = DriftEntitlementRepository(db);
      expect(await cache.getEntitlements(), const Entitlements());
      expect(
        (await db.customSelect('PRAGMA user_version').getSingle()).read<int>(
          'user_version',
        ),
        2,
      );
      for (final table in tables) {
        expect([
          for (final row in await db.customSelect('SELECT * FROM $table').get())
            row.data,
        ], before[table]);
      }
      final project = await db.select(db.projects).getSingle();
      expect(project.revision, 17);
      expect(project.kerfTicks, 31750);
      expect(project.endTrimTicks, 12345);
      expect(project.lastRunId, 'old-run');
      expect(
        (await db.select(db.stockLines).getSingle()).lengthTicks,
        60000001,
      );
      expect((await db.select(db.partLines).getSingle()).lengthTicks, 12096750);
      expect((await db.select(db.appSettings).getSingle()).themeMode, 'dark');
      await db.delete(db.projects).go();
      expect(await db.select(db.stockLines).get(), isEmpty);
      expect(await db.select(db.partLines).get(), isEmpty);
    } finally {
      await db.close();
      await dir.delete(recursive: true);
    }
  });

  for (final product in BillingProduct.values) {
    test(
      '${product.id} exact ownership and verification time survive database reopen',
      () async {
        final dir = await Directory.systemTemp.createTemp(
          'kerfplan-entitlement-',
        );
        final file = File('${dir.path}/cache.sqlite');
        final time = DateTime.utc(2026, 9, 28, 1, 2, 3);
        var db = AppDatabase.withExecutor(NativeDatabase(file));
        await DriftEntitlementRepository(db)
            .setProductOwned(product, true, time);
        await db.close();
        db = AppDatabase.withExecutor(NativeDatabase(file));
        try {
          final owned = await DriftEntitlementRepository(db).getEntitlements();
          expect(owned.isAdFree, isTrue);
          expect(owned.isPro, product == BillingProduct.lifetimePro);
          expect(
            (await db.select(db.entitlementCache).getSingle()).lastVerifiedAt!
                .toUtc(),
            time,
          );
          final columns = await db
              .customSelect('PRAGMA table_info(entitlement_cache)')
              .get();
          expect(columns.map((r) => r.read<String>('name')), [
            'product_id',
            'owned',
            'last_verified_at',
          ]);
        } finally {
          await db.close();
          await dir.delete(recursive: true);
        }
      },
    );
  }
  test(
    'fresh cache is Free; replacement clears absent products and streams react',
    () async {
      final db = AppDatabase.withExecutor(NativeDatabase.memory());
      final repo = DriftEntitlementRepository(db);
      try {
        expect(await repo.getEntitlements(), const Entitlements());
        final stream = repo.watchEntitlements().firstWhere((e) => e.isPro);
        await repo.setProductOwned(
          BillingProduct.lifetimePro,
          true,
          DateTime.now(),
        );
        expect((await stream).isPro, isTrue);
        await repo.replaceFromSuccessfulReconciliation(
          {},
          verifiedAt: DateTime.now(),
        );
        expect(await repo.getEntitlements(), const Entitlements());
      } finally {
        await db.close();
      }
    },
  );
  test(
    'failed reconciliation cache transaction rolls back both products',
    () async {
      final db = AppDatabase.withExecutor(NativeDatabase.memory());
      final repo = DriftEntitlementRepository(db);
      try {
        await repo.setProductOwned(
          BillingProduct.lifetimePro,
          true,
          DateTime.now(),
        );
        await db.customStatement(
          "CREATE TRIGGER fail_cache BEFORE UPDATE ON entitlement_cache BEGIN SELECT RAISE(ABORT, 'test failure'); END",
        );
        await expectLater(
          repo.replaceFromSuccessfulReconciliation({
            BillingProduct.removeAds: DateTime.now(),
          }, verifiedAt: DateTime.now()),
          throwsA(anything),
        );
        expect(
          await repo.getEntitlements(),
          const Entitlements(lifetimeProOwned: true),
        );
      } finally {
        await db.close();
      }
    },
  );
}
