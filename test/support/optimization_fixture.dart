import 'package:drift/native.dart';
import 'package:kerfplan/app/optimization_coordinator.dart';
import 'package:kerfplan/data/db/app_database.dart';
import 'package:kerfplan/data/repositories/drift_project_repository.dart';
import 'package:kerfplan/data/repositories/drift_stock_repository.dart';
import 'package:kerfplan/data/repositories/drift_part_repository.dart';
import 'package:kerfplan/domain/models/project_metadata.dart';
import 'package:kerfplan/domain/models/stock_input.dart';
import 'package:kerfplan/domain/models/part_input.dart';
import 'package:kerfplan/domain/models/part_item.dart';
import 'package:kerfplan/domain/units/length.dart';

class OptimizationFixture {
  final db = AppDatabase.withExecutor(NativeDatabase.memory());
  late final projects = DriftProjectRepository(db);
  late final stocks = DriftStockRepository(db);
  late final parts = DriftPartRepository(db);
  late final coordinator = OptimizationCoordinator(db, projects, stocks, parts);
  late String id;
  Future<void> initialize() async {
    id = (await projects.createProject(ProjectMetadata(name: 'Workshop'))).id;
  }

  Future<void> stock(int mm, {int quantity = 1}) async {
    await stocks.createStockLine(
      id,
      StockInput(length: Length.fromTicks(mm * 10000), quantity: quantity),
    );
  }

  Future<PartItem> part(int mm, {int quantity = 1, String? name}) =>
      parts.createPart(
        id,
        PartInput(
          length: Length.fromTicks(mm * 10000),
          quantity: quantity,
          name: name,
        ),
      );
  Future<void> close() => db.close();
}
