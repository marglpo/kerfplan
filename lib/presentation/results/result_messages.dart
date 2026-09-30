import '../../app/optimization_coordinator.dart';
import '../../domain/optimizer/optimization_failure.dart';
import '../../domain/repositories/project_repository.dart';
import '../../l10n/app_localizations.dart';

String requirementMessage(
  AppLocalizations l10n,
  CalculationRequirement requirement,
) => switch (requirement) {
  CalculationRequirement.stock => l10n.addStockToContinue,
  CalculationRequirement.buyLength => l10n.buyStockLengthMissing,
  CalculationRequirement.parts => l10n.calculateDisabledHint,
};

String resultFailureMessage(AppLocalizations l10n, Object error) {
  if (error is ProjectNotFoundException) return l10n.projectNotFound;
  if (error is MissingCalculationInput) {
    return requirementMessage(l10n, error.requirement);
  }
  if (error is OptimizationValidationException) {
    return switch (error.reason) {
      OptimizationFailure.noUsableBuyStock => l10n.stockTooShortAfterTrim,
      OptimizationFailure.missingBuyStock => l10n.validBuyStockRequired,
      OptimizationFailure.noFixedStock => l10n.addStockToContinue,
      _ => l10n.resultValidationError,
    };
  }
  return l10n.resultLoadError;
}
