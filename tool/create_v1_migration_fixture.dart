// Run only against schema v1. The committed fixture must never be regenerated
// using the current schema: it tests upgrading a real pre-entitlement database.
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/data/db/app_database.dart';

void main() => test('capture original v1 database', () async {
  final file = File('test/fixtures/schema_v1.sqlite');
  if (file.existsSync()) throw StateError('Preserve the original v1 fixture');
  file.parent.createSync(recursive: true);
  final db = AppDatabase.withExecutor(NativeDatabase(file));
  if (db.schemaVersion != 1) {
    throw StateError('Requires the original v1 schema');
  }
  await db.customStatement('''INSERT INTO projects
    (id,name,material,note,inventory_mode,display_unit,kerf_ticks,end_trim_ticks,
     min_reusable_ticks,buy_stock_length_ticks,revision,last_run_id,created_at,updated_at)
    VALUES ('fixture-project','Workshop','Steel','Preserve me','buy','ftIn',31750,12345,
     1016000,24384000,17,'old-run',1700000000,1700000100)''');
  await db.customStatement(
    '''INSERT INTO stock_lines
    (id,project_id,length_ticks,quantity,label,sort_order,created_at,updated_at)
    VALUES ('fixture-stock','fixture-project',60000001,7,'Rack',4,1700000000,1700000100)''',
  );
  await db.customStatement(
    '''INSERT INTO part_lines
    (id,project_id,name,length_ticks,quantity,sort_order,created_at,updated_at)
    VALUES ('fixture-part','fixture-project','Brace',12096750,6,3,1700000000,1700000100)''',
  );
  await db.customStatement('''INSERT INTO app_settings
    VALUES (1,'inch',31750,1016000,'dark')''');
  await db.close();
});
