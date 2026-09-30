// Import only Android Publisher; avoid loading every API shipped in googleapis.
import { androidpublisher, auth, type androidpublisher_v3 } from "googleapis/build/src/apis/androidpublisher/index.js";
import { EXPECTED_PACKAGE_NAME, type ProductId } from "./config.js";
import { BillingError } from "./errors.js";
import { isObject, type PlayPublisherClient, type PlayPurchase } from "./purchase.js";

export function mapGooglePurchase(data: androidpublisher_v3.Schema$ProductPurchaseV2): PlayPurchase {
  return {
    state: data.purchaseStateContext?.purchaseState ?? "UNKNOWN",
    acknowledgement: data.acknowledgementState ?? "UNKNOWN",
    purchaseTime: data.purchaseCompletionTime ?? null,
    items: (data.productLineItem ?? []).map((item) => ({
      productId: item.productId ?? "",
      refundableQuantity: item.productOfferDetails?.refundableQuantity ?? null,
      consumed: item.productOfferDetails?.consumptionState === "CONSUMPTION_STATE_CONSUMED",
      rental: item.productOfferDetails?.rentOfferDetails != null,
    })),
  };
}

export function safePlayError(error: unknown): BillingError {
  const status = isObject(error) && isObject(error.response) ? error.response.status : undefined;
  return new BillingError(status === 400 || status === 404 || status === 410
    ? "purchaseNotPurchased" : "playApiUnavailable");
}

export class GooglePlayClient implements PlayPublisherClient {
  constructor(private readonly api = androidpublisher({
    version: "v3",
    auth: new auth.GoogleAuth({ scopes: ["https://www.googleapis.com/auth/androidpublisher"] }),
  })) {}

  async getOneTimePurchase(token: string): Promise<PlayPurchase> {
    try {
      const response = await this.api.purchases.productsv2.getproductpurchasev2({
        packageName: EXPECTED_PACKAGE_NAME, token,
      }, { timeout: 15_000, retry: false });
      return mapGooglePurchase(response.data);
    } catch (error) { throw safePlayError(error); }
  }

  async acknowledgeOneTimePurchase(productId: ProductId, token: string): Promise<void> {
    try {
      await this.api.purchases.products.acknowledge({
        packageName: EXPECTED_PACKAGE_NAME, productId, token, requestBody: {},
      }, { timeout: 15_000, retry: false });
    } catch { throw new BillingError("acknowledgementFailed"); }
  }
}
