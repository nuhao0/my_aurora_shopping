import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taqikrdnawa/backend/providers/auth_provider.dart';
import 'package:taqikrdnawa/backend/cubits/favorites_cubit.dart';
import 'package:taqikrdnawa/backend/blocs/cart/cart_bloc.dart';
import 'package:taqikrdnawa/backend/blocs/cart/cart_event.dart';
import 'package:taqikrdnawa/backend/services/cart_service.dart' as service;
import 'item_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  static const routeName = '/favorites';
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    if (auth.user != null) {
      context.read<FavoritesCubit>().loadFavorites(auth.user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final uid = auth.user?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FavoritesError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is FavoritesLoaded) {
            final favorites = state.favorites;
            if (favorites.isEmpty) {
              return const Center(child: Text('No favorites yet'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favorites.length,
              itemBuilder: (ctx, i) {
                final item = favorites[i];
                return Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.image,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(item.title),
                    subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.pink),
                      onPressed: () {
                        if (uid != null) {
                          context.read<FavoritesCubit>().toggleFavorite(uid, item);
                        }
                      },
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        ItemDetailsScreen.routeName,
                        arguments: {
                          'title': item.title,
                          'image': item.image,
                          'price': item.price,
                          'heroTag': 'fav_${item.productId}',
                          'productId': item.productId,
                        },
                      );
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Please login to view favorites'));
        },
      ),
      bottomNavigationBar: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoaded && state.favorites.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (uid != null) {
                      for (final f in state.favorites) {
                        context.read<CartBloc>().add(AddItemToCart(
                              uid,
                              service.CartItem(
                                productId: f.productId,
                                title: f.title,
                                image: f.image,
                                price: f.price,
                                quantity: 1,
                              ),
                            ));
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added favorites to cart')),
                      );
                    }
                  },
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Add favorites to cart'),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
