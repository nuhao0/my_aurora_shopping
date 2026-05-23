import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:taqikrdnawa/backend/firebase/firestore_paths.dart';
import 'package:taqikrdnawa/backend/models/product.dart';
import 'package:taqikrdnawa/backend/services/firestore_catalog_service.dart';

class ProductProvider with ChangeNotifier {

  final FirestoreCatalogService _catalog;

  final List<Product> _items = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<List<Product>>? _subscription;

  ProductProvider({FirebaseFirestore? firestore})
      : _catalog = FirestoreCatalogService(firestore: firestore) {
    _initStream();
  }

  void _initStream() {
    _isLoading = true;
    _subscription?.cancel();
    _subscription = _catalog.streamAll().listen(
      (products) {
        _items.clear();
        _items.addAll(products);
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  List<Product> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final products = await _catalog.fetchAll(limit: 200);
      _items
        ..clear()
        ..addAll(products);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Catalog is managed in Firestore (Console or Admin SDK). Not exposed in the app UI.
  Future<Product?> createProduct(Product product) async {
    _error =
        'Products are read-only in the app. Add rows in Firestore → ${FirestorePaths.products}.';
    notifyListeners();
    return null;
  }

  Future<Product?> updateProduct(Product product) async {
    _error =
        'Products are read-only in the app. Edit documents in Firestore → ${FirestorePaths.products}.';
    notifyListeners();
    return null;
  }

  Future<bool> deleteProduct(int id) async {
    _error =
        'Products are read-only in the app. Delete documents in Firestore → ${FirestorePaths.products}.';
    notifyListeners();
    return false;
  }
}
