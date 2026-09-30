import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { test } from "node:test";
import { androidpublisher } from "googleapis/build/src/apis/androidpublisher/index.js";
import { EXPECTED_PACKAGE_NAME } from "../src/config.js";
import { BillingError } from "../src/errors.js";
import { callableError, verifyCallable } from "../src/callable.js";
import { GooglePlayClient, mapGooglePurchase, safePlayError } from "../src/google_play_client.js";
import { fixture, TOKEN } from "./fakes.js";

test("official client uses package-bound v2 GET and products acknowledge, never consume", async () => {
  const calls: { url: string; method: string }[] = [];
  const api = androidpublisher({ version: "v3", fetchImplementation: async (url, options) => {
    calls.push({ url: String(url), method: options?.method ?? "GET" });
    return new Response(JSON.stringify({ purchaseStateContext: { purchaseState: "PURCHASED" },
      acknowledgementState: "ACKNOWLEDGEMENT_STATE_PENDING",
      productLineItem: [{ productId: "lifetime_pro", productOfferDetails: { refundableQuantity: 1 } }],
    }), { status: 200, headers: { "content-type": "application/json" } });
  } });
  const client = new GooglePlayClient(api);
  assert.equal((await client.getOneTimePurchase(TOKEN)).state, "PURCHASED");
  await client.acknowledgeOneTimePurchase("lifetime_pro", TOKEN);
  assert.equal(calls.length, 2);
  assert.ok(calls[0]?.url.includes(`/applications/${EXPECTED_PACKAGE_NAME}/purchases/productsv2/tokens/`));
  assert.equal(calls[0]?.method, "GET");
  assert.ok(calls[1]?.url.endsWith(":acknowledge")); assert.equal(calls[1]?.method, "POST");
});
test("Google mapping retains refund and consumption information but omits personal/raw fields", () => {
  const mapped = mapGooglePurchase({
    purchaseStateContext: { purchaseState: "PURCHASED" },
    purchaseCompletionTime: "2026-09-27T00:00:00Z", obfuscatedExternalAccountId: "private",
    productLineItem: [{ productId: "lifetime_pro", productOfferDetails: {
      refundableQuantity: 0, consumptionState: "CONSUMPTION_STATE_CONSUMED", rentOfferDetails: {},
    } }],
  });
  assert.equal(mapped.items[0]?.refundableQuantity, 0); assert.equal(mapped.items[0]?.consumed, true);
  assert.equal(mapped.items[0]?.rental, true); assert.ok(!JSON.stringify(mapped).includes("private"));
  assert.equal(mapGooglePurchase({}).state, "UNKNOWN");
});
for (const status of [400, 404, 410, 401, 403, 429, 500, 503]) test(`safe Google HTTP ${status} classification`, () => {
  const error = safePlayError({ response: { status, data: TOKEN }, message: TOKEN });
  assert.equal(error.code, [400, 404, 410].includes(status) ? "purchaseNotPurchased" : "playApiUnavailable");
  assert.ok(!String(error.stack).includes(TOKEN));
});
test("callable permits verified App Check without Firebase Auth", async () => {
  const f = fixture(); const result = await verifyCallable({ productId: "lifetime_pro", purchaseToken: TOKEN },
    "registered-app", "registered-app", f.service, f.log);
  assert.equal(result.owned, true);
});
for (const appId of [undefined, "different-app"]) test(`callable rejects missing/wrong App Check app ${appId}`, async () => {
  const f = fixture(); await assert.rejects(verifyCallable({}, appId, "registered-app", f.service, f.log));
  assert.equal(f.play.getCalls.length, 0);
});
test("callable errors never expose Google bodies or request tokens", async () => {
  const f = fixture(); f.play.getError = new Error(TOKEN);
  await assert.rejects(verifyCallable({ productId: "lifetime_pro", purchaseToken: TOKEN },
    "app", "app", f.service, f.log), (error: unknown) => {
    assert.ok(error instanceof Error); assert.ok(!error.stack?.includes(TOKEN)); return true;
  });
  assert.ok(!JSON.stringify(f.logs).includes(TOKEN));
  assert.equal(callableError(new BillingError("productMismatch")).code, "failed-precondition");
  assert.equal(callableError(new BillingError("unsupportedProduct")).code, "invalid-argument");
  assert.equal(callableError(new Error(TOKEN)).code, "unavailable");
});
test("deployment enforces App Check, Node 22 and deny-all Firestore rules", () => {
  const source = readFileSync("src/index.ts", "utf8");
  assert.match(source, /enforceAppCheck: true/); assert.ok(!source.includes("request.auth"));
  const rules = readFileSync("../firestore.rules", "utf8");
  assert.match(rules, /allow read, write: if false;/);
  const config = JSON.parse(readFileSync("../firebase.json", "utf8")) as { functions: { runtime: string }[] };
  assert.equal(config.functions[0]?.runtime, "nodejs22");
});
