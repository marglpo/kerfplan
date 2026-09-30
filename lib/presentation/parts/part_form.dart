import 'package:flutter/material.dart';

import '../../domain/models/part_input.dart';
import '../../domain/models/part_item.dart';
import '../../domain/models/quantity.dart';
import '../../domain/units/length.dart';
import '../../domain/units/decimal_length.dart';
import '../../domain/models/part_fit.dart';
import '../../domain/units/display_unit.dart';
import '../../l10n/app_localizations.dart';
import '../shared/inputs/length_input.dart';
import '../shared/inputs/quantity_input.dart';
import '../shared/widgets/save_form.dart';

class PartForm extends StatefulWidget {
  const PartForm({
    super.key,
    required this.unit,
    this.initialPart,
    this.usableStock,
    required this.onSubmit,
    this.onSubmitAnother,
  });
  final DisplayUnit unit;
  final PartItem? initialPart;
  final Length? usableStock;
  final Future<void> Function(PartInput) onSubmit;
  final Future<void> Function(PartInput)? onSubmitAnother;
  @override
  State<PartForm> createState() => _PartFormState();
}

class _PartFormState extends State<PartForm> {
  late final LengthEditingController _length;
  final _lengthFocus = FocusNode();
  late final TextEditingController _quantity;
  late final TextEditingController _name;
  @override
  void initState() {
    super.initState();
    _length = LengthEditingController(
      unit: widget.unit,
      initialLength: widget.initialPart?.length,
    );
    _quantity = TextEditingController(
      text: '${widget.initialPart?.quantity ?? 1}',
    );
    _name = TextEditingController(text: widget.initialPart?.name);
  }

  @override
  void dispose() {
    _lengthFocus.dispose();
    _length.dispose();
    _quantity.dispose();
    _name.dispose();
    super.dispose();
  }

  PartInput _input() => PartInput(
    length: _length.length,
    quantity: Quantity.parse(_quantity.text),
    name: _name.text,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SaveForm(
      submitLabel: widget.initialPart == null ? l10n.addPart : l10n.save,
      errorMessage: l10n.partSaveError,
      onSubmit: () => widget.onSubmit(_input()),
      submitAnotherLabel: l10n.saveAndAddAnother,
      onSubmitAnother:
          widget.initialPart == null && widget.onSubmitAnother != null
          ? () async {
              await widget.onSubmitAnother!(_input());
              if (!mounted) return;
              _length.resetEntry();
              _name.clear();
              _quantity.text = '1';
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) _lengthFocus.requestFocus();
              });
            }
          : null,
      fields: (enabled) => [
        TextFormField(
          key: const ValueKey('part-name'),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _lengthFocus.requestFocus(),
          controller: _name,
          enabled: enabled,
          decoration: InputDecoration(
            labelText: l10n.partNameOptional,
            hintText: l10n.partNameHint,
            errorMaxLines: 3,
          ),
          textCapitalization: TextCapitalization.sentences,
          validator: (value) => PartInput.validateName(value) == null
              ? null
              : l10n.partNameTooLong,
        ),
        const SizedBox(height: 24),
        LengthInputField(
          controller: _length,
          enabled: enabled,
          focusNode: _lengthFocus,
        ),
        ListenableBuilder(
          listenable: _length,
          builder: (context, _) {
            try {
              if (PartFit.tooLong(_length.length, widget.usableStock)) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Semantics(
                    liveRegion: true,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.warning_amber_rounded),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.partTooLongWarning(
                              displayLength(
                                l10n,
                                widget.usableStock!,
                                widget.unit,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            } on LengthInputException {
              // Invalid/incomplete entry is handled by the length field.
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 24),
        QuantityInput(controller: _quantity, enabled: enabled),
      ],
    );
  }
}
