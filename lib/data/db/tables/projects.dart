import 'package:drift/drift.dart';

class Projects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get material => text().nullable()();
  TextColumn get note => text().nullable()();

  /// Supported product modes: fixed, buy.
  TextColumn get inventoryMode => text()();

  /// Supported units: mm, cm, m, inch, ftIn.
  TextColumn get displayUnit => text()();
  IntColumn get kerfTicks => integer()();
  IntColumn get endTrimTicks => integer()();
  IntColumn get minReusableTicks => integer()();
  IntColumn get buyStockLengthTicks => integer().nullable()();
  IntColumn get revision => integer().withDefault(const Constant(0))();
  TextColumn get lastRunId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
