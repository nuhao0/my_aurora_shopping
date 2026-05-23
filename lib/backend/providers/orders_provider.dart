import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:taqikrdnawa/backend/models/order.dart' as app_order;
import 'package:taqikrdnawa/backend/models/order_item.dart';

class OrdersProvider with ChangeNotifier {
  OrdersProvider({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance {
    _authSub = _auth.authStateChanges().listen((user) {
      _uid = user?.uid;
      _listenToOrders();
    });
  }

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  StreamSubscription<User?>? _authSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _ordersSub;

  String? _uid;
  final List<app_order.Order> _orders = [];

  List<app_order.Order> get orders => List.unmodifiable(_orders);

  void _listenToOrders() {
    _ordersSub?.cancel();
    _orders.clear();
    notifyListeners();
    if (_uid == null) return;

    _ordersSub = _firestore
        .collection('users')
        .doc(_uid)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snap) {
      _orders
        ..clear()
        ..addAll(snap.docs.map((d) => app_order.Order.fromDoc(d.id, d.data())));
      notifyListeners();
    });
  }

  Future<String?> placeOrder({
    required List<OrderItem> items,
    required double total,
    required String? notes,
  }) async {
    if (_uid == null) return null;
    if (items.isEmpty) return null;

    final orderRef = _firestore
        .collection('users')
        .doc(_uid)
        .collection('orders')
        .doc();

    await orderRef.set({
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'processing',
      'total': total,
      'notes': notes ?? '',
      'items': items.map((e) => e.toMap()).toList(),
    });

    // Also create a notification so the user sees it.
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('notifications')
        .doc(orderRef.id)
        .set({
      'title': 'Order placed',
      'body': 'Your order is processing. Total: \$${total.toStringAsFixed(2)}',
      'createdAt': FieldValue.serverTimestamp(),
      'read': false,
      'type': 'order_placed',
    });

    return orderRef.id;
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _ordersSub?.cancel();
    super.dispose();
  }
}

