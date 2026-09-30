import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/domain/models/cut_project.dart';
import 'package:kerfplan/domain/models/part_fit.dart';
import 'package:kerfplan/domain/models/inventory_mode.dart';
import 'package:kerfplan/domain/models/stock_item.dart';
import 'package:kerfplan/domain/units/display_unit.dart';
import 'package:kerfplan/domain/units/length.dart';

void main() {
  for (final sample in [
    (InventoryMode.fixed, ['2440'], null, '0', '2500', true),
    (InventoryMode.fixed, ['2440'], null, '0', '2440', false),
    (InventoryMode.fixed, ['1000'], null, '10', '981', true),
    (InventoryMode.fixed, ['1000'], null, '10', '980', false),
    (InventoryMode.fixed, ['3000', '6000'], null, '0', '5000', false),
    (InventoryMode.fixed, <String>[], '1000', '0', '5000', false),
    (InventoryMode.buy, ['10000'], '6000', '0', '6500', true),
    (InventoryMode.buy, ['1000'], null, '0', '6500', false),
    (InventoryMode.buy, <String>[], '1000', '10', '981', true),
    (InventoryMode.fixed, ['10'], null, '100', '1', true),
  ]) {
    test('fit warning $sample', () {
      final now = DateTime.utc(2026);
      final project = CutProject(
        id: 'p',
        name: 'Frame',
        material: null,
        note: null,
        inventoryMode: sample.$1,
        displayUnit: DisplayUnit.mm,
        kerf: Length.fromMillimeters('3'),
        endTrim: Length.fromMillimeters(sample.$4),
        minReusable: Length.fromTicks(0),
        buyStockLength: sample.$3 == null
            ? null
            : Length.fromMillimeters(sample.$3!),
        revision: 0,
        lastRunId: null,
        createdAt: now,
        updatedAt: now,
      );
      final stock = sample.$2.map(
        (mm) => StockItem(
          id: mm,
          projectId: 'p',
          length: Length.fromMillimeters(mm),
          quantity: 1,
          sortOrder: 0,
          createdAt: now,
          updatedAt: now,
        ),
      );
      final usable = PartFit.largestUsable(project, stock);
      expect(
        PartFit.tooLong(Length.fromMillimeters(sample.$5), usable),
        sample.$6,
      );
    });
  }
}
