import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taqikrdnawa/backend/firebase/firestore_paths.dart';
import 'cart_service.dart';

class OrderModel {
  final String id;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final List<CartItem> items;

  OrderModel({
    required this.id,
    required this.totalAmount,
    this.status = 'Pending',
    required this.createdAt,
    required this.items,
  });

  factory OrderModel.fromMap(String id, Map<String, dynamic> map) {
    return OrderModel(
      id: id,
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] ?? 'Pending',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      items: (map['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromMap(
                  item['productId'] ?? '', item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalAmount': totalAmount,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
      'items': items.map((e) => {
            'productId': e.productId,
            'title': e.title,
            'price': e.price,
            'quantity': e.quantity,
            'image': e.image,
          }).toList(),
    };
  }
}

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder(String uid, OrderModel order) async {
    final docRef = _firestore.collection(FirestorePaths.userOrders(uid)).doc();
    await docRef.set(order.toMap(), SetOptions(merge: true));
    
    // Optionally: Clear cart after placing order
    // final cartItems = await _firestore.collection('users/$uid/cart').get();
    // for (var doc in cartItems.docs) {
    //   await doc.reference.delete();
    // }
  }

  Stream<List<OrderModel>> getOrderHistory(String uid) {
    return _firestore
        .collection(FirestorePaths.userOrders(uid))
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => OrderModel.fromMap(doc.id, doc.data()))
            .toList());
  }
}
