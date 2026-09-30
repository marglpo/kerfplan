import { EXPECTED_PACKAGE_NAME, isProductId } from "./config.js";
import { BillingError, retryable } from "./errors.js";
import { isObject, validToken, type SafeLog } from "./purchase.js";
import type { PurchaseService } from "./purchase_service.js";

export class RtdnHandler {
  constructor(private readonly service: PurchaseService, private readonly log: SafeLog) {}

  async handleBase64(data: unknown): Promise<void> {
    if (typeof data !== "string" || data.length > 32_768 ||
      !/^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$/.test(data)) {
      this.log("rtdn_ignored", { code: "malformed" }); return;
    }
    let value: unknown;
    try { value = JSON.parse(Buffer.from(data, "base64").toString("utf8")); }
    catch { this.log("rtdn_ignored", { code: "malformed" }); return; }
    await this.handle(value);
  }

  async handle(value: unknown): Promise<void> {
    if (!isObject(value) || value.packageName !== EXPECTED_PACKAGE_NAME) {
      this.log("rtdn_ignored", { code: "packageOrShape" }); return;
    }
    const keys = ["oneTimeProductNotification", "voidedPurchaseNotification", "testNotification",
      "subscriptionNotification", "pendingRefundReviewNotification"].filter((key) => key in value);
    if (keys.length !== 1) { this.log("rtdn_ignored", { code: "unknownOrAmbiguous" }); return; }
    if (isObject(value.testNotification)) { this.log("rtdn_test_received", {}); return; }
    const time = typeof value.eventTimeMillis === "string" && /^\d+$/.test(value.eventTimeMillis)
      ? Number(value.eventTimeMillis) : NaN;
    if (!Number.isSafeInteger(time) || time < 0) return;
    try {
      const item = value.oneTimeProductNotification;
      if (isObject(item) && validToken(item.purchaseToken) && isProductId(item.sku)) {
        const request = { productId: item.sku, purchaseToken: item.purchaseToken };
        if (item.notificationType === 1) await this.service.verify(request);
        else if (item.notificationType === 2) await this.service.cancel(request, time);
        return;
      }
      const voided = value.voidedPurchaseNotification;
      if (isObject(voided) && voided.productType === 2 && validToken(voided.purchaseToken)) {
        if (voided.refundType === 1) await this.service.revoke(voided.purchaseToken, time);
        else if (voided.refundType === 2) await this.service.refresh(voided.purchaseToken);
      }
      // Unknown future and subscription notifications intentionally do not mutate purchases.
    } catch (error) {
      const safe = error instanceof BillingError ? error : new BillingError("storageFailure");
      this.log("rtdn_processing_failed", { code: safe.code });
      if (retryable(safe.code)) throw safe; // Pub/Sub retries transient failures, not poison messages.
    }
  }
}
