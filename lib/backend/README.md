# Backend Layer

This folder groups backend-related architecture for a clean project layout.

## Current structure

- `backend.dart`: central export for backend models/providers/services.
- `firebase/firestore_paths.dart`: Firestore path constants.

## Existing backend files used by the app

- `lib/services/*`:
  - `auth_service.dart`
  - `http_service.dart`
- `lib/providers/*`:
  - `auth_provider.dart`
  - `product_provider.dart`
  - `cart_provider.dart`
  - `profile_provider.dart`
  - `favorites_provider.dart`
  - `orders_provider.dart`
  - `app_notifications_provider.dart`
  - `theme_provider.dart`
- `lib/models/*`:
  - `product.dart`
  - `favorite_item.dart`
  - `order.dart`
  - `order_item.dart`
  - `app_notification.dart`

## Next recommended move

When stable, physically move providers/services/models into `lib/backend/`
subfolders and update imports gradually.

