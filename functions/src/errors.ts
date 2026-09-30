export type BillingErrorCode =
  | "invalidArgument" | "unsupportedProduct" | "playApiUnavailable"
  | "purchaseNotPurchased" | "productMismatch" | "purchaseVoided"
  | "acknowledgementFailed" | "storageFailure";

// Never retain upstream exceptions: Google errors can contain the request token.
export class BillingError extends Error {
  constructor(readonly code: BillingErrorCode) {
    super(code);
    this.name = "BillingError";
  }
}

export const retryable = (code: BillingErrorCode): boolean =>
  ["playApiUnavailable", "acknowledgementFailed", "storageFailure"].includes(code);
