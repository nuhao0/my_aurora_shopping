import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final String image;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    this.quantity = 1,
  });
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold<int>(0, (s, i) => s + i.quantity);

  double get total {
    return _items.fold<double>(0.0, (sum, item) => sum + item.price * item.quantity);
  }

  void addItem(String title, double price, String image) {
    try {
      final existing = _items.firstWhere((i) => i.title == title);
      existing.quantity += 1;
    } catch (_) {
      _items.add(CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        price: price,
        image: image,
      ));
    }
    notifyListeners();
  }

  void removeSingle(String id) {
    final idx = _items.indexWhere((i) => i.id == id);
    if (idx >= 0) {
      if (_items[idx].quantity > 1) {
        _items[idx].quantity -= 1;
      } else {
        _items.removeAt(idx);
      }
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _items.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
// TODO Implement this library.