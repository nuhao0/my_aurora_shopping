import 'package:flutter/material.dart';
import 'category_details_screen.dart';

class Category {
  final String id;
  final String name;
  final String image;

  Category({required this.id, required this.name, required this.image});
}

class CategoryScreen extends StatelessWidget {
  static const routeName = '/category';

  CategoryScreen({super.key});

  final List<Category> categories = [
    Category(
      id: 'women',
      name: 'Women',
      image: 'https://images.pexels.com/photos/2983464/pexels-photo-2983464.jpeg',
    ),
    Category(
      id: 'men',
      name: 'Men',
      image: 'https://images.pexels.com/photos/2983462/pexels-photo-2983462.jpeg',
    ),
    Category(
      id: 'kids',
      name: 'Kids',
      image: 'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg',
    ),
    Category(
      id: 'shoes',
      name: 'Shoes',
      image: 'https://images.pexels.com/photos/2529148/pexels-photo-2529148.jpeg',
    ),
    Category(
      id: 'accessories',
      name: 'Accessories',
      image: 'https://images.pexels.com/photos/298863/pexels-photo-298863.jpeg',
    ),
    Category(
      id: 'glasses',
      name: 'Glasses',
      image: 'https://images.pexels.com/photos/46710/pexels-photo-46710.jpeg',
    ),
    Category(
      id: 'bags',
      name: 'Bags',
      image: 'https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg',
    ),
    Category(
      id: 'jackets',
      name: 'Jackets',
      image: 'https://images.pexels.com/photos/428340/pexels-photo-428340.jpeg',
    ),
    Category(
      id: 'beauty',
      name: 'Beauty',
      image: 'https://images.pexels.com/photos/1459376/pexels-photo-1459376.jpeg',
    ),
    Category(
      id: 'home',
      name: 'Home',
      image: 'https://images.pexels.com/photos/271680/pexels-photo-271680.jpeg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.purple,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 3 / 4,
        ),
        itemBuilder: (ctx, i) {
          final cat = categories[i];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                CategoryDetailsScreen.routeName,
                arguments: {'id': cat.id, 'name': cat.name},
              );
            },
            child: Hero(
              tag: 'category_${cat.id}',
              child: Material(
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        cat.image,
                        fit: BoxFit.cover,
                      ),
                      Container(color: Colors.black26),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            cat.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
