import '../models/inventory_mode.dart';
import '../units/length.dart';
import 'optimization_bar.dart';
import 'optimization_failure.dart';
import 'optimization_input.dart';
import 'optimization_result.dart';
import 'placed_part.dart';
import 'unplaced_part.dart';

/// First Fit Decreasing is deterministic and fast but does not guarantee the
/// globally minimum waste solution. No local improvement or best-fit step.
final class FfdCutOptimizer {
  const FfdCutOptimizer();

  OptimizationResult optimize(OptimizationInput input) {
    final requested = _validate(input);
    final parts = [
      for (final group in input.parts)
        for (var i = 0; i < group.quantity; i++) _PartInstance(group, i),
    ]..sort(_compareParts);
    final stock = [
      for (final row in input.fixedStock)
        _StockSupply(row, _usable(row.length.ticks, input.endTrim.ticks)),
    ];
    final buyUsable = input.mode == InventoryMode.buy
        ? _usable(input.buyStockLength!.ticks, input.endTrim.ticks)
        : 0;
    final maximumUsable = input.mode == InventoryMode.buy
        ? buyUsable
        : stock.fold<int>(
            0,
            (largest, row) => row.usable > largest ? row.usable : largest,
          );
    final opened = <_OpenBar>[];
    final unplaced = <UnplacedPart>[];
    for (final part in parts) {
      _OpenBar? target;
      // Opening order is significant: choose FIRST fit, never the tightest fit.
      for (final bar in opened) {
        if (bar.fits(part, input.kerf.ticks)) {
          target = bar;
          break;
        }
      }
      if (target == null) {
        if (input.mode == InventoryMode.buy) {
          if (part.group.length.ticks <= buyUsable) {
            target = _OpenBar(input.buyStockLength!, buyUsable);
          }
        } else {
          _StockSupply? selected;
          for (final candidate in stock) {
            if (candidate.nextInstance >= candidate.row.quantity ||
                candidate.usable < part.group.length.ticks) {
              continue;
            }
            if (selected == null || _compareStock(candidate, selected) < 0) {
              selected = candidate;
            }
          }
          if (selected != null) {
            target = _OpenBar(
              selected.row.length,
              selected.usable,
              sourceId: selected.row.sourceStockId,
              instanceIndex: selected.nextInstance++,
            );
          }
        }
        if (target != null) opened.add(target);
      }
      if (target == null) {
        unplaced.add(
          UnplacedPart(
            sourcePartId: part.group.sourcePartId,
            name: part.group.name,
            instanceIndex: part.instanceIndex,
            sourceStableOrder: part.group.stableOrder,
            length: part.group.length,
            reason: part.group.length.ticks > maximumUsable
                ? UnplacedReason.tooLong
                : UnplacedReason.inventoryExhausted,
          ),
        );
      } else {
        target.add(part, input.kerf.ticks);
      }
    }
    return _result(input, requested, opened, unplaced);
  }
}

int _validate(OptimizationInput input) {
  var requested = 0;
  final partIds = <String>{};
  for (final part in input.parts) {
    if (part.length.ticks <= 0 ||
        part.quantity <= 0 ||
        part.stableOrder < 0 ||
        part.sourcePartId.trim().isEmpty ||
        !partIds.add(part.sourcePartId)) {
      throw OptimizationValidationException(
        OptimizationFailure.invalidPart,
        sourceId: part.sourcePartId,
      );
    }
    requested = _sum(requested, part.quantity);
  }
  final stockIds = <String>{};
  for (final stock in input.fixedStock) {
    if (stock.length.ticks <= 0 ||
        stock.quantity <= 0 ||
        stock.stableOrder < 0 ||
        stock.sourceStockId.trim().isEmpty ||
        !stockIds.add(stock.sourceStockId)) {
      throw OptimizationValidationException(
        OptimizationFailure.invalidStock,
        sourceId: stock.sourceStockId,
      );
    }
  }
  if (input.mode == InventoryMode.fixed) {
    if (input.fixedStock.isEmpty && requested > 0) {
      throw const OptimizationValidationException(
        OptimizationFailure.noFixedStock,
      );
    }
  } else {
    final buy = input.buyStockLength;
    if (buy == null) {
      throw const OptimizationValidationException(
        OptimizationFailure.missingBuyStock,
      );
    }
    if (_usable(buy.ticks, input.endTrim.ticks) == 0) {
      throw const OptimizationValidationException(
        OptimizationFailure.noUsableBuyStock,
      );
    }
  }
  return requested;
}

/// Saturation is for unusable INPUT stock only, never for a computed result tail.
int _usable(int stock, int trim) => trim > stock ~/ 2 ? 0 : stock - trim - trim;

/// The existing Length type bounds totals too. Reject rather than wrap on VM int.
int _sum(int left, int right) {
  if (right > Length.maxTicks - left) {
    throw const OptimizationValidationException(
      OptimizationFailure.arithmeticOverflow,
    );
  }
  return left + right;
}

int _compareParts(_PartInstance a, _PartInstance b) {
  var order = b.group.length.compareTo(a.group.length);
  if (order != 0) return order;
  order = a.group.stableOrder.compareTo(b.group.stableOrder);
  if (order != 0) return order;
  order = a.instanceIndex.compareTo(b.instanceIndex);
  return order != 0
      ? order
      : a.group.sourcePartId.compareTo(b.group.sourcePartId);
}

int _compareStock(_StockSupply a, _StockSupply b) {
  var order = a.usable.compareTo(b.usable);
  if (order != 0) return order;
  order = a.row.stableOrder.compareTo(b.row.stableOrder);
  if (order != 0) return order;
  order = a.nextInstance.compareTo(b.nextInstance);
  return order != 0
      ? order
      : a.row.sourceStockId.compareTo(b.row.sourceStockId);
}

final class _PartInstance {
  const _PartInstance(this.group, this.instanceIndex);
  final OptimizationPartGroup group;
  final int instanceIndex;
}

/// Equivalent to expanded physical stock, without allocating unused instances.
final class _StockSupply {
  _StockSupply(this.row, this.usable);
  final OptimizationStock row;
  final int usable;
  int nextInstance = 0;
}

final class _OpenBar {
  _OpenBar(this.stock, this.usable, {this.sourceId, this.instanceIndex});
  final Length stock;
  final int usable;
  final String? sourceId;
  final int? instanceIndex;
  final parts = <_PartInstance>[];
  int finished = 0;
  int kerfLoss = 0;
  int used = 0;

  bool fits(_PartInstance part, int kerf) {
    final available = usable - used;
    if (part.group.length.ticks > available) return false;
    return parts.isEmpty || kerf <= available - part.group.length.ticks;
  }

  void add(_PartInstance part, int kerf) {
    if (!fits(part, kerf)) {
      throw StateError('Optimizer placement exceeds capacity');
    }
    // fits proves each addition is <= usable, including at signed int limits.
    if (parts.isNotEmpty) {
      used += kerf;
      kerfLoss += kerf;
    }
    used += part.group.length.ticks;
    finished += part.group.length.ticks;
    parts.add(part);
  }

  OptimizationBar freeze(int index, OptimizationInput input) {
    final tail = usable - used;
    if (tail < 0) throw StateError('Optimizer produced a negative tail');
    return OptimizationBar(
      barIndex: index,
      sourceStockId: sourceId,
      physicalStockInstanceIndex: instanceIndex,
      stockLength: stock,
      usableLength: Length.fromTicks(usable),
      placedParts: [
        for (var i = 0; i < parts.length; i++)
          PlacedPart(
            sourcePartId: parts[i].group.sourcePartId,
            name: parts[i].group.name,
            instanceIndex: parts[i].instanceIndex,
            sourceStableOrder: parts[i].group.stableOrder,
            orderIndex: i,
            length: parts[i].group.length,
            kerfAfter: i == parts.length - 1 ? Length.fromTicks(0) : input.kerf,
          ),
      ],
      kerfLoss: Length.fromTicks(kerfLoss),
      trimLoss: Length.fromTicks(stock.ticks - usable),
      tailLeftover: Length.fromTicks(tail),
      isTailReusable: tail >= input.minReusable.ticks,
    );
  }
}

OptimizationResult _result(
  OptimizationInput input,
  int requested,
  List<_OpenBar> opened,
  List<UnplacedPart> unplaced,
) {
  final bars = <OptimizationBar>[];
  var finished = 0;
  var stock = 0;
  var kerf = 0;
  var trim = 0;
  var tails = 0;
  var reusable = 0;
  for (var i = 0; i < opened.length; i++) {
    final bar = opened[i].freeze(i, input);
    bars.add(bar);
    finished = _sum(finished, opened[i].finished);
    stock = _sum(stock, bar.stockLength.ticks);
    kerf = _sum(kerf, bar.kerfLoss.ticks);
    trim = _sum(trim, bar.trimLoss.ticks);
    tails = _sum(tails, bar.tailLeftover.ticks);
    if (bar.isTailReusable) reusable = _sum(reusable, bar.tailLeftover.ticks);
  }
  final waste = stock - finished;
  return OptimizationResult(
    bars: bars,
    unplaced: unplaced,
    requestedPartCount: requested,
    totalFinishedLength: Length.fromTicks(finished),
    totalUsedStockLength: Length.fromTicks(stock),
    kerfLoss: Length.fromTicks(kerf),
    trimLoss: Length.fromTicks(trim),
    tailLeftovers: Length.fromTicks(tails),
    reusableLeftovers: Length.fromTicks(reusable),
    totalWaste: Length.fromTicks(waste),
    scrap: Length.fromTicks(waste - reusable),
    barsToBuy: input.mode == InventoryMode.buy ? bars.length : null,
  );
}
