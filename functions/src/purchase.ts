import { createHash } from "node:crypto";
import { EXPECTED_PACKAGE_NAME, isProductId, type ProductId } from "./config.js";
import { BillingError } from "./errors.js";

export interface PurchaseRequest { productId: ProductId; purchaseToken: string }
export function validToken(value: unknown): value is string {
  return typeof value === "string" && value.length > 0 && value.length <= 4096 &&
    !/\s/.test(value);
}
export function parseRequest(value: unknown): PurchaseRequest {
  if (!isObject(value) || Object.keys(value).some((key) =>
    !["productId", "purchaseToken"].includes(key))) throw new BillingError("invalidArgument");
  if (!isProductId(value.productId)) throw new BillingError("unsupportedProduct");
  if (!validToken(value.purchaseToken)) throw new BillingError("invalidArgument");
  return { productId: value.productId, purchaseToken: value.purchaseToken };
}
export function isObject(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}
export const tokenHash = (token: string): string =>
  createHash("sha256").update(token, "utf8").digest("hex");

export interface PlayPurchase {
  state: string;
  acknowledgement: string;
  purchaseTime: string | null;
  items: ReadonlyArray<{
    productId: string;
    refundableQuantity: number | null;
    consumed: boolean;
    rental: boolean;
  }>;
}
export interface PlayPublisherClient {
  getOneTimePurchase(token: string): Promise<PlayPurchase>;
  acknowledgeOneTimePurchase(productId: ProductId, token: string): Promise<void>;
}
export type PurchaseState = "purchased" | "pending" | "cancelled" | "unknown" | "voided";
export interface PurchaseRecord {
  tokenHash: string;
  productId: ProductId | null;
  packageName: typeof EXPECTED_PACKAGE_NAME;
  state: PurchaseState;
  acknowledged: boolean;
  acknowledgementError: "acknowledgementFailed" | null;
  ackLease: { id: string; until: number } | null;
  purchaseTime: string | null;
  firstVerifiedAt: string | null;
  lastVerifiedAt: string | null;
  voided: boolean;
  lastEventTime: number | null;
  lastEventType: string | null;
}
export interface PurchaseRepository {
  // Callback is pure and may run repeatedly inside a Firestore transaction.
  update(hash: string, change: (current: PurchaseRecord | null) => PurchaseRecord): Promise<PurchaseRecord>;
}
export function emptyRecord(hash: string): PurchaseRecord {
  return {
    tokenHash: hash, productId: null, packageName: EXPECTED_PACKAGE_NAME,
    state: "unknown", acknowledged: false, acknowledgementError: null,
    ackLease: null, purchaseTime: null, firstVerifiedAt: null, lastVerifiedAt: null,
    voided: false, lastEventTime: null, lastEventType: null,
  };
}
export interface EntitlementResponse {
  productId: ProductId;
  owned: boolean;
  verifiedAt: string;
  acknowledged: boolean;
}
export type SafeLog = (event: string, fields: {
  tokenHash?: string; productId?: ProductId; code?: string;
}) => void;
