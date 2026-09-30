import 'package:flutter/material.dart';

import '../../domain/models/stock_input.dart';
import '../../domain/models/stock_item.dart';
import '../../domain/units/display_unit.dart';
import '../../l10n/app_localizations.dart';
import '../shared/inputs/length_input.dart';
import '../shared/inputs/quantity_input.dart';
import '../shared/widgets/save_form.dart';

class StockForm extends StatefulWidget {
  const StockForm({
    super.key,
    required this.unit,
    this.initialStock,
    required this.onSubmit,
    this.onSubmitAnother,
  });
  final DisplayUnit unit;
  final StockItem? initialStock;
  final Future<void> Function(StockInput) onSubmit;
  final Future<void> Function(StockInput)? onSubmitAnother;
  @override
  State<StockForm> createState() => _StockFormState();
}

class _StockFormState extends State<StockForm> {
  late final LengthEditingController _length;
  final _lengthFocus = FocusNode();
  late final TextEditingController _quantity;
  late final TextEditingController _label;
  @override
  void initState() {
    super.initState();
    _length = LengthEditingController(
      unit: widget.unit,
      initialLength: widget.initialStock?.length,
    );
    _quantity = TextEditingController(
      text: '${widget.initialStock?.quantity ?? 1}',
    );
    _label = TextEditingController(text: widget.initialStock?.label);
  }

  @override
  void dispose() {
    _lengthFocus.dispose();
    _length.dispose();
    _quantity.dispose();
    _label.dispose();
    super.dispose();
  }

  StockInput _input() => StockInput(
    length: _length.length,
    quantity: StockInput.parseQuantity(_quantity.text),
    label: _label.text,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SaveForm(
      submitLabel: l10n.saveStock,
      errorMessage: l10n.stockSaveError,
      onSubmit: () => widget.onSubmit(_input()),
      submitAnotherLabel: l10n.saveAndAddAnother,
      onSubmitAnother:
          widget.initialStock == null && widget.onSubmitAnother != null
          ? () async {
              await widget.onSubmitAnother!(_input());
              if (!mounted) return;
              _length.resetEntry();
              _label.clear();
              _quantity.text = '1';
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) _lengthFocus.requestFocus();
              });
            }
          : null,
      fields: (enabled) => [
        LengthInputField(
          controller: _length,
          enabled: enabled,
          focusNode: _lengthFocus,
        ),
        const SizedBox(height: 24),
        QuantityInput(controller: _quantity, enabled: enabled),
        const SizedBox(height: 24),
        TextFormField(
          key: const ValueKey('stock-label'),
          controller: _label,
          enabled: enabled,
          decoration: InputDecoration(
            labelText: l10n.labelOptional,
            hintText: l10n.stockLabelHint,
            errorMaxLines: 3,
          ),
          textCapitalization: TextCapitalization.sentences,
          validator: (value) => StockInput.validateLabel(value) == null
              ? null
              : l10n.stockLabelTooLong,
        ),
      ],
    );
  }
}
