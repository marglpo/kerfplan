import '../units/length.dart';
import 'optimization_bar.dart';
import 'unplaced_part.dart';

final class OptimizationResult {
  OptimizationResult({
    required Iterable<OptimizationBar> bars,
    required Iterable<UnplacedPart> unplaced,
    required this.requestedPartCount,
    required this.totalFinishedLength,
    required this.totalUsedStockLength,
    required this.kerfLoss,
    required this.trimLoss,
    required this.tailLeftovers,
    required this.reusableLeftovers,
    required this.scrap,
    required this.totalWaste,
    required this.barsToBuy,
  }) : bars = List.unmodifiable(bars),
       unplaced = List.unmodifiable(unplaced);

  final List<OptimizationBar> bars;
  final List<UnplacedPart> unplaced;
  final int requestedPartCount;
  int get placedPartCount => requestedPartCount - unplacedPartCount;
  int get unplacedPartCount => unplaced.length;
  int get barsUsed => bars.length;

  /// Null for Fixed mode; zero for a Buy job with no placements.
  final int? barsToBuy;
  final Length totalFinishedLength;
  final Length totalUsedStockLength;
  final Length kerfLoss;
  final Length trimLoss;
  final Length tailLeftovers;
  final Length reusableLeftovers;
  final Length scrap;
  final Length totalWaste;

  /// Only a derived dimensionless percentage uses floating point.
  double get wastePercent => totalUsedStockLength.ticks == 0
      ? 0.0
      : (totalWaste.ticks / totalUsedStockLength.ticks) * 100;
}
