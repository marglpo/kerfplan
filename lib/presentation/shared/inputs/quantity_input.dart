import 'package:flutter/material.dart';

import '../../../domain/models/quantity.dart';
import '../../../l10n/app_localizations.dart';

class QuantityInput extends StatelessWidget {
  const QuantityInput({
    super.key,
    required this.controller,
    this.enabled = true,
  });
  final TextEditingController controller;
  final bool enabled;

  void _step(int change) {
    final current = int.tryParse(controller.text.trim());
    final next = current == null || current < 1
        ? 1
        : current > Quantity.maximum
        ? Quantity.maximum
        : (current + change).clamp(1, Quantity.maximum);
    controller.value = TextEditingValue(
      text: '$next',
      selection: TextSelection.collapsed(offset: '$next'.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final current = int.tryParse(value.text.trim());
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              tooltip: l10n.decreaseQuantity,
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              onPressed: enabled && current != 1 ? () => _step(-1) : null,
              icon: const Icon(Icons.remove),
            ),
            Expanded(
              child: TextFormField(
                key: const ValueKey('quantity-input'),
                controller: controller,
                enabled: enabled,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: l10n.quantity,
                  hintText: l10n.quantityHint,
                  errorMaxLines: 4,
                ),
                validator: (text) {
                  try {
                    Quantity.parse(text ?? '');
                    return null;
                  } on QuantityException catch (error) {
                    return switch (error.error) {
                      QuantityError.required => l10n.quantityRequired,
                      QuantityError.tooLarge => l10n.quantityTooLarge,
                      _ => l10n.quantityInvalid,
                    };
                  }
                },
              ),
            ),
            IconButton(
              tooltip: l10n.increaseQuantity,
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              onPressed: enabled && current != Quantity.maximum
                  ? () => _step(1)
                  : null,
              icon: const Icon(Icons.add),
            ),
          ],
        );
      },
    );
  }
}
