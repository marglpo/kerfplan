enum InventoryMode {
  fixed('fixed'),
  buy('buy');

  const InventoryMode(this.storageValue);
  final String storageValue;

  static InventoryMode fromStorage(String value) => switch (value) {
    'fixed' => fixed,
    'buy' => buy,
    _ => throw FormatException('Unknown inventory mode', value),
  };
}
