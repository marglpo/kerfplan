import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/stock_input.dart';
import '../../domain/models/stock_item.dart';
import '../../domain/repositories/stock_repository.dart';
import '../../domain/units/length.dart';
import '../db/app_database.dart';
import 'project_mutation.dart';

final class DriftStockRepository implements StockRepository {
  DriftStockRepository(this._db, {DateTime Function()? now})
    : _now = now ?? DateTime.now;
  final AppDatabase _db;
  final DateTime Function() _now;
  final Uuid _uuid = const Uuid();

  StockItem _map(StockLine row) => StockItem(
    id: row.id,
    projectId: row.projectId,
    length: Length.fromTicks(row.lengthTicks),
    quantity: row.quantity,
    label: row.label,
    sortOrder: row.sortOrder,
    createdAt: row.createdAt.toUtc(),
    updatedAt: row.updatedAt.toUtc(),
  );

  SimpleSelectStatement<$StockLinesTable, StockLine> _byId(String id) =>
      _db.select(_db.stockLines)..where((row) => row.id.equals(id));

  Future<StockLine> _require(String id) async =>
      await _byId(id).getSingleOrNull() ?? (throw StockNotFoundException(id));

  SimpleSelectStatement<$StockLinesTable, StockLine> _forProject(
    String projectId,
  ) => _db.select(_db.stockLines)
    ..where((row) => row.projectId.equals(projectId))
    ..orderBy([
      (row) => OrderingTerm.asc(row.sortOrder),
      (row) => OrderingTerm.asc(row.createdAt),
      (row) => OrderingTerm.asc(row.id),
    ]);

  @override
  Stream<List<StockItem>> watchStockLines(String projectId) =>
      _forProject(projectId)
          .watch()
          .map((rows) => rows.map(_map).toList(growable: false));

  @override
  Future<List<StockItem>> getStockLines(String projectId) async =>
      (await _forProject(projectId).get()).map(_map).toList(growable: false);

  @override
  Future<StockItem?> getStockLine(String id) async {
    final row = await _byId(id).getSingleOrNull();
    return row == null ? null : _map(row);
  }

  Future<int> _appendOrder(String projectId) async {
    final last =
        await (_db.select(_db.stockLines)
              ..where((row) => row.projectId.equals(projectId))
              ..orderBy([(row) => OrderingTerm.desc(row.sortOrder)])
              ..limit(1))
            .getSingleOrNull();
    if (last == null) return 0;
    if (last.sortOrder == 0x7FFFFFFFFFFFFFFF) {
      throw StateError('Stock order overflow');
    }
    return last.sortOrder + 1;
  }

  Future<StockItem> _insert(String projectId, StockInput input) async {
    final id = _uuid.v4();
    final now = databaseTimestamp(_now());
    final order = await _appendOrder(projectId);
    await _db
        .into(_db.stockLines)
        .insert(
          StockLinesCompanion.insert(
            id: id,
            projectId: projectId,
            lengthTicks: input.length.ticks,
            quantity: input.quantity,
            label: Value(input.label),
            sortOrder: Value(order),
            createdAt: now,
            updatedAt: now,
          ),
        );
    return _map(await _require(id));
  }

  @override
  Future<StockItem> createStockLine(String projectId, StockInput input) =>
      _db.transaction(() async {
        final project = await requireProject(_db, projectId);
        final stock = await _insert(projectId, input);
        await touchProject(_db, project, _now());
        return stock;
      });

  @override
  Future<void> addStockBatch(String projectId, List<StockInput> items) async {
    final inputs = List<StockInput>.of(items);
    if (inputs.isEmpty) return;
    await _db.transaction(() async {
      final project = await requireProject(_db, projectId);
      final now = databaseTimestamp(_now());
      final firstOrder = await _appendOrder(projectId);
      if (inputs.length - 1 > 0x7FFFFFFFFFFFFFFF - firstOrder) {
        throw StateError('Stock order overflow');
      }
      await _db.batch((batch) {
        batch.insertAll(_db.stockLines, [
          for (var i = 0; i < inputs.length; i++)
            StockLinesCompanion.insert(
              id: _uuid.v4(),
              projectId: projectId,
              lengthTicks: inputs[i].length.ticks,
              quantity: inputs[i].quantity,
              label: Value(inputs[i].label),
              sortOrder: Value(firstOrder + i),
              createdAt: now,
              updatedAt: now,
            ),
        ]);
      });
      await touchProject(_db, project, now);
    });
  }

  @override
  Future<void> updateStockLine(
    String id,
    StockInput input,
  ) => _db.transaction(() async {
    final source = await _require(id);
    final project = await requireProject(_db, source.projectId);
    final changedInput =
        source.lengthTicks != input.length.ticks ||
        source.quantity != input.quantity;
    if (!changedInput && source.label == input.label) return;
    await (_db.update(_db.stockLines)..where((row) => row.id.equals(id))).write(
      StockLinesCompanion(
        lengthTicks: Value(input.length.ticks),
        quantity: Value(input.quantity),
        label: Value(input.label),
        updatedAt: Value(nextDatabaseTimestamp(_now(), source.updatedAt)),
      ),
    );
    await touchProject(_db, project, _now(), affectsOptimization: changedInput);
  });

  @override
  Future<StockItem> duplicateStockLine(String id) => _db.transaction(() async {
    final source = _map(await _require(id));
    final project = await requireProject(_db, source.projectId);
    final copy = await _insert(
      source.projectId,
      StockInput(
        length: source.length,
        quantity: source.quantity,
        label: source.label,
      ),
    );
    await touchProject(_db, project, _now());
    return copy;
  });

  @override
  Future<void> deleteStockLine(String id) => _db.transaction(() async {
    final source = await _require(id);
    final project = await requireProject(_db, source.projectId);
    await (_db.delete(_db.stockLines)..where((row) => row.id.equals(id))).go();
    await touchProject(_db, project, _now());
  });
}
