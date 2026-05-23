class FavoriteItem {
  final String productId;
  final String title;
  final String image;
  final double price;
  final String category;

  const FavoriteItem({
    required this.productId,
    required this.title,
    required this.image,
    required this.price,
    required this.category,
  });

  factory FavoriteItem.fromMap(String productId, Map<String, dynamic> map) {
    return FavoriteItem(
      productId: productId,
      title: map['title']?.toString() ?? '',
      image: map['image']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      category: map['category']?.toString() ?? 'general',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
      'price': price,
      'category': category,
    };
  }
}

