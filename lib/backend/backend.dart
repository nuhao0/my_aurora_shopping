// Central export file for backend layer.
// Import this file when you need backend features in UI code.

export 'models/app_notification.dart';
export 'models/favorite_item.dart';
export 'models/order.dart';
export 'models/order_item.dart';
export 'models/product.dart';

// State Management
export 'blocs/cart/cart_bloc.dart';
export 'blocs/cart/cart_event.dart';
export 'blocs/cart/cart_state.dart';
export 'cubits/favorites_cubit.dart';
export 'controllers/profile_controller.dart';
export 'controllers/notifications_controller.dart';

// Remaining Providers
export 'providers/auth_provider.dart';
export 'providers/orders_provider.dart';
export 'providers/product_provider.dart';
export 'providers/theme_provider.dart';

// Services
export 'services/auth_service.dart';
export 'services/http_service.dart';
export 'services/firestore_catalog_service.dart';
export 'services/cart_service.dart';
export 'services/favorite_service.dart';
export 'services/notification_service.dart';
export 'services/user_service.dart';

