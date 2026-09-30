export const EXPECTED_PACKAGE_NAME = "com.kerfplan.app";
export const SUPPORTED_PRODUCTS = ["remove_ads", "lifetime_pro"] as const;
export type ProductId = (typeof SUPPORTED_PRODUCTS)[number];

export function isProductId(value: unknown): value is ProductId {
  return SUPPORTED_PRODUCTS.some((product) => product === value);
}
