import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:taqikrdnawa/backend/models/product.dart';
import 'package:taqikrdnawa/backend/providers/product_provider.dart';
import 'item_details_screen.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  List<Product> results = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<ProductProvider>();
      if (provider.items.isEmpty) {
        await provider.fetchProducts();
      }
    });
  }

  void _doSearch(String query) {
    query = query.toLowerCase().trim();
    final products = context.read<ProductProvider>().items;
    setState(() {
      if (query.isEmpty) {
        results = [];
        return;
      }
      results = products
          .where((p) => p.title.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = context.watch<ProductProvider>();
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          onChanged: _doSearch,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: productsProvider.isLoading && results.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : results.isEmpty
              ? const Center(
                  child: Text(
                    'Type to search',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (ctx, i) {
                    final item = results[i];
                    return ListTile(
                      leading: Image.network(
                        item.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item.title),
                      subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          ItemDetailsScreen.routeName,
                          arguments: {
                            'title': item.title,
                            'image': item.image,
                            'price': item.price,
                            'heroTag': 'search_item_${item.id}',
                            'productId': item.id.toString(),
                            'category': item.category,
                            'description': item.description,
                          },
                        );
                      },
                    );
                  },
                ),
    );
  }
}
