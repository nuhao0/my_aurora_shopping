import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taqikrdnawa/backend/blocs/cart/cart_bloc.dart';
import 'package:taqikrdnawa/backend/blocs/cart/cart_state.dart';
import 'package:taqikrdnawa/backend/blocs/cart/cart_event.dart';
import 'package:taqikrdnawa/backend/providers/auth_provider.dart';
import 'package:taqikrdnawa/backend/providers/orders_provider.dart';
import 'package:taqikrdnawa/backend/models/order_item.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = '/checkout';
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String cardHolder = '';
  String expiryDate = '';
  String cvv = '';

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final orders = context.read<OrdersProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is! CartLoaded) {
            return const Center(child: Text('No items to checkout'));
          }

          final cartItems = state.items;
          final total = state.total;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const Text(
                        'Your Cart',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ...cartItems.map((item) => ListTile(
                            leading: Image.network(
                              item.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(item.title),
                            subtitle: Text('x${item.quantity}'),
                            trailing: Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                          )),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('\$${total.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Payment Info',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Card Number', hintText: 'XXXX XXXX XXXX XXXX'),
                              keyboardType: TextInputType.number,
                              onSaved: (val) => cardNumber = val!,
                              validator: (val) {
                                if (val == null || val.isEmpty || val.length < 16) return 'Enter valid card number';
                                return null;
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Card Holder Name'),
                              onSaved: (val) => cardHolder = val!,
                              validator: (val) {
                                if (val == null || val.isEmpty) return 'Enter card holder name';
                                return null;
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Expiry Date', hintText: 'MM/YY'),
                              keyboardType: TextInputType.datetime,
                              onSaved: (val) => expiryDate = val!,
                              validator: (val) {
                                if (val == null || val.isEmpty) return 'Enter expiry date';
                                return null;
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'CVV'),
                              keyboardType: TextInputType.number,
                              obscureText: true,
                              onSaved: (val) => cvv = val!,
                              validator: (val) {
                                if (val == null || val.isEmpty || val.length < 3) return 'Enter valid CVV';
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (!_formKey.currentState!.validate()) return;
                                  _formKey.currentState!.save();

                                  if (!auth.isAuthenticated) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please log in first.')));
                                    return;
                                  }

                                  try {
                                    final orderItems = cartItems
                                        .map((e) => OrderItem(
                                              productId: e.productId,
                                              title: e.title,
                                              image: e.image,
                                              price: e.price,
                                              quantity: e.quantity,
                                            ))
                                        .toList();

                                    final orderId = await orders.placeOrder(
                                      items: orderItems,
                                      total: total,
                                      notes: 'Paid by card (demo). Holder: $cardHolder',
                                    );

                                    if (orderId != null) {
                                      // Clear cart in BLoC
                                      context.read<CartBloc>().add(ClearCartItems(auth.user!.uid));
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(content: Text('Order placed successfully!')));
                                      Navigator.of(context).pop();
                                    } else {
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order failed')));
                                    }
                                  } catch (e) {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order failed: $e')));
                                  }
                                },
                                child: const Text('Pay Now'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
