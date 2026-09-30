import type { ProductId } from "../src/config.js";
import type { PlayPublisherClient, PlayPurchase, PurchaseRecord, PurchaseRepository, SafeLog } from "../src/purchase.js";
import { PurchaseService } from "../src/purchase_service.js";

export const TOKEN = "test-purchase-token-never-log";
export const purchased = (productId = "lifetime_pro"): PlayPurchase => ({
  state: "PURCHASED", acknowledgement: "ACKNOWLEDGEMENT_STATE_PENDING",
  purchaseTime: "2026-09-01T00:00:00Z",
  items: [{ productId, refundableQuantity: 1, consumed: false, rental: false }],
});
export class FakePlay implements PlayPublisherClient {
  purchase = purchased();
  getCalls: string[] = [];
  ackCalls: { productId: ProductId; token: string }[] = [];
  getError: Error | null = null;
  ackError: Error | null = null;
  beforeAck: (() => Promise<void>) | null = null;
  async getOneTimePurchase(token: string): Promise<PlayPurchase> {
    this.getCalls.push(token);
    if (this.getError) throw this.getError;
    return this.purchase;
  }
  async acknowledgeOneTimePurchase(productId: ProductId, token: string): Promise<void> {
    this.ackCalls.push({ productId, token });
    await this.beforeAck?.();
    if (this.ackError) throw this.ackError;
  }
}
export class FakeRepository implements PurchaseRepository {
  records = new Map<string, PurchaseRecord>();
  fail = false;
  writes = 0;
  async update(hash: string, change: (current: PurchaseRecord | null) => PurchaseRecord): Promise<PurchaseRecord> {
    if (this.fail) throw new Error("Internal storage failure");
    const old = this.records.get(hash) ?? null;
    const next = change(old === null ? null : structuredClone(old));
    if (JSON.stringify(old) !== JSON.stringify(next)) {
      this.writes++;
      this.records.set(hash, structuredClone(next));
    }
    return structuredClone(next);
  }
}
export function fixture() {
  const play = new FakePlay();
  const repository = new FakeRepository();
  const logs: { event: string; fields: object }[] = [];
  const log: SafeLog = (event, fields) => { logs.push({ event, fields }); };
  let time = new Date("2026-09-27T00:00:00Z");
  const service = new PurchaseService(play, repository, log, () => time);
  return { play, repository, logs, log, service, advance: () => { time = new Date(time.getTime() + 61_000); } };
}
