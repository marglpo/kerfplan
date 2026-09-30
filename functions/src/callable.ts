import { HttpsError } from "firebase-functions/v2/https";
import { BillingError } from "./errors.js";
import type { PurchaseService } from "./purchase_service.js";
import type { EntitlementResponse, SafeLog } from "./purchase.js";

export function callableError(error: unknown): HttpsError {
  const code = error instanceof BillingError ? error.code : "storageFailure";
  switch (code) {
    case "invalidArgument": case "unsupportedProduct":
      return new HttpsError("invalid-argument", "Invalid purchase request.", { reason: code });
    case "playApiUnavailable": case "acknowledgementFailed": case "storageFailure":
      return new HttpsError("unavailable", "Purchase verification could not be completed. Retry later.", { reason: code });
    default:
      return new HttpsError("failed-precondition", "This purchase does not grant ownership.", { reason: code });
  }
}

export async function verifyCallable(
  data: unknown, appId: string | undefined, allowedAppId: string,
  service: PurchaseService, log: SafeLog,
): Promise<EntitlementResponse> {
  // App Check is enforced by the Functions wrapper; additionally bind to this Android registration.
  if (!appId || appId !== allowedAppId) throw new HttpsError("permission-denied", "App verification required.");
  try { return await service.verify(data); }
  catch (error) {
    const safe = callableError(error);
    log("verification_failed", { code: error instanceof BillingError ? error.code : "storageFailure" });
    throw safe;
  }
}
