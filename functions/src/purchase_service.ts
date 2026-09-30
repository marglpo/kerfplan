import { randomUUID } from "node:crypto";
import { isProductId } from "./config.js";
import { BillingError } from "./errors.js";
import {
  emptyRecord, parseRequest, tokenHash, type EntitlementResponse,
  type PlayPublisherClient, type PlayPurchase, type PurchaseRecord, type PurchaseRepository, type PurchaseRequest, type SafeLog,
} from "./purchase.js";

export class PurchaseService {
  constructor(
    private readonly play: PlayPublisherClient,
    private readonly repository: PurchaseRepository,
    private readonly log: SafeLog,
    private readonly now: () => Date = () => new Date(),
  ) {}

  async verify(input: unknown): Promise<EntitlementResponse> {
    const request = parseRequest(input);
    const purchase = await this.getPurchase(request.purchaseToken);
    return this.verifyPurchase(request, purchase);
  }

  async refresh(token: string): Promise<void> {
    const purchase = await this.getPurchase(token);
    const products = purchase.items.filter((item) => isProductId(item.productId));
    for (const item of products) {
      const request = parseRequest({ productId: item.productId, purchaseToken: token });
      await this.verifyPurchase(request, purchase);
    }
  }

  private async verifyPurchase({ productId, purchaseToken }: PurchaseRequest, purchase: PlayPurchase): Promise<EntitlementResponse> {
    const hash = tokenHash(purchaseToken);
    const item = purchase.items.find((line) => line.productId === productId);
    if (!item) throw new BillingError("productMismatch");
    const time = this.now().toISOString();
    // Pending payments may have no refundable quantity yet; they are not refund tombstones.
    const fullyRefunded = purchase.state === "PURCHASED" && item.refundableQuantity === 0;
    const purchased = purchase.state === "PURCHASED" && !fullyRefunded &&
      !item.consumed && !item.rental;
    let record = await this.update(hash, (current) => {
      const old = current ?? emptyRecord(hash);
      if (old.productId !== null && old.productId !== productId) throw new BillingError("productMismatch");
      // A full refund tombstone wins even over an in-flight/stale Play response.
      if (old.voided) return old;
      const acknowledged = old.acknowledged ||
        purchase.acknowledgement === "ACKNOWLEDGEMENT_STATE_ACKNOWLEDGED";
      return {
        ...old, productId, state: fullyRefunded ? "voided" : purchased ? "purchased" :
          purchase.state === "PENDING" ? "pending" :
            purchase.state === "CANCELLED" ? "cancelled" : "unknown",
        voided: fullyRefunded,
        acknowledged,
        acknowledgementError: acknowledged ? null : old.acknowledgementError,
        ackLease: acknowledged ? null : old.ackLease,
        purchaseTime: purchase.purchaseTime,
        firstVerifiedAt: old.firstVerifiedAt ?? (purchased ? time : null), lastVerifiedAt: time,
      };
    });
    if (record.voided) throw new BillingError("purchaseVoided");
    if (!purchased) return { productId, owned: false, verifiedAt: time, acknowledged: record.acknowledged };

    if (!record.acknowledged) {
      const leaseId = randomUUID();
      const now = this.now().getTime();
      record = await this.update(hash, (current) => {
        if (!current) throw new BillingError("storageFailure");
        if (current.voided || current.state !== "purchased" || current.acknowledged ||
          (current.ackLease !== null && current.ackLease.until > now)) return current;
        return { ...current, ackLease: { id: leaseId, until: now + 60_000 } };
      });
      if (record.voided) throw new BillingError("purchaseVoided");
      if (record.state !== "purchased") throw new BillingError("purchaseNotPurchased");
      if (!record.acknowledged) {
        if (record.ackLease?.id !== leaseId) throw new BillingError("acknowledgementFailed");
        try {
          await this.play.acknowledgeOneTimePurchase(productId, purchaseToken);
        } catch {
          await this.update(hash, (current) => {
            if (!current) throw new BillingError("storageFailure");
            return current.ackLease?.id !== leaseId ? current : {
              ...current, ackLease: null, acknowledgementError: "acknowledgementFailed",
            };
          });
          this.log("acknowledgement_failed", { tokenHash: hash, productId });
          throw new BillingError("acknowledgementFailed");
        }
        await this.update(hash, (current) => {
          if (!current) throw new BillingError("storageFailure");
          return { ...current, acknowledged: true, acknowledgementError: null, ackLease: null };
        });
      }
    }
    // Re-read transactionally: a concurrent refund/cancellation must not be overwritten by acknowledgement.
    record = await this.update(hash, (current) => {
      if (!current) throw new BillingError("storageFailure");
      return current;
    });
    if (record.voided) throw new BillingError("purchaseVoided");
    this.log("purchase_verified", { tokenHash: hash, productId });
    return { productId, owned: record.state === "purchased", verifiedAt: time, acknowledged: record.acknowledged };
  }

  async revoke(token: string, eventTime: number): Promise<void> {
    const hash = tokenHash(token);
    await this.update(hash, (current) => {
      const old = current ?? emptyRecord(hash);
      return {
        ...old, state: "voided", voided: true, ackLease: null,
        lastEventTime: Math.max(old.lastEventTime ?? 0, eventTime), lastEventType: "fullRefund",
      };
    });
    this.log("purchase_voided", { tokenHash: hash });
  }

  async cancel(input: unknown, eventTime: number): Promise<void> {
    const { productId, purchaseToken } = parseRequest(input);
    // A pending-purchase cancellation can only remove ownership; it never acknowledges or grants.
    await this.update(tokenHash(purchaseToken), (current) => {
      const old = current ?? emptyRecord(tokenHash(purchaseToken));
      if (old.voided || (old.lastEventTime ?? 0) > eventTime) return old;
      return { ...old, productId: old.productId ?? productId, state: "cancelled",
        ackLease: null, lastEventTime: eventTime, lastEventType: "cancelled" };
    });
  }

  private async update(hash: string, change: (current: PurchaseRecord | null) => PurchaseRecord): Promise<PurchaseRecord> {
    try { return await this.repository.update(hash, change); }
    catch (error) {
      if (error instanceof BillingError) throw error;
      throw new BillingError("storageFailure");
    }
  }

  private async getPurchase(token: string): Promise<PlayPurchase> {
    try { return await this.play.getOneTimePurchase(token); }
    catch (error) {
      if (error instanceof BillingError) throw error;
      throw new BillingError("playApiUnavailable");
    }
  }
}
