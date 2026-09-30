import assert from "node:assert/strict";
import { test } from "node:test";
import { BillingError } from "../src/errors.js";
import { EXPECTED_PACKAGE_NAME, SUPPORTED_PRODUCTS } from "../src/config.js";
import { emptyRecord, tokenHash } from "../src/purchase.js";
import { fixture, purchased, TOKEN } from "./fakes.js";

const request = { productId: "lifetime_pro", purchaseToken: TOKEN };
const code = (expected: string) => (error: unknown) => error instanceof BillingError && error.code === expected;

for (const productId of SUPPORTED_PRODUCTS) test(`verifies and acknowledges ${productId}`, async () => {
  const f = fixture(); f.play.purchase = purchased(productId);
  const result = await f.service.verify({ ...request, productId });
  assert.deepEqual(result, { productId, owned: true, acknowledged: true, verifiedAt: "2026-09-27T00:00:00.000Z" });
  assert.equal(f.repository.records.size, 1);
  assert.equal(f.repository.records.get(tokenHash(TOKEN))?.packageName, EXPECTED_PACKAGE_NAME);
  assert.equal(f.play.ackCalls.length, 1);
});

for (const input of [null, [], {}, { ...request, productId: "subscription" },
  { ...request, purchaseToken: "" }, { ...request, purchaseToken: "   " },
  { ...request, purchaseToken: 12 }, { ...request, purchaseToken: "x".repeat(4097) },
  { ...request, packageName: "other.app" }, { ...request, purchased: true }]) {
  test(`rejects malformed request ${JSON.stringify(input).slice(0, 110)}`, async () => {
    const f = fixture(); await assert.rejects(f.service.verify(input), BillingError);
    assert.equal(f.play.getCalls.length, 0); assert.equal(f.repository.records.size, 0);
  });
}

for (const state of ["PENDING", "CANCELLED", "PURCHASE_STATE_UNSPECIFIED", "FUTURE_STATE"]) {
  test(`${state} does not grant or acknowledge`, async () => {
    const f = fixture(); f.play.purchase.state = state;
    assert.equal((await f.service.verify(request)).owned, false);
    assert.equal(f.play.ackCalls.length, 0);
  });
}
test("client product must match Google product", async () => {
  const f = fixture(); f.play.purchase = purchased("remove_ads");
  await assert.rejects(f.service.verify(request), code("productMismatch"));
  assert.equal(f.repository.records.size, 0); assert.equal(f.play.ackCalls.length, 0);
});
test("missing Google line items fails closed", async () => {
  const f = fixture(); f.play.purchase.items = [];
  await assert.rejects(f.service.verify(request), code("productMismatch"));
});
test("invalid token from Play is safely rejected", async () => {
  const f = fixture(); f.play.getError = new BillingError("purchaseNotPurchased");
  await assert.rejects(f.service.verify(request), code("purchaseNotPurchased"));
  assert.equal(f.repository.records.size, 0);
});
test("unknown Google error is sanitized", async () => {
  const f = fixture(); f.play.getError = new Error(`Google request ${TOKEN}`);
  await assert.rejects(f.service.verify(request), (error: unknown) => {
    assert.ok(error instanceof BillingError); assert.equal(error.code, "playApiUnavailable");
    assert.ok(!String(error.stack).includes(TOKEN)); return true;
  });
});
test("verified persistence precedes acknowledgement", async () => {
  const f = fixture(); f.play.beforeAck = async () => {
    const row = f.repository.records.get(tokenHash(TOKEN));
    assert.equal(row?.state, "purchased"); assert.equal(row.acknowledged, false);
  };
  await f.service.verify(request);
});
test("storage failure never acknowledges", async () => {
  const f = fixture(); f.repository.fail = true;
  await assert.rejects(f.service.verify(request), code("storageFailure"));
  assert.equal(f.play.ackCalls.length, 0);
});
test("already acknowledged skips acknowledgement", async () => {
  const f = fixture(); f.play.purchase.acknowledgement = "ACKNOWLEDGEMENT_STATE_ACKNOWLEDGED";
  assert.equal((await f.service.verify(request)).owned, true); assert.equal(f.play.ackCalls.length, 0);
});
test("acknowledgement failure preserves verified record and permits retry", async () => {
  const f = fixture(); f.play.ackError = new Error(TOKEN);
  await assert.rejects(f.service.verify(request), code("acknowledgementFailed"));
  const row = f.repository.records.get(tokenHash(TOKEN));
  assert.equal(row?.state, "purchased"); assert.equal(row.acknowledged, false);
  assert.equal(row.acknowledgementError, "acknowledgementFailed");
  assert.ok(!JSON.stringify(f.logs).includes(TOKEN));
  f.play.ackError = null;
  assert.equal((await f.service.verify(request)).acknowledged, true);
  assert.equal(f.repository.records.get(tokenHash(TOKEN))?.acknowledgementError, null);
});
test("repeat verification preserves first verification, one record and one acknowledgement", async () => {
  const f = fixture(); await f.service.verify(request); f.advance(); await f.service.verify(request);
  assert.equal(f.repository.records.size, 1); assert.equal(f.play.ackCalls.length, 1);
  assert.equal(f.play.getCalls.length, 2); // Always reconcile with Google; never trust cached ownership.
  const row = f.repository.records.get(tokenHash(TOKEN));
  assert.notEqual(row?.firstVerifiedAt, row?.lastVerifiedAt);
});
test("Google acknowledged state resolves an earlier ambiguous acknowledgement failure", async () => {
  const f = fixture(); f.play.ackError = new Error("Request timed out after Play accepted it");
  await assert.rejects(f.service.verify(request), code("acknowledgementFailed"));
  f.play.purchase.acknowledgement = "ACKNOWLEDGEMENT_STATE_ACKNOWLEDGED";
  assert.equal((await f.service.verify(request)).acknowledged, true);
  assert.equal(f.play.ackCalls.length, 1);
  const row = f.repository.records.get(tokenHash(TOKEN));
  assert.equal(row?.acknowledgementError, null); assert.equal(row?.ackLease, null);
});
test("hash is SHA-256, deterministic, distinct; records/logs/responses omit tokens", async () => {
  assert.equal(tokenHash("abc"), "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad");
  assert.equal(tokenHash(TOKEN), tokenHash(TOKEN)); assert.notEqual(tokenHash(TOKEN), tokenHash("other"));
  const f = fixture(); const response = await f.service.verify(request);
  assert.equal([...f.repository.records.keys()][0], tokenHash(TOKEN));
  assert.ok(!JSON.stringify([...f.repository.records, response, f.logs]).includes(TOKEN));
});
test("fully refunded Google item cannot grant ownership", async () => {
  const f = fixture(); f.play.purchase.items = [{ ...purchased().items[0]!, refundableQuantity: 0 }];
  await assert.rejects(f.service.verify(request), code("purchaseVoided"));
  assert.equal(f.play.ackCalls.length, 0);
});
test("pending payment with zero refundable quantity can later complete", async () => {
  const f = fixture(); f.play.purchase.state = "PENDING";
  f.play.purchase.items = [{ ...purchased().items[0]!, refundableQuantity: 0 }];
  assert.equal((await f.service.verify(request)).owned, false);
  assert.equal(f.repository.records.get(tokenHash(TOKEN))?.voided, false);
  f.play.purchase = purchased();
  assert.equal((await f.service.verify(request)).owned, true);
});
for (const flag of ["consumed", "rental"] as const) test(`${flag} purchase does not grant a non-consumable`, async () => {
  const f = fixture(); f.play.purchase.items = [{ ...purchased().items[0]!, [flag]: true }];
  assert.equal((await f.service.verify(request)).owned, false);
  assert.equal(f.play.ackCalls.length, 0);
});
test("full refund before verification prevents resurrection", async () => {
  const f = fixture(); await f.service.revoke(TOKEN, 123);
  await assert.rejects(f.service.verify(request), code("purchaseVoided"));
  assert.equal(f.play.ackCalls.length, 0);
});
test("refund racing with acknowledgement remains revoked", async () => {
  const f = fixture(); f.play.beforeAck = () => f.service.revoke(TOKEN, 123);
  await assert.rejects(f.service.verify(request), code("purchaseVoided"));
  assert.equal(f.repository.records.get(tokenHash(TOKEN))?.voided, true);
});
test("concurrent calls do not both acknowledge", async () => {
  const f = fixture(); let release!: () => void;
  const held = new Promise<void>((resolve) => { release = resolve; });
  let started!: () => void;
  const entered = new Promise<void>((resolve) => { started = resolve; });
  f.play.beforeAck = async () => { started(); await held; };
  const first = f.service.verify(request); await entered;
  await assert.rejects(f.service.verify(request), code("acknowledgementFailed"));
  release(); assert.equal((await first).owned, true); assert.equal(f.play.ackCalls.length, 1);
});
test("abandoned acknowledgement lease can be retried after expiry", async () => {
  const f = fixture(); f.repository.records.set(tokenHash(TOKEN), {
    ...emptyRecord(tokenHash(TOKEN)), productId: "lifetime_pro", state: "purchased",
    ackLease: { id: "crashed-request", until: new Date("2026-09-27T00:00:30Z").getTime() },
  });
  await assert.rejects(f.service.verify(request), code("acknowledgementFailed"));
  f.advance(); assert.equal((await f.service.verify(request)).owned, true);
});
