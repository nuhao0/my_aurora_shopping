import 'package:flutter/material.dart';
import 'item_details_screen.dart';

class CategoryDetailsScreen extends StatelessWidget {
  static const routeName = '/category-details';

  const CategoryDetailsScreen({super.key});

  List<Map<String, dynamic>> _itemsFor(String categoryId) {
    final Map<String, List<Map<String, dynamic>>> categoryItems = {
      'women': [
        {
          'title': 'Floral Dress',
          'image': 'https://images.pexels.com/photos/2983464/pexels-photo-2983464.jpeg',
          'price': 49.99
        },
        {
          'title': 'Summer Top',
          'image': 'https://images.pexels.com/photos/298863/pexels-photo-298863.jpeg',
          'price': 29.99
        },
      ],
      'men': [
        {
          'title': 'Casual Shirt',
          'image': 'https://images.pexels.com/photos/2983462/pexels-photo-2983462.jpeg',
          'price': 39.99
        },
        {
          'title': 'Jeans',
          'image': 'https://images.pexels.com/photos/2529148/pexels-photo-2529148.jpeg',
          'price': 59.99
        },
      ],
      'kids': [
        {
          'title': 'Kids T-Shirt',
          'image': 'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg',
          'price': 19.99
        },
        {
          'title': 'Kids Shorts',
          'image': 'https://images.pexels.com/photos/46710/pexels-photo-46710.jpeg',
          'price': 24.99
        },
      ],
      'shoes': [
        {
          'title': 'Running Shoes',
          'image': 'https://images.pexels.com/photos/2529148/pexels-photo-2529148.jpeg',
          'price': 59.99
        },
      ],
      'accessories': [
        {
          'title': 'Watch',
          'image': 'https://images.pexels.com/photos/298863/pexels-photo-298863.jpeg',
          'price': 49.99
        },
      ],
      'glasses': [
        {
          'title': 'Sunglasses',
          'image': 'https://images.pexels.com/photos/46710/pexels-photo-46710.jpeg',
          'price': 19.99
        },
      ],
      'bags': [
        {
          'title': 'Leather Bag',
          'image': 'https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg',
          'price': 79.99
        },
      ],
      'jackets': [
        {
          'title': 'Leather Jacket',
          'image': 'https://images.pexels.com/photos/428340/pexels-photo-428340.jpeg',
          'price': 89.99
        },
      ],
      'beauty': [
        {
          'title': 'Perfume',
          'image': 'https://images.pexels.com/photos/1459376/pexels-photo-1459376.jpeg',
          'price': 59.99
        },
      ],
      'home': [
        {
          'title': 'Sofa Pillow',
          'image': 'https://images.pexels.com/photos/271680/pexels-photo-271680.jpeg',
          'price': 15.50
        },
        {
          'title': 'Decor Lamp',
          'image': 'https://images.pexels.com/photos/1459376/pexels-photo-1459376.jpeg',
          'price': 35.00
        },
      ],
    };

    return categoryItems[categoryId] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final categoryId = args != null ? args['id'] as String : 'general';
    final categoryName = args != null ? args['name'] as String : 'Category';

    final items = _itemsFor(categoryId);

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: Colors.purple,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2 / 3,
        ),
        itemBuilder: (ctx, i) {
          final item = items[i];
          final heroTag = 'item_${categoryId}_$i';
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ItemDetailsScreen.routeName,
                arguments: {
                  'title': item['title'],
                  'image': item['image'],
                  'price': item['price'],
                  'heroTag': heroTag,
                },
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Hero(
                    tag: heroTag,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item['image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item['title'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '\$${(item['price'] as double).toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
