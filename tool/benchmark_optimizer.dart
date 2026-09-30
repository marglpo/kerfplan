import 'dart:io';

import 'package:kerfplan/domain/models/inventory_mode.dart';
import 'package:kerfplan/domain/optimizer/cut_optimizer.dart';
import 'package:kerfplan/domain/optimizer/optimization_input.dart';
import 'package:kerfplan/domain/units/length.dart';

/// Run with `dart run tool/benchmark_optimizer.dart`; excludes fixture creation.
/// Host timings are a regression aid, not a substitute for Android profiling.
void main() {
  final input = OptimizationInput(
    mode: InventoryMode.fixed,
    fixedStock: [
      OptimizationStock(
        sourceStockId: 'stock',
        length: Length.fromTicks(60000000),
        quantity: 100,
        stableOrder: 0,
      ),
    ],
    parts: [
      OptimizationPartGroup(
        sourcePartId: 'part',
        length: Length.fromTicks(18000000),
        quantity: 300,
        stableOrder: 0,
      ),
    ],
    kerf: Length.fromTicks(30000),
    endTrim: Length.fromTicks(0),
    minReusable: Length.fromTicks(1000000),
  );
  const optimizer = FfdCutOptimizer();
  int measure() {
    final watch = Stopwatch()..start();
    final result = optimizer.optimize(input);
    watch.stop();
    if (result.placedPartCount != 300 || result.barsUsed != 100) {
      throw StateError('Unexpected benchmark result');
    }
    return watch.elapsedMicroseconds;
  }

  final cold = measure();
  for (var i = 0; i < 10; i++) {
    measure();
  }
  final samples = [for (var i = 0; i < 50; i++) measure()]..sort();
  stdout.writeln('300 parts / 100 fixed bars; Dart VM host, optimizer only');
  stdout.writeln('First run: $cold us');
  stdout.writeln(
    '50 warm runs: median ${samples[25]} us; min ${samples.first} us; max ${samples.last} us',
  );
}
