import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taqikrdnawa/backend/providers/auth_provider.dart';
import 'package:taqikrdnawa/backend/blocs/cart/cart_bloc.dart';
import 'package:taqikrdnawa/backend/blocs/cart/cart_event.dart';
import 'package:taqikrdnawa/backend/blocs/cart/cart_state.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';
  final bool isStandalone;
  
  const CartScreen({super.key, this.isStandalone = true});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    if (auth.user != null) {
      context.read<CartBloc>().add(LoadCart(auth.user!.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final uid = auth.user?.uid;

    final bodyContent = BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CartError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        if (state is CartLoaded) {
          final items = state.items;
          if (items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (ctx, i) {
                    final it = items[i];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(it.image,
                            width: 56, height: 56, fit: BoxFit.cover),
                      ),
                      title: Text(it.title),
                      subtitle: Text(
                          '\$${(it.price * it.quantity).toStringAsFixed(2)} • x${it.quantity}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (uid != null) {
                                context.read<CartBloc>().add(UpdateCartQuantity(
                                    uid, it.productId, it.quantity - 1));
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () {
                              if (uid != null) {
                                context.read<CartBloc>().add(
                                    RemoveItemFromCart(uid, it.productId));
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('\$${state.total.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(CheckoutScreen.routeName);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Proceed to Checkout'),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        }
        return const Center(child: Text('Please login to view cart'));
      },
    );

    if (!widget.isStandalone) {
      return bodyContent;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: bodyContent,
    );
  }
}
