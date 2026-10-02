// Capture only with schema v2, before adding the language column.
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/data/db/app_database.dart';

void main() => test('capture populated v2 database', () async {
  final fixture = File('test/fixtures/schema_v2.sqlite');
  if (fixture.existsSync()) {
    throw StateError('Preserve the original v2 fixture');
  }
  final source = File('test/fixtures/schema_v1.sqlite');
  await source.copy(fixture.path);
  final db = AppDatabase.withExecutor(NativeDatabase(fixture));
  if (db.schemaVersion != 2) throw StateError('Requires schema v2');
  await db.customSelect('SELECT * FROM app_settings').get();
  await db.customStatement(
    "INSERT INTO entitlement_cache (product_id, owned, last_verified_at) "
    "VALUES ('lifetime_pro', 1, 1700000200)",
  );
  await db.close();
});
