import 'package:flutter/material.dart';
import 'category_details_screen.dart';

import 'package:taqikrdnawa/backend/services/firestore_catalog_service.dart';

class Category {
  final String id;
  final String name;
  final String image;

  Category({required this.id, required this.name, required this.image});
}

class CategoryScreen extends StatefulWidget {
  static const routeName = '/category';
  final bool isStandalone;

  const CategoryScreen({super.key, this.isStandalone = true});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final FirestoreCatalogService _catalog = FirestoreCatalogService();
  bool _isLoading = true;
  List<Category> _categories = [];

  final List<Category> _defaultCategories = [
    Category(
      id: 'women',
      name: 'Women',
      image: 'https://images.pexels.com/photos/2983464/pexels-photo-2983464.jpeg',
    ),
    Category(
      id: 'men',
      name: 'Men',
      image: 'https://images.pexels.com/photos/1043474/pexels-photo-1043474.jpeg',
    ),
    Category(
      id: 'kids',
      name: 'Kids',
      image: 'https://images.pexels.com/photos/1620760/pexels-photo-1620760.jpeg', // Kid wearing clothes
    ),
    Category(
      id: 'shoes',
      name: 'Shoes',
      image: 'https://images.pexels.com/photos/2529148/pexels-photo-2529148.jpeg',
    ),
    Category(
      id: 'accessories',
      name: 'Accessories',
      image: 'https://images.pexels.com/photos/1453008/pexels-photo-1453008.jpeg',
    ),
    Category(
      id: 'glasses',
      name: 'Glasses',
      image: 'https://images.pexels.com/photos/46710/pexels-photo-46710.jpeg',
    ),
    Category(
      id: 'bags',
      name: 'Bags',
      image: 'https://images.pexels.com/photos/904350/pexels-photo-904350.jpeg',
    ),
    Category(
      id: 'jackets',
      name: 'Jackets',
      image: 'https://images.pexels.com/photos/1183266/pexels-photo-1183266.jpeg', // People wearing jackets
    ),
    Category(
      id: 'beauty',
      name: 'Beauty',
      image: 'https://images.pexels.com/photos/1722868/pexels-photo-1722868.jpeg',
    ),
    Category(
      id: 'home',
      name: 'Home',
      image: 'https://images.pexels.com/photos/6692140/pexels-photo-6692140.jpeg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final data = await _catalog.fetchCategories();
      if (data.isNotEmpty) {
        setState(() {
          _categories = data
              .map((e) => Category(
                  id: e['id'],
                  name: e['name']?.toString() ?? 'Unknown',
                  image: e['image']?.toString() ?? ''))
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _categories = _defaultCategories;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _categories = _defaultCategories;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bodyContent = _isLoading
        ? const Center(child: CircularProgressIndicator())
        : GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 3 / 4,
            ),
            itemBuilder: (ctx, i) {
              final cat = _categories[i];
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
                            errorBuilder: (ctx, error, stackTrace) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, size: 50),
                            ),
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
          );

    if (!widget.isStandalone) {
      return bodyContent;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: bodyContent,
    );
  }
}
