import 'package:flutter/material.dart';

import '../../domain/optimizer/unplaced_part.dart';
import '../../domain/units/display_unit.dart';
import '../../l10n/app_localizations.dart';
import '../shared/inputs/length_input.dart';
import '../shared/formatting/unplaced_grouping.dart';

export '../shared/formatting/unplaced_grouping.dart';

class UnplacedSection extends StatelessWidget {
  const UnplacedSection({super.key, required this.parts, required this.unit});
  final List<UnplacedPart> parts;
  final DisplayUnit unit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.unplacedCount(parts.length),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            for (final group in groupUnplaced(parts))
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (group.part.name != null)
                      Text(
                        group.part.name!,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    Text(
                      l10n.lengthQuantity(
                        displayLength(l10n, group.part.length, unit),
                        group.quantity,
                      ),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      group.part.reason == UnplacedReason.tooLong
                          ? l10n.tooLongResultReason
                          : l10n.inventoryExhaustedResultReason,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
