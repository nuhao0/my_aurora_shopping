import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:taqikrdnawa/backend/providers/product_provider.dart';
import 'item_details_screen.dart';

class TrendsScreen extends StatelessWidget {
  static const routeName = '/trends';
  final bool isStandalone;
  
  const TrendsScreen({super.key, this.isStandalone = true});

  @override
  Widget build(BuildContext context) {
    final productsProvider = context.watch<ProductProvider>();

    final women =
        productsProvider.items.where((p) => p.category == 'women').toList();
    final men =
        productsProvider.items.where((p) => p.category == 'men').toList();

    final bodyContent = productsProvider.isLoading && productsProvider.items.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(12),
            children: [
              const Text(
                'Women Trends 2026',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _TrendRow(
                items: women,
                emptyLabel: 'No women trending items yet',
              ),
              const SizedBox(height: 18),
              const Text(
                'Men Trends 2026',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _TrendRow(
                items: men,
                emptyLabel: 'No men trending items yet',
              ),
              const SizedBox(height: 60),
            ],
          );

    if (!isStandalone) {
      return bodyContent;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Trends 2026')),
      body: bodyContent,
    );
  }
}

class _TrendRow extends StatelessWidget {
  final List<dynamic> items;
  final String emptyLabel;

  const _TrendRow({
    required this.items,
    required this.emptyLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Text(emptyLabel),
      );
    }

    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length.clamp(0, 10),
        itemBuilder: (ctx, i) {
          final p = items[i];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 12),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ItemDetailsScreen.routeName,
                    arguments: {
                      'title': p.title,
                      'image': p.image,
                      'price': p.price,
                      'heroTag': 'trend_${p.id}',
                      'productId': p.id.toString(),
                      'category': p.category,
                      'description': p.description,
                    },
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        p.image,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        p.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '\$${p.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
