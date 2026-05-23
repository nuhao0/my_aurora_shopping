import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:taqikrdnawa/backend/firebase/firestore_paths.dart';
import 'package:taqikrdnawa/backend/models/product.dart';

/// Loads the storefront catalog from Firestore `products` (your real data).
///
/// Each document should include:
/// - `title` (string), `image` (URL string), `price` (number),
/// - `description` (string, optional),
/// - `categoryId` (string) — must match [FirestorePaths.storefrontCategoryIds].
class FirestoreCatalogService {
  FirestoreCatalogService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  Future<List<Product>> fetchByCategoryId(String categoryId) async {
    final snap = await _db
        .collection(FirestorePaths.products)
        .where('categoryId', isEqualTo: categoryId)
        .limit(120)
        .get();

    final list = snap.docs
        .map((d) => Product.fromFirestore(d.id, d.data()))
        .toList()
      ..sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    return list;
  }

  Future<List<Product>> fetchAll({int limit = 200}) async {
    final snap =
        await _db.collection(FirestorePaths.products).limit(limit).get();
    final list = snap.docs
        .map((d) => Product.fromFirestore(d.id, d.data()))
        .toList()
      ..sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    return list;
  }

  Stream<List<Product>> streamAll({int limit = 200}) {
    return _db
        .collection(FirestorePaths.products)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => Product.fromFirestore(d.id, d.data()))
            .toList()
          ..sort(
              (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase())));
  }

  Stream<List<Product>> streamByCategoryId(String categoryId) {
    return _db
        .collection(FirestorePaths.products)
        .where('categoryId', isEqualTo: categoryId)
        .limit(120)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => Product.fromFirestore(d.id, d.data()))
            .toList()
          ..sort(
              (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase())));
  }

  Future<List<Product>> getTrendingProducts({int limit = 10}) async {
    final snap = await _db
        .collection(FirestorePaths.products)
        .where('isTrending', isEqualTo: true)
        .limit(limit)
        .get();
    return snap.docs
        .map((d) => Product.fromFirestore(d.id, d.data()))
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final snap = await _db.collection(FirestorePaths.categories).get();
    return snap.docs.map((d) {
      final data = d.data();
      return {
        'id': d.id,
        'name': data['name'] ?? 'Unknown',
        'image': data['image'] ?? '',
      };
    }).toList();
  }
}

