import 'package:drift/drift.dart';

/// At most one settings row can exist, with the stable key [singletonId].
/// Initialized on demand from the domain preferences defaults.
class AppSettings extends Table {
  static const int singletonId = 1;

  IntColumn get id => integer()();
  TextColumn get defaultDisplayUnit => text()();
  IntColumn get defaultKerfTicks => integer()();
  IntColumn get defaultReusableTicks => integer()();
  TextColumn get themeMode => text()();
  TextColumn get localeTag => text().nullable()();
  TextColumn get measurementSystem => text().nullable()();
  BoolColumn get onboardingCompleted =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['CHECK (id = 1)'];
}
