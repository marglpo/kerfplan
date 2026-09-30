enum BillingProduct {
  removeAds('remove_ads'),
  lifetimePro('lifetime_pro');

  const BillingProduct(this.id);
  final String id;
  static BillingProduct? fromId(String id) {
    for (final product in values) {
      if (product.id == id) return product;
    }
    return null;
  }
}
