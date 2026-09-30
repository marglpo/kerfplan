class Entitlements {
  const Entitlements({
    this.removeAdsOwned = false,
    this.lifetimeProOwned = false,
  });
  final bool removeAdsOwned;
  final bool lifetimeProOwned;
  bool get isPro => lifetimeProOwned;
  bool get isAdFree => lifetimeProOwned || removeAdsOwned;
  @override
  bool operator ==(Object other) =>
      other is Entitlements &&
      other.removeAdsOwned == removeAdsOwned &&
      other.lifetimeProOwned == lifetimeProOwned;
  @override
  int get hashCode => Object.hash(removeAdsOwned, lifetimeProOwned);
}
