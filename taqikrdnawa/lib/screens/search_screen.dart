import 'package:flutter/material.dart';
import 'item_details_screen.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  // Products with all info
  final List<Map<String, dynamic>> allProducts = [
    {
      'title': 'Red Dress',
      'image': 'https://images.pexels.com/photos/2983464/pexels-photo-2983464.jpeg',
      'price': 49.99,
      'category': 'women',
    },
    {
      'title': 'Blue Jeans',
      'image': 'https://images.pexels.com/photos/2529148/pexels-photo-2529148.jpeg',
      'price': 59.99,
      'category': 'men',
    },
    {
      'title': 'Sneakers',
      'image': 'https://images.pexels.com/photos/2529148/pexels-photo-2529148.jpeg',
      'price': 69.99,
      'category': 'shoes',
    },
    {
      'title': 'High Heels',
      'image': 'https://images.pexels.com/photos/298863/pexels-photo-298863.jpeg',
      'price': 79.99,
      'category': 'women',
    },
    {
      'title': 'Lipstick',
      'image': 'https://images.pexels.com/photos/1459376/pexels-photo-1459376.jpeg',
      'price': 19.99,
      'category': 'beauty',
    },
    {
      'title': 'Foundation',
      'image': 'https://images.pexels.com/photos/1459376/pexels-photo-1459376.jpeg',
      'price': 29.99,
      'category': 'beauty',
    },
    {
      'title': 'Baby Dress',
      'image': 'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg',
      'price': 24.99,
      'category': 'kids',
    },
    {
      'title': 'Winter Coat',
      'image': 'https://images.pexels.com/photos/428340/pexels-photo-428340.jpeg',
      'price': 89.99,
      'category': 'jackets',
    },
  ];

  // Correct type for search results
  List<Map<String, dynamic>> results = [];

  void _doSearch(String query) {
    query = query.toLowerCase();
    setState(() {
      results = allProducts
          .where((product) =>
          product['title'].toString().toLowerCase().contains(query))
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
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
      body: results.isEmpty
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
              item['image'],
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(item['title']),
            subtitle:
            Text('\$${(item['price'] as double).toStringAsFixed(2)}'),
            onTap: () {
              Navigator.of(context).pushNamed(
                ItemDetailsScreen.routeName,
                arguments: {
                  'title': item['title'],
                  'image': item['image'],
                  'price': item['price'],
                  'heroTag': 'search_item_$i',
                },
              );
            },
          );
        },
      ),
    );
  }
}
