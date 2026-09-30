import assert from "node:assert/strict";
import { test } from "node:test";
import { EXPECTED_PACKAGE_NAME } from "../src/config.js";
import { BillingError } from "../src/errors.js";
import { tokenHash } from "../src/purchase.js";
import { RtdnHandler } from "../src/rtdn.js";
import { fixture, purchased, TOKEN } from "./fakes.js";

const envelope = { version: "1.0", packageName: EXPECTED_PACKAGE_NAME, eventTimeMillis: "12345" };
const product = (notificationType = 1) => ({ ...envelope, oneTimeProductNotification: {
  version: "1.0", notificationType, purchaseToken: TOKEN, sku: "lifetime_pro",
} });
const refund = (refundType = 1, token = TOKEN) => ({ ...envelope,
  voidedPurchaseNotification: { purchaseToken: token, productType: 2, refundType },
});
const encoded = (value: unknown) => Buffer.from(JSON.stringify(value)).toString("base64");

test("purchased RTDN queries Google, persists and acknowledges", async () => {
  const f = fixture(); await new RtdnHandler(f.service, f.log).handleBase64(encoded(product()));
  assert.deepEqual(f.play.getCalls, [TOKEN]); assert.equal(f.play.ackCalls.length, 1);
  assert.equal(f.repository.records.get(tokenHash(TOKEN))?.state, "purchased");
});
test("wrong package never queries or mutates", async () => {
  const f = fixture(); await new RtdnHandler(f.service, f.log).handle({ ...product(), packageName: "other.app" });
  assert.equal(f.repository.records.size, 0); assert.equal(f.play.getCalls.length, 0);
});
test("canceled event never grants or acknowledges, even if Play fake says purchased", async () => {
  const f = fixture(); const handler = new RtdnHandler(f.service, f.log);
  await handler.handle(product()); await handler.handle(product(2));
  assert.equal(f.repository.records.get(tokenHash(TOKEN))?.state, "cancelled");
  assert.equal(f.play.ackCalls.length, 1);
});
test("fully voided affects only exact token and cannot be resurrected", async () => {
  const f = fixture(); await f.service.verify({ productId: "lifetime_pro", purchaseToken: TOKEN });
  await f.service.verify({ productId: "lifetime_pro", purchaseToken: "other-token" });
  const handler = new RtdnHandler(f.service, f.log); await handler.handle(refund());
  assert.equal(f.repository.records.get(tokenHash(TOKEN))?.voided, true);
  assert.equal(f.repository.records.get(tokenHash("other-token"))?.state, "purchased");
  await handler.handle(product()); assert.equal(f.repository.records.get(tokenHash(TOKEN))?.voided, true);
});
test("refund before first verification creates a hash-only tombstone", async () => {
  const f = fixture(); await new RtdnHandler(f.service, f.log).handle(refund());
  const row = f.repository.records.get(tokenHash(TOKEN));
  assert.equal(row?.voided, true); assert.equal(row.productId, null);
  assert.ok(!JSON.stringify(row).includes(TOKEN));
});
test("partial refund queries current remaining quantity without full revocation", async () => {
  const f = fixture(); await new RtdnHandler(f.service, f.log).handle(refund(2));
  assert.equal(f.play.getCalls.length, 1); assert.equal(f.repository.records.get(tokenHash(TOKEN))?.state, "purchased");
});
test("partial refund with zero remaining quantity revokes", async () => {
  const f = fixture(); f.play.purchase.items = [{ ...purchased().items[0]!, refundableQuantity: 0 }];
  await new RtdnHandler(f.service, f.log).handle(refund(2));
  assert.equal(f.repository.records.get(tokenHash(TOKEN))?.voided, true);
});
for (const payload of [
  { ...envelope, subscriptionNotification: { notificationType: 1, purchaseToken: TOKEN } },
  { ...envelope, testNotification: { version: "1.0" } },
  { ...envelope, futureNotification: {} },
  { ...envelope, voidedPurchaseNotification: { purchaseToken: TOKEN, productType: 1, refundType: 1 } },
  product(999), { ...product(), eventTimeMillis: "NaN" },
  { ...product(), testNotification: {} },
  { ...envelope, oneTimeProductNotification: { notificationType: 1, sku: "unknown", purchaseToken: TOKEN } },
]) test(`unsupported/test notification is harmless: ${JSON.stringify(payload).slice(70, 180)}`, async () => {
  const f = fixture(); await new RtdnHandler(f.service, f.log).handle(payload);
  assert.equal(f.repository.records.size, 0); assert.equal(f.play.getCalls.length, 0);
});
for (const data of [null, 12, "%%%", "a", Buffer.from("not json").toString("base64"), encoded([])]) {
  test(`malformed PubSub data ${String(data)} is ignored`, async () => {
    const f = fixture(); await new RtdnHandler(f.service, f.log).handleBase64(data);
    assert.equal(f.repository.records.size, 0); assert.equal(f.play.getCalls.length, 0);
  });
}
test("duplicate purchase and refund RTDN are idempotent", async () => {
  const f = fixture(); const handler = new RtdnHandler(f.service, f.log);
  await handler.handle(product()); await handler.handle(product());
  assert.equal(f.repository.records.size, 1); assert.equal(f.play.ackCalls.length, 1);
  await handler.handle(refund()); const writes = f.repository.writes;
  await handler.handle(refund()); assert.equal(f.repository.writes, writes);
});
test("transient API failures retry PubSub with safe errors", async () => {
  const f = fixture(); f.play.getError = new Error(TOKEN);
  await assert.rejects(new RtdnHandler(f.service, f.log).handle(product()),
    (error: unknown) => error instanceof BillingError && error.code === "playApiUnavailable");
  assert.ok(!JSON.stringify(f.logs).includes(TOKEN));
});
test("invalid purchase is not a poison-message retry loop", async () => {
  const f = fixture(); f.play.getError = new BillingError("purchaseNotPurchased");
  await new RtdnHandler(f.service, f.log).handle(product()); assert.equal(f.repository.records.size, 0);
});
test("refund storage failures are retried", async () => {
  const f = fixture(); f.repository.fail = true;
  await assert.rejects(new RtdnHandler(f.service, f.log).handle(refund()),
    (error: unknown) => error instanceof BillingError && error.code === "storageFailure");
});
