import 'package:flutter/material.dart';

import '../../../domain/units/decimal_length.dart';
import '../../../domain/units/display_unit.dart';
import '../../../domain/units/length.dart';
import '../../../domain/units/imperial_length.dart';
import '../../../l10n/app_localizations.dart';
import '../formatting/length_format.dart';

export '../formatting/length_format.dart';

class LengthEditingController extends TextEditingController {
  LengthEditingController({
    required DisplayUnit unit,
    Length? initialLength,
    this.allowZero = false,
  }) : _unit = unit,
       _initialLength = initialLength,
       super(
         text: initialLength == null
             ? ''
             : DecimalLength.format(initialLength, unit).text,
       ) {
    _initialText = text;
    final components = ImperialLength.components(
      initialLength ?? Length.fromTicks(0),
      feetAndInches: unit == DisplayUnit.ftIn,
    );
    feet = TextEditingController(text: '${components.feet}');
    inches = TextEditingController(text: '${components.inches}');
    _sixteenths = components.sixteenths;
    _feetText = feet.text;
    _inchesText = inches.text;
    feet.addListener(_componentChanged);
    inches.addListener(_componentChanged);
  }
  DisplayUnit _unit;
  Length? _initialLength;
  DisplayUnit get unit => _unit;
  Length? get initialLength => _initialLength;
  final bool allowZero;
  late String _initialText;
  late final TextEditingController feet;
  late final TextEditingController inches;
  late int _sixteenths;
  late String _feetText;
  late String _inchesText;
  bool _imperialEdited = false;
  bool _rebasing = false;

  /// Rebase the controls from their exact current value, never from rounded
  /// display text. Invalid pending input throws before any state is changed.
  void changeUnit(DisplayUnit unit) {
    if (unit == _unit) return;
    final exact = length;
    final components = ImperialLength.components(
      exact,
      feetAndInches: unit == DisplayUnit.ftIn,
    );
    _rebasing = true;
    _unit = unit;
    _initialLength = exact;
    _initialText = DecimalLength.format(exact, unit).text;
    _imperialEdited = false;
    _sixteenths = components.sixteenths;
    _feetText = '${components.feet}';
    _inchesText = '${components.inches}';
    feet.text = _feetText;
    inches.text = _inchesText;
    text = _initialText;
    _rebasing = false;
    notifyListeners();
  }

  /// Enter an exact preset without converting through formatted display text.
  void setExactLength(Length exact) {
    final components = ImperialLength.components(
      exact,
      feetAndInches: _unit == DisplayUnit.ftIn,
    );
    _rebasing = true;
    _initialLength = exact;
    _initialText = DecimalLength.format(exact, _unit).text;
    _imperialEdited = false;
    _sixteenths = components.sixteenths;
    _feetText = '${components.feet}';
    _inchesText = '${components.inches}';
    feet.text = _feetText;
    inches.text = _inchesText;
    text = _initialText;
    _rebasing = false;
    notifyListeners();
  }

  bool get isImperial => unit == DisplayUnit.inch || unit == DisplayUnit.ftIn;

  /// Start a new entry without retaining an exact value or imperial components.
  void resetEntry() {
    _rebasing = true;
    _initialLength = null;
    _initialText = '';
    _feetText = '';
    _inchesText = '';
    _sixteenths = 0;
    _imperialEdited = false;
    feet.clear();
    inches.clear();
    clear();
    _rebasing = false;
    notifyListeners();
  }

  int get sixteenths => _sixteenths;
  set sixteenths(int value) {
    RangeError.checkValueInInterval(value, 0, 15);
    // Selecting even the currently displayed fraction is an explicit edit:
    // e.g. accepting displayed 1/8 inch must replace an approximate 3 mm value.
    _sixteenths = value;
    _imperialChanged();
  }

  void _imperialChanged() {
    _imperialEdited = true;
    notifyListeners();
  }

  void _componentChanged() {
    if (_rebasing) return;
    if (_feetText == feet.text && _inchesText == inches.text) return;
    _feetText = feet.text;
    _inchesText = inches.text;
    _imperialChanged();
  }

  @override
  void dispose() {
    feet.dispose();
    inches.dispose();
    super.dispose();
  }

  Length get length {
    if (isImperial &&
        (_imperialEdited || (initialLength == null && text.isEmpty))) {
      return ImperialLength.parse(
        feet: unit == DisplayUnit.ftIn ? feet.text : '0',
        inches: inches.text,
        sixteenths: sixteenths,
        feetAndInches: unit == DisplayUnit.ftIn,
        allowZero: allowZero,
      );
    }
    return initialLength != null && text == _initialText
        ? initialLength!
        : DecimalLength.parse(text, unit, allowZero: allowZero);
  }

  bool get showsApproximation =>
      initialLength != null &&
      !_imperialEdited &&
      text == _initialText &&
      (isImperial
          ? ImperialLength.components(
              initialLength!,
              feetAndInches: unit == DisplayUnit.ftIn,
            ).approximate
          : DecimalLength.format(initialLength!, unit).approximate);
}

class LengthInputField extends StatelessWidget {
  const LengthInputField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.label,
    this.focusNode,
  });
  final LengthEditingController controller;
  final bool enabled;
  final String? label;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (controller.isImperial) {
      return _ImperialInput(
        controller: controller,
        enabled: enabled,
        label: label,
        focusNode: focusNode,
      );
    }
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) => TextFormField(
        key: const ValueKey('length-input'),
        focusNode: focusNode,
        controller: controller,
        enabled: enabled,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: label ?? l10n.stockLength,
          hintText: switch (controller.unit) {
            DisplayUnit.mm => l10n.stockLengthHint,
            DisplayUnit.cm => l10n.stockLengthCmHint,
            DisplayUnit.m => l10n.stockLengthMHint,
            DisplayUnit.inch || DisplayUnit.ftIn => null,
          },
          suffixText: unitLabel(l10n, controller.unit),
          errorMaxLines: 4,
        ),
        validator: (_) {
          try {
            if (controller.length.ticks == 0 && !controller.allowZero) {
              return l10n.stockLengthInvalid;
            }
            return null;
          } on LengthInputException catch (error) {
            return switch (error.error) {
              LengthInputError.required => l10n.stockLengthRequired,
              LengthInputError.invalid =>
                controller.allowZero
                    ? l10n.nonnegativeLengthInvalid
                    : l10n.stockLengthInvalid,
              LengthInputError.precision => l10n.stockLengthPrecision,
              LengthInputError.outOfRange => l10n.stockLengthTooLarge,
            };
          }
        },
      ),
    );
  }
}

class _ImperialInput extends StatelessWidget {
  const _ImperialInput({
    required this.controller,
    required this.enabled,
    this.label,
    this.focusNode,
  });
  final LengthEditingController controller;
  final bool enabled;
  final String? label;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => FormField<int>(
        initialValue: 0,
        validator: (_) {
          if (controller.unit == DisplayUnit.ftIn &&
              (int.tryParse(controller.inches.text) ?? 0) > 11) {
            return l10n.inchesRange;
          }
          try {
            if (controller.length.ticks == 0 && !controller.allowZero) {
              return l10n.imperialLengthInvalid;
            }
            return null;
          } on LengthInputException catch (error) {
            return error.error == LengthInputError.outOfRange
                ? l10n.stockLengthTooLarge
                : controller.allowZero
                ? l10n.nonnegativeImperialInvalid
                : l10n.imperialLengthInvalid;
          }
        },
        builder: (field) {
          Widget component(
            TextEditingController value,
            String label,
            String key,
          ) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TextField(
              key: ValueKey(key),
              focusNode:
                  (controller.unit == DisplayUnit.ftIn
                      ? key == 'length-feet'
                      : key == 'length-inches')
                  ? focusNode
                  : null,
              controller: value,
              enabled: enabled,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: label),
              onChanged: (_) => field.didChange((field.value ?? 0) + 1),
            ),
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                label ?? l10n.stockLength,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              if (controller.unit == DisplayUnit.ftIn)
                component(controller.feet, l10n.feet, 'length-feet'),
              component(
                controller.inches,
                controller.unit == DisplayUnit.ftIn
                    ? l10n.inches
                    : l10n.wholeInches,
                'length-inches',
              ),
              DropdownButtonFormField<int>(
                key: ValueKey('length-fraction-${controller.sixteenths}'),
                initialValue: controller.sixteenths,
                isExpanded: true,
                itemHeight: 48,
                decoration: InputDecoration(labelText: l10n.fraction),
                items: [
                  for (var i = 0; i < 16; i++)
                    DropdownMenuItem(
                      value: i,
                      child: Text(ImperialLength.fraction(i)),
                    ),
                ],
                onChanged: enabled
                    ? (value) {
                        if (value == null) return;
                        controller.sixteenths = value;
                        field.didChange((field.value ?? 0) + 1);
                      }
                    : null,
              ),
              if (controller.showsApproximation)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    l10n.exactStoredLengthHelper(
                      DecimalLength.format(
                        controller.initialLength!,
                        DisplayUnit.mm,
                      ).text,
                    ),
                  ),
                ),
              if (field.errorText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    field.errorText!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
