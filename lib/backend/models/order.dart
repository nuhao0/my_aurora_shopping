import 'package:cloud_firestore/cloud_firestore.dart';

import 'order_item.dart';

class Order {
  final String id;
  final DateTime createdAt;
  final String status;
  final double total;
  final List<OrderItem> items;

  const Order({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.total,
    required this.items,
  });

  factory Order.fromDoc(
    String id,
    Map<String, dynamic> data,
  ) {
    final ts = data['createdAt'];
    final createdAt = ts is Timestamp
        ? ts.toDate()
        : DateTime.fromMillisecondsSinceEpoch(0);

    final itemsRaw = (data['items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    return Order(
      id: id,
      createdAt: createdAt,
      status: data['status']?.toString() ?? 'processing',
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      items: itemsRaw.map((e) => OrderItem.fromMap(e)).toList(),
    );
  }
}

