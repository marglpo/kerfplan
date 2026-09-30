import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/domain/models/part_input.dart';
import 'package:kerfplan/domain/models/part_item.dart';
import 'package:kerfplan/domain/models/quantity.dart';
import 'package:kerfplan/domain/units/length.dart';

void main() {
  PartInput input({int ticks = 18000000, int quantity = 6, String? name}) =>
      PartInput(
        length: Length.fromTicks(ticks),
        quantity: quantity,
        name: name,
      );
  test('optional name trims to null or a bounded Unicode name', () {
    expect(input(name: '   ').name, isNull);
    expect(input(name: ' Upright ').name, 'Upright');
    expect(input(name: '🪚' * 100).name!.runes.length, 100);
    expect(
      () => input(name: 'a' * 101),
      throwsA(isA<PartValidationException>()),
    );
  });
  test('zero and negative part length reject', () {
    expect(() => input(ticks: 0), throwsA(isA<PartValidationException>()));
    expect(() => input(ticks: -1), throwsRangeError);
  });
  test('part quantity bounds use shared validation', () {
    for (final quantity in [-1, 0, 10000]) {
      expect(
        () => input(quantity: quantity),
        throwsA(isA<QuantityException>()),
      );
    }
    expect(input(quantity: 9999).quantity, 9999);
  });
  test('negative part order rejects', () {
    expect(
      () => PartItem(
        id: 'a',
        projectId: 'p',
        length: Length.fromTicks(1),
        quantity: 1,
        sortOrder: -1,
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
      throwsRangeError,
    );
  });
}
