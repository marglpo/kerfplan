import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { logger } from "firebase-functions";
import { defineString } from "firebase-functions/params";
import { onCall } from "firebase-functions/v2/https";
import { onMessagePublished } from "firebase-functions/v2/pubsub";
import { verifyCallable } from "./callable.js";
import { FirestorePurchaseRepository } from "./firestore_purchase_repository.js";
import { GooglePlayClient } from "./google_play_client.js";
import type { SafeLog } from "./purchase.js";
import { PurchaseService } from "./purchase_service.js";
import { RtdnHandler } from "./rtdn.js";

// Required deployment parameters: no fabricated project IDs or topic resources.
const topic = defineString("PLAY_RTDN_TOPIC", { description: "Existing RTDN topic name in the selected project" });
const region = defineString("BILLING_REGION", { description: "Production Functions region: europe-west4, matching Firestore and the Flutter build" });
const serviceAccount = defineString("BILLING_SERVICE_ACCOUNT", { description: "Dedicated runtime service account email" });
const androidAppId = defineString("BILLING_ANDROID_APP_ID", { description: "Firebase App ID for the com.kerfplan.app Android registration" });

initializeApp();
const log: SafeLog = (event, fields) => { logger.info(event, fields); };
// Lazy SDK composition: deployment discovery needs no live Firestore or Google credentials.
function service(): PurchaseService {
  return new PurchaseService(new GooglePlayClient(), new FirestorePurchaseRepository(getFirestore()), log);
}

export const verifyPlayPurchase = onCall({
  enforceAppCheck: true, region, serviceAccount, timeoutSeconds: 60, maxInstances: 10,
}, (request) => verifyCallable(request.data, request.app?.appId, androidAppId.value(), service(), log));

export const handlePlayRtdn = onMessagePublished({
  topic, region, serviceAccount, retry: true, timeoutSeconds: 60, maxInstances: 10,
}, async (event) => {
  await new RtdnHandler(service(), log).handleBase64(event.data.message.data);
});
