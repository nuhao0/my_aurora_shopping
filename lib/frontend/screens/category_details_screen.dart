import 'package:flutter/material.dart';

import 'package:taqikrdnawa/backend/firebase/firestore_paths.dart';
import 'package:taqikrdnawa/backend/models/product.dart';
import 'package:taqikrdnawa/backend/services/firestore_catalog_service.dart';
import 'item_details_screen.dart';

class CategoryDetailsScreen extends StatefulWidget {
  static const routeName = '/category-details';

  const CategoryDetailsScreen({super.key});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  final FirestoreCatalogService _catalog = FirestoreCatalogService();

  @override
  Widget build(BuildContext context) {
    // Get arguments once
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final categoryId = args != null ? args['id'] as String : 'general';
    final categoryName = args != null ? args['name'] as String : 'Category';

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: StreamBuilder<List<Product>>(
        stream: _catalog.streamByCategoryId(categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => setState(() {}),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No products in this category yet.\n\n'
                  'Add documents in Firebase Console → Firestore → collection '
                  '"${FirestorePaths.products}".\n\n'
                  'Each document needs: title, image (photo URL), price (number), '
                  'description (optional), and categoryId = "$categoryId" '
                  '(exactly this code for this shelf).',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2 / 3,
            ),
            itemBuilder: (ctx, i) {
              final p = products[i];
              final heroTag = 'cat_${categoryId}_${p.id}';

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ItemDetailsScreen.routeName,
                    arguments: {
                      'title': p.title,
                      'image': p.image,
                      'price': p.price,
                      'heroTag': heroTag,
                      'productId': p.id.toString(),
                      'category': p.category,
                      'description': p.description,
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
                            p.image,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, error, stackTrace) => Container(
                              color: Colors.grey[200],
                              alignment: Alignment.center,
                              child: const Icon(Icons.style_outlined,
                                  color: Colors.grey, size: 40),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      p.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '\$${p.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
