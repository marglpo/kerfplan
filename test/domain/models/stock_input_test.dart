import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/domain/models/stock_input.dart';
import 'package:kerfplan/domain/models/stock_item.dart';
import 'package:kerfplan/domain/units/length.dart';

void main() {
  final length = Length.fromMillimeters('6000');

  test('labels trim, blanks become null and overlong labels reject', () {
    expect(StockInput(length: length, quantity: 10, label: '  ').label, isNull);
    expect(
      StockInput(length: length, quantity: 10, label: ' Warehouse ').label,
      'Warehouse',
    );
    expect(
      StockInput(length: length, quantity: 10, label: 'A' * 80).label,
      hasLength(80),
    );
    expect(
      () => StockInput(length: length, quantity: 10, label: 'A' * 81),
      throwsA(isA<StockValidationException>()),
    );
  });

  test('zero and negative lengths reject', () {
    expect(
      () => StockInput(length: Length.fromTicks(0), quantity: 1),
      throwsA(isA<StockValidationException>()),
    );
    expect(
      () => StockInput(length: Length.fromTicks(-1), quantity: 1),
      throwsRangeError,
    );
  });

  test('quantity enforces inclusive 1 to 9999 in domain and text entry', () {
    for (final quantity in [-1, 0, 10000]) {
      expect(
        () => StockInput(length: length, quantity: quantity),
        throwsA(isA<StockValidationException>()),
      );
    }
    expect(StockInput(length: length, quantity: 9999).quantity, 9999);
    expect(StockInput.parseQuantity(' 9999 '), 9999);
    for (final value in [
      '',
      '0',
      '-1',
      '10000',
      '1.5',
      'x',
      '9999999999999999999999999',
    ]) {
      expect(
        () => StockInput.parseQuantity(value),
        throwsA(isA<StockValidationException>()),
      );
    }
  });

  test('stock entity rejects negative order and normalizes label', () {
    StockItem item(int order) => StockItem(
      id: 's',
      projectId: 'p',
      length: length,
      quantity: 1,
      label: ' Rack ',
      sortOrder: order,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );
    expect(() => item(-1), throwsRangeError);
    expect(item(0).label, 'Rack');
  });
}
