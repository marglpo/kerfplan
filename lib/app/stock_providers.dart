import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/database_provider.dart';
import '../data/repositories/drift_stock_repository.dart';
import '../domain/models/stock_item.dart';
import '../domain/repositories/stock_repository.dart';

final stockRepositoryProvider = Provider<StockRepository>(
  (ref) => DriftStockRepository(ref.watch(appDatabaseProvider)),
);

final stockLinesProvider = StreamProvider.autoDispose
    .family<List<StockItem>, String>(
      (ref, projectId) =>
          ref.watch(stockRepositoryProvider).watchStockLines(projectId),
      retry: (count, error) => null,
    );
