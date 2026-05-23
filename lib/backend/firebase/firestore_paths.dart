class FirestorePaths {

  static String userDoc(String uid) => 'users/$uid';

  // User subcollections.
  static String userOrders(String uid) => 'users/$uid/orders';
  static String userFavorites(String uid) => 'users/$uid/favorites';
  static String userNotifications(String uid) => 'users/$uid/notifications';
  /// Subcollection under [userDoc]: `users/{uid}/email_inbox/{messageId}`.
  static const String userEmailInboxCollection = 'email_inbox';

  // Optional shared collections for admin/global data.
  static const String products = 'products';
  static const String categories = 'categories';

  /// IDs used by [CategoryScreen] — use the same string in each product's `categoryId`.
  static const List<String> storefrontCategoryIds = [
    'women',
    'men',
    'kids',
    'shoes',
    'accessories',
    'glasses',
    'bags',
    'jackets',
    'beauty',
    'home',
  ];
}

