import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:taqikrdnawa/backend/models/order.dart';
import 'package:taqikrdnawa/backend/providers/orders_provider.dart';

class OrderHistoryScreen extends StatelessWidget {
  static const routeName = '/order-history';
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersProvider = context.watch<OrdersProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: ordersProvider.orders.isEmpty
          ? const Center(child: Text('No orders yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: ordersProvider.orders.length,
              itemBuilder: (ctx, i) {
                final order = ordersProvider.orders[i];
                return _OrderCard(order: order);
              },
            ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(
          'Order ${order.id.substring(0, order.id.length > 6 ? 6 : order.id.length)}',
        ),
        subtitle: Text(
          '${order.status} • \$${order.total.toStringAsFixed(2)}',
        ),
        children: [
          ...order.items.map((it) {
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  it.image,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(it.title),
              subtitle: Text('x${it.quantity} • \$${it.price.toStringAsFixed(2)}'),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Placed: ${order.createdAt.toLocal()}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          )
        ],
      ),
    );
  }
}

