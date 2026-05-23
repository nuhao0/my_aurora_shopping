import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taqikrdnawa/backend/providers/auth_provider.dart';
import 'package:taqikrdnawa/backend/cubits/favorites_cubit.dart';
import 'package:taqikrdnawa/backend/blocs/cart/cart_bloc.dart';
import 'package:taqikrdnawa/backend/blocs/cart/cart_event.dart';
import 'package:taqikrdnawa/backend/services/cart_service.dart' as service;
import 'package:taqikrdnawa/backend/models/favorite_item.dart';

class ItemDetailsScreen extends StatefulWidget {
  static const routeName = '/item-details';
  const ItemDetailsScreen({super.key});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  // Demonstrating SetState for local UI state: Quantity counter
  int _quantity = 1; 

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String title = args['title'] ?? 'Item';
    final String image = args['image'] ?? 'https://via.placeholder.com/400';
    final double price = (args['price'] is num) ? (args['price'] as num).toDouble() : 0.0;
    final String heroTag = args['heroTag'] ?? title;
    final String productId = args['productId']?.toString() ?? title;
    final String description = args['description']?.toString() ?? 
        'This is a great product. It has quality materials and a modern design. You will love it — perfect for daily use or as a gift.';

    final auth = context.watch<AuthProvider>();
    final uid = auth.user?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              final isFav = state is FavoritesLoaded && state.isFavorite(productId);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.pink : null,
                ),
                onPressed: () {
                  if (uid != null) {
                    context.read<FavoritesCubit>().toggleFavorite(
                      uid,
                      FavoriteItem(
                        productId: productId,
                        title: title,
                        image: image,
                        price: price,
                        category: args['category']?.toString() ?? 'general',
                      ),
                    );
                  }
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.of(context).pushNamed('/cart'),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: heroTag,
            child: Image.network(
              image,
              height: 320,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                // Quantity selector using SetState
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => setState(() => _quantity = (_quantity > 1) ? _quantity - 1 : 1),
                    ),
                    Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() => _quantity++),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '\$${price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(description),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: uid == null ? null : () {
                  context.read<CartBloc>().add(AddItemToCart(
                    uid,
                    service.CartItem(
                      productId: productId,
                      title: title,
                      image: image,
                      price: price,
                      quantity: _quantity,
                    ),
                  ));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added $_quantity items to cart')),
                  );
                },
                child: const Text('Add to cart'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
