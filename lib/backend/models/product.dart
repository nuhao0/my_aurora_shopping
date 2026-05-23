class Product {
  final int id;
  final String title;
  final String image;
  final double price;
  final String category;
  final String description;

  Product({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.category,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category']?.toString() ?? 'general',
      description: json['description']?.toString() ?? '',
    );
  }

  /// Firestore `products/{docId}` — use field `categoryId` (e.g. `women`, `kids`).
  factory Product.fromFirestore(String docId, Map<String, dynamic> data) {
    final rawId = data['id'];
    final int stableId = rawId is num
        ? rawId.toInt()
        : docId.hashCode & 0x7fffffff;
        
    String imageUrl = data['image']?.toString() ?? '';
    if (imageUrl.trim().isEmpty) {
      imageUrl = 'https://via.placeholder.com/400x400.png?text=No+Image';
    }
        
    return Product(
      id: stableId,
      title: data['title']?.toString() ?? 'Unnamed Product',
      image: imageUrl,
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      category: data['categoryId']?.toString() ?? 'general',
      description: data['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'price': price,
      'category': category,
      'description': description,
    };
  }
}
