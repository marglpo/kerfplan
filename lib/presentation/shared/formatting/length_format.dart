import '../../../domain/units/decimal_length.dart';
import '../../../domain/units/display_unit.dart';
import '../../../domain/units/imperial_length.dart';
import '../../../domain/units/length.dart';
import '../../../l10n/app_localizations.dart';

String unitLabel(AppLocalizations l10n, DisplayUnit unit) => switch (unit) {
  DisplayUnit.mm => l10n.unitMm,
  DisplayUnit.cm => l10n.unitCm,
  DisplayUnit.m => l10n.unitM,
  DisplayUnit.inch => l10n.unitInch,
  DisplayUnit.ftIn => l10n.unitFtIn,
};

String displayLength(AppLocalizations l10n, Length length, DisplayUnit unit) {
  if (unit == DisplayUnit.inch || unit == DisplayUnit.ftIn) {
    final result = ImperialLength.format(
      length,
      feetAndInches: unit == DisplayUnit.ftIn,
    );
    return result.approximate
        ? l10n.approximateLength(result.text)
        : result.text;
  }
  final formatted = DecimalLength.format(length, unit);
  // Presentation only: exact ticks and editable values are never round-tripped
  // through this localized decimal string.
  final decimal = l10n.localeName == 'en'
      ? formatted.text
      : formatted.text.replaceAll('.', ',');
  final value = l10n.lengthWithUnit(decimal, unitLabel(l10n, unit));
  return formatted.approximate ? l10n.approximateLength(value) : value;
}
