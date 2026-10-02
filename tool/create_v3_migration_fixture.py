"""Preserve a populated schema-v3 snapshot for the v4 migration test.

The v2 fixture contains real project, stock, part, settings and entitlement rows.
Schema v3 adds only locale_tag; this script captures that historical shape.
"""
from pathlib import Path
import shutil
import sqlite3

root = Path(__file__).resolve().parents[1] / 'test' / 'fixtures'
source = root / 'schema_v2.sqlite'
target = root / 'schema_v3.sqlite'
if target.exists():
    raise SystemExit('Preserve the original v3 fixture')
shutil.copyfile(source, target)
with sqlite3.connect(target) as db:
    assert db.execute('PRAGMA user_version').fetchone()[0] == 2
    db.execute('ALTER TABLE app_settings ADD COLUMN locale_tag TEXT')
    db.execute("UPDATE app_settings SET locale_tag = 'uk' WHERE id = 1")
    db.execute('PRAGMA user_version = 3')
