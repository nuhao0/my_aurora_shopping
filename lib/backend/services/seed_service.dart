import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../firebase/firestore_paths.dart';
import 'image_fetcher_service.dart';

class SeedService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImageFetcherService _imageFetcher = ImageFetcherService();

  /// Professional Category Mapper for DummyJSON -> App Categories
  final Map<String, String> _categoryMapper = {
    'mens-shirts': 'men',
    'mens-shoes': 'shoes',
    'mens-watches': 'accessories',
    'womens-dresses': 'women',
    'womens-shoes': 'shoes',
    'womens-watches': 'accessories',
    'womens-bags': 'bags',
    'womens-jewellery': 'accessories',
    'beauty': 'beauty',
    'fragrances': 'beauty',
    'skin-care': 'beauty',
    'furniture': 'home',
    'home-decoration': 'home',
    'sunglasses': 'glasses',
    'tops': 'women',
  };

  /// Luxury Brand Mapper to maintain the premium feel
  final Map<String, String> _brandMapper = {
    'mens-shirts': 'Polo Ralph Lauren',
    'mens-shoes': 'Dior',
    'mens-watches': 'Cartier',
    'womens-dresses': 'Versace',
    'womens-shoes': 'Christian Dior',
    'womens-watches': 'Bulgari',
    'womens-bags': 'Louis Vuitton',
    'womens-jewellery': 'Cartier',
    'beauty': 'Lancôme',
    'fragrances': 'Chanel',
    'skin-care': 'Dior Beauty',
    'furniture': 'IKEA',
    'home-decoration': 'IKEA Premium',
    'sunglasses': 'Prada',
    'tops': 'Gucci',
  };

  Future<void> seedDatabase() async {
    debugPrint('Checking database status...');
    final collection = _firestore.collection(FirestorePaths.products);
    final currentDocs = await collection.get();

    // PERFORMANCE OPTIMIZATION: Skip if already seeded (non-debug). 
    if (currentDocs.docs.isNotEmpty && !kDebugMode) {
      debugPrint('Database already contains ${currentDocs.size} products. Skipping seed for speed.');
      return;
    }

    try {
      debugPrint('Fetching real-world data from External API (DummyJSON)...');
      // Fetch ALL available products to ensure no category is missed
      final response = await http.get(Uri.parse('https://dummyjson.com/products?limit=0'));
      
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch from API: ${response.statusCode}');
      }

      final data = json.decode(response.body);
      final List apiProducts = data['products'];
      
      debugPrint('Successfully fetched ${apiProducts.length} items from DummyJSON. Processing...');

      // Step 0: Clear existing products in Debug Mode for fresh update
      if (currentDocs.docs.isNotEmpty) {
        final deleteBatch = _firestore.batch();
        for (var doc in currentDocs.docs) {
          deleteBatch.delete(doc.reference);
        }
        await deleteBatch.commit();
        debugPrint('Old cache purged for full API synchronization.');
      }

      final batch = _firestore.batch();
      int uploadedCount = 0;

      // 1. Process API Products
      for (var apiItem in apiProducts) {
        final apiCategory = apiItem['category'] as String;
        if (!_categoryMapper.containsKey(apiCategory)) continue;

        final categoryId = _categoryMapper[apiCategory]!;
        final brand = _brandMapper[apiCategory] ?? 'Designer';
        
        final docRef = collection.doc('api_seed_v3_${apiItem['id']}');
        
        batch.set(docRef, {
          'id': docRef.id,
          'title': apiItem['title'],
          'price': (apiItem['price'] as num).toDouble(),
          'categoryId': categoryId,
          'brand': brand,
          'description': apiItem['description'],
          'image': apiItem['thumbnail'], // High-reliability CDN URL
          'isTrending': (apiItem['rating'] as num) > 4.5,
          'isOffer': (apiItem['discountPercentage'] as num) > 15,
          'createdAt': FieldValue.serverTimestamp(),
          'originalApiId': apiItem['id'],
        });
        uploadedCount++;
      }

      // 2. Add Hand-Picked Kids items (Verified Unsplash)
      final kidsItems = [
        {'title': 'Gap Kids Denim Jacket', 'price': 45.0, 'brand': 'Gap Kids', 'description': 'Durable denim jacket for play and style.'},
        {'title': 'Carter\'s Cotton Onesie', 'price': 20.0, 'brand': 'Carter\'s', 'description': 'Soft organic cotton for baby\'s comfort.'},
        {'title': 'Gap Kids Khaki Pants', 'price': 35.0, 'brand': 'Gap Kids', 'description': 'Versatile khakis for school or outings.'},
        {'title': 'Designer Velvet Dress', 'price': 85.0, 'brand': 'Dior Kids', 'description': 'Elegant velvet for special occasions.'},
      ];

      for (var i = 0; i < kidsItems.length; i++) {
        final item = kidsItems[i];
        final imageUrl = await _imageFetcher.getDirectImageUrl('kids', lock: i);
        final docRef = collection.doc('manual_kids_v4_$i');
        
        batch.set(docRef, {
          ...item,
          'id': docRef.id,
          'categoryId': 'kids',
          'image': imageUrl,
          'isTrending': i % 2 == 0,
          'isOffer': i % 3 == 0,
          'createdAt': FieldValue.serverTimestamp(),
        });
        uploadedCount++;
      }

      // 3. Add Hand-Picked Jackets (Since DummyJSON lacks a dedicated category)
      final jacketItems = [
        {'title': 'Polo Puffer Jacket', 'price': 295.0, 'brand': 'Polo Ralph Lauren', 'description': 'Water-repellent down jacket with heritage style.'},
        {'title': 'Versace Silk Bomber', 'price': 2100.0, 'brand': 'Versace', 'description': 'Baroque-print luxury bomber jacket.'},
        {'title': 'Dior Oblique Parka', 'price': 3200.0, 'brand': 'Christian Dior', 'description': 'Technical canvas with iconic Dior motif.'},
        {'title': 'Chanel Tweed Cardigan-Jacket', 'price': 4500.0, 'brand': 'Chanel', 'description': 'The ultimate symbol of luxury fashion.'},
      ];

      for (var i = 0; i < jacketItems.length; i++) {
        final item = jacketItems[i];
        final imageUrl = await _imageFetcher.getDirectImageUrl('jackets', lock: i);
        final docRef = collection.doc('manual_jackets_v4_$i');
        
        batch.set(docRef, {
          ...item,
          'id': docRef.id,
          'categoryId': 'jackets',
          'image': imageUrl,
          'isTrending': true,
          'isOffer': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
        uploadedCount++;
      }

      await batch.commit();
      debugPrint('External API Seed complete! $uploadedCount items live in Firestore (v4).');

    } catch (e) {
      debugPrint('CRITICAL ERROR during seeding: $e');
      // Fallback to manual seed if API fails? 
      // For now, let the user know.
    }
  }

  Future<void> refreshProductImages() async {
    // Legacy refresh logic - basically deprecated by API integration
    debugPrint('Refresh logic is handled automatically by API Re-Seed.');
  }
}

