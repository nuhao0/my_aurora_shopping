import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String productId;
  final String title;
  final String image;
  final double price;
  final int quantity;

  CartItem({
    required this.productId,
    required this.title,
    required this.image,
    required this.price,
    this.quantity = 1,
  });

  factory CartItem.fromMap(String id, Map<String, dynamic> map) {
    return CartItem(
      productId: id,
      title: map['title'] ?? '',
      image: map['image'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
      'price': price,
      'quantity': quantity,
    };
  }
}

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _cartPath(String uid) => 'users/$uid/cart';

  Future<void> addToCart(String uid, CartItem item) async {
    final docRef = _firestore.collection(_cartPath(uid)).doc(item.productId);
    final doc = await docRef.get();

    if (doc.exists) {
      final currentQuantity = (doc.data()?['quantity'] as num?)?.toInt() ?? 0;
      await docRef.update({'quantity': currentQuantity + item.quantity});
    } else {
      await docRef.set(item.toMap(), SetOptions(merge: true));
    }
  }

  Future<void> removeFromCart(String uid, String productId) async {
    await _firestore.collection(_cartPath(uid)).doc(productId).delete();
  }

  Future<void> updateQuantity(String uid, String productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(uid, productId);
    } else {
      await _firestore
          .collection(_cartPath(uid))
          .doc(productId)
          .update({'quantity': quantity});
    }
  }

  Stream<List<CartItem>> getUserCart(String uid) {
    return _firestore.collection(_cartPath(uid)).snapshots().map(
          (snap) => snap.docs
              .map((doc) => CartItem.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> clearCart(String uid) async {
    final batch = _firestore.batch();
    final collection = await _firestore.collection(_cartPath(uid)).get();
    for (final doc in collection.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
