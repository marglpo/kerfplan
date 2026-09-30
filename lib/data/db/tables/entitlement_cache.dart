import 'package:drift/drift.dart';

class EntitlementCache extends Table {
  TextColumn get productId => text()();
  BoolColumn get owned => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastVerifiedAt => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {productId};
}
