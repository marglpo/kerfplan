import type { Firestore } from "firebase-admin/firestore";
import type { PurchaseRecord, PurchaseRepository } from "./purchase.js";

export class FirestorePurchaseRepository implements PurchaseRepository {
  constructor(private readonly db: Firestore) {}

  async update(hash: string, change: (current: PurchaseRecord | null) => PurchaseRecord): Promise<PurchaseRecord> {
    if (!/^[a-f0-9]{64}$/.test(hash)) throw new Error("Invalid purchase key");
    const ref = this.db.collection("playPurchases").doc(hash);
    return this.db.runTransaction(async (transaction) => {
      const snapshot = await transaction.get(ref);
      const old = snapshot.exists ? snapshot.data() as PurchaseRecord : null;
      const next = change(old);
      if (JSON.stringify(old) !== JSON.stringify(next)) transaction.set(ref, next);
      return next;
    });
  }
}
