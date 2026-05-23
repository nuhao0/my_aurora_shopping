/**
 * Real email + server push when a document is created at users/{uid}/orders/{orderId}.
 *
 * Setup:
 *   1. Blaze billing + enable Cloud Functions + Firebase Admin API.
 *   cd functions && npm install
 *   firebase init functions   (link this folder if needed)
 *   firebase deploy --only functions
 *
 * 2. In Google Cloud Console → Cloud Run → your function → Edit & deploy new revision
 *    → Variables & secrets, add:
 *      SENDGRID_API_KEY = <from sendgrid.com>
 *      MAIL_FROM = verified sender email in SendGrid (e.g. orders@yourdomain.com)
 *
 * 3. Publish firestore.rules (includes email_inbox read-only for clients).
 *
 * Without SENDGRID_API_KEY, the function still writes to email_inbox and sends FCM
 * if users/{uid} has fcmToken (saved by the Flutter app).
 */
const {setGlobalOptions} = require("firebase-functions/v2/options");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {onRequest} = require("firebase-functions/v2/https");

const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");

admin.initializeApp();

setGlobalOptions({region: "europe-west1", maxInstances: 10});

exports.onOrderCreatedSendEmailAndPush = onDocumentCreated(
  "users/{uid}/orders/{orderId}",
  async (event) => {
    const snap = event.data;
    if (!snap) {
      return;
    }
    const {uid, orderId} = event.params;
    const order = snap.data();
    const total = order.total ?? 0;

    let email = null;
    try {
      const user = await admin.auth().getUser(uid);
      email = user.email || null;
    } catch (e) {
      logger.error("auth getUser failed", e);
    }

    const db = admin.firestore();
    const preview =
      `Order ${orderId} — total $${Number(total).toFixed(2)}. ` +
      "We will notify you when it ships.";

    await db
      .collection("users")
      .doc(uid)
      .collection("email_inbox")
      .add({
        title: "Order confirmation",
        preview,
        body: preview,
        kind: "order_confirmation",
        orderId,
        sentToEmail: email,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    const sendgridKey = process.env.SENDGRID_API_KEY;
    const fromEmail = process.env.MAIL_FROM;

    if (sendgridKey && fromEmail && email) {
      try {
        const sgMail = require("@sendgrid/mail");
        sgMail.setApiKey(sendgridKey);
        await sgMail.send({
          to: email,
          from: fromEmail,
          subject: `Your order ${orderId} is confirmed`,
          text: `${preview}\n\nThank you for shopping with us.`,
        });
        logger.info("SendGrid email sent", {orderId});
      } catch (e) {
        logger.error("SendGrid send failed", e);
      }
    } else {
      logger.warn(
        "Email skipped: set SENDGRID_API_KEY and MAIL_FROM on the function, " +
          "or user has no Auth email."
      );
    }

    const userDoc = await db.collection("users").doc(uid).get();
    const fcmToken = userDoc.data()?.fcmToken;
    if (fcmToken) {
      try {
        await admin.messaging().send({
          token: fcmToken,
          notification: {
            title: "Order confirmed",
            body: preview,
          },
          data: {orderId, type: "order_confirmation"},
        });
        logger.info("FCM notification sent", {orderId});
      } catch (e) {
        logger.error("FCM send failed", e);
      }
    }
  }
);

/**
 * Professional Backend Seeder - "One-Click" Database Population.
 * Visit this URL in your browser to seed Firestore with Versace & IKEA products.
 */
exports.seedRealProducts = onRequest({cors: true}, async (req, res) => {
  const db = admin.firestore();
  const products = [
    // --- WOMEN ---
    {
      title: "Medusa '95 Draped Midi Dress",
      brand: "Versace",
      price: 2550,
      categoryId: "women",
      image: "https://images.unsplash.com/photo-1539109132342-8c9df1fb67a0?auto=format&fit=crop&q=80&w=800",
      description: "Iconic Versace draping with Medusa '95 hardware. Expertly crafted in Italy from premium jersey.",
      isTrending: true,
    },
    {
      title: "Barocco Print Silk Shirt",
      brand: "Versace",
      price: 1475,
      categoryId: "women",
      image: "https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&q=80&w=800",
      description: "Classic silk twill shirt featuring the legendary Barocco motif in gold and black.",
      isTrending: false,
    },
    // --- MEN ---
    {
      title: "Barocco Silk Blazer",
      brand: "Versace",
      price: 3200,
      categoryId: "men",
      image: "https://images.unsplash.com/photo-1593032465175-481ac7f4024b?auto=format&fit=crop&q=80&w=800",
      description: "A tailored luxury blazer with intricate Barocco silk patterns and notched lapels.",
      isTrending: true,
    },
    {
      title: "Medusa Plaque Leather Belt",
      brand: "Versace",
      price: 525,
      categoryId: "men",
      image: "https://images.unsplash.com/photo-1624222247344-550fb8ec5021?auto=format&fit=crop&q=80&w=800",
      description: "Smooth calf leather belt with the iconic gold-tone Medusa Biggie hardware.",
      isTrending: false,
    },
    // --- BAGS ---
    {
      title: "La Medusa Mini Bag",
      brand: "Versace",
      price: 1850,
      categoryId: "bags",
      image: "https://images.unsplash.com/photo-1584917033904-491b7e93051b?auto=format&fit=crop&q=80&w=800",
      description: "Crafted from grain leather, featuring the central Medusa head plaque and gold-tone chain.",
      isTrending: true,
    },
    // --- SHOES ---
    {
      title: "Trigreca Sneakers",
      brand: "Versace",
      price: 950,
      categoryId: "shoes",
      image: "https://images.unsplash.com/photo-1542291026-7eec264c274d?auto=format&fit=crop&q=80&w=800",
      description: "The evolution of Versace sneakers, featuring the Greca motif and cork cushioning.",
      isTrending: true,
    },
    // --- JACKETS ---
    {
      title: "Greca Puffer Jacket",
      brand: "Versace",
      price: 2800,
      categoryId: "jackets",
      image: "https://images.unsplash.com/photo-1591047139829-d91aecb6caea?auto=format&fit=crop&q=80&w=800",
      description: "Water-repellent technical down jacket with the all-over Greca signature print.",
      isTrending: true,
    },
    // --- JEWELRY ---
    {
      title: "Medusa Head Pendant Necklace",
      brand: "Versace",
      price: 475,
      categoryId: "jewelry",
      image: "https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?auto=format&fit=crop&q=80&w=800",
      description: "Gold-tone brass necklace featuring the iconic Medusa head pendant.",
      isTrending: false,
    },
    // --- HOME ---
    {
      title: "STOCKHOLM 2025 3-Seat Sofa",
      brand: "IKEA",
      price: 1950,
      categoryId: "home",
      image: "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&q=80&w=800",
      description: "Designer sofa with deep velvet cushions and solid oak legs. Exceptional comfort.",
      isTrending: true,
    },
    // --- BEAUTY ---
    {
      title: "Color Bloom Liquid Blush",
      brand: "Sheglam",
      price: 15.00,
      categoryId: "beauty",
      image: "https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&q=80&w=800",
      description: "Get a natural healthy glow with this long-lasting, sponge-tip liquid blush.",
      isTrending: true,
    },
    // --- CHILDREN ---
    {
      title: "Kids Barocco Print Sweatshirt",
      brand: "Versace",
      price: 350,
      categoryId: "kids",
      image: "https://images.unsplash.com/photo-1519781542704-957ff19eff00?auto=format&fit=crop&q=80&w=800",
      description: "Comfortable and stylish Barocco print sweatshirt for the young fashion enthusiast.",
      isTrending: false,
    },
    // --- FRAGRANCES ---
    {
      title: "Eros Flame Eau de Parfum",
      brand: "Versace",
      price: 110.00,
      categoryId: "fragrances",
      image: "https://images.unsplash.com/photo-1541643600914-78b084683601?auto=format&fit=crop&q=80&w=800",
      description: "For the strong, passionate, self-confident man who is deeply in touch with his emotions.",
      isTrending: true,
    },
  ];

  try {
    const colRef = db.collection("products");
    
    // Clear existing products first for clean seed
    const oldDocs = await colRef.get();
    const deleteBatch = db.batch();
    oldDocs.docs.forEach(doc => deleteBatch.delete(doc.ref));
    await deleteBatch.commit();

    const batch = db.batch();
    products.forEach((p) => {
      const docRef = colRef.doc();
      batch.set(docRef, {
        ...p,
        id: docRef.id,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    });

    await batch.commit();
    res.status(200).send(`Successfully uploaded ${products.length} REAL luxury products to Firestore!`);
  } catch (error) {
    logger.error("Seeding failed", error);
    res.status(500).send("Seeding failed: " + error.message);
  }
});

