import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'firebase_messaging_background.dart';
import 'firebase_options.dart';
import 'package:taqikrdnawa/backend/services/push_notification_service.dart';
import 'package:taqikrdnawa/backend/providers/auth_provider.dart';
import 'package:taqikrdnawa/backend/providers/product_provider.dart';
import 'package:taqikrdnawa/backend/providers/theme_provider.dart';
import 'package:taqikrdnawa/backend/providers/orders_provider.dart';
import 'package:taqikrdnawa/backend/services/seed_service.dart';
import 'package:taqikrdnawa/backend/services/cart_service.dart';
import 'package:taqikrdnawa/backend/services/favorite_service.dart';
import 'package:taqikrdnawa/backend/services/user_service.dart';
import 'package:taqikrdnawa/backend/services/notification_service.dart';
import 'package:taqikrdnawa/backend/blocs/cart/cart_bloc.dart';
import 'package:taqikrdnawa/backend/cubits/favorites_cubit.dart';
import 'package:taqikrdnawa/backend/controllers/profile_controller.dart';
import 'package:taqikrdnawa/backend/controllers/notifications_controller.dart';

import 'package:taqikrdnawa/frontend/screens/splash_screen.dart';
import 'package:taqikrdnawa/frontend/screens/auth_screen.dart';
import 'package:taqikrdnawa/frontend/screens/home_screen.dart';
import 'package:taqikrdnawa/frontend/screens/search_screen.dart';
import 'package:taqikrdnawa/frontend/screens/category_screen.dart';
import 'package:taqikrdnawa/frontend/screens/category_details_screen.dart';
import 'package:taqikrdnawa/frontend/screens/item_details_screen.dart';
import 'package:taqikrdnawa/frontend/screens/trends_screen.dart';
import 'package:taqikrdnawa/frontend/screens/cart_screen.dart';
import 'package:taqikrdnawa/frontend/screens/favorites_screen.dart';
import 'package:taqikrdnawa/frontend/screens/profile_screen.dart';
import 'package:taqikrdnawa/frontend/screens/email_screen.dart';
import 'package:taqikrdnawa/frontend/screens/notifications_screen.dart';
import 'package:taqikrdnawa/frontend/screens/checkout_screen.dart';
import 'package:taqikrdnawa/frontend/screens/order_history_screen.dart';
import 'package:taqikrdnawa/frontend/screens/camera_search_screen.dart';
import 'package:taqikrdnawa/frontend/screens/settings_screen.dart';
import 'package:taqikrdnawa/frontend/theme/app_theme.dart';

import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    HttpOverrides.global = MyHttpOverrides();
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await FirebaseAppCheck.instance.activate(
    providerAndroid: kDebugMode
        ? const AndroidDebugProvider()
        : const AndroidPlayIntegrityProvider(),
  );

  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await PushNotificationService().initialize();
  }

  if (kDebugMode) {
    SeedService().seedDatabase().then((_) {
      debugPrint('LOG: Designer catalog synchronization complete.');
    }).catchError((e) {
      debugPrint('LOG ERROR: Catalog seeding failed: $e');
    });
  }

  // GetX Dependency Injection
  debugPrint('LOG: Initializing GetX controllers...');
  Get.put(ProfileController(userService: UserService()));
  Get.put(NotificationsController(notificationService: NotificationService()));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => CartBloc(
              cartService: CartService(),
              pushNotificationService: PushNotificationService(),
            ),
          ),
          BlocProvider(
            create: (_) => FavoritesCubit(
              favoriteService: FavoriteService(),
              pushNotificationService: PushNotificationService(),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    
    return GetMaterialApp(
      title: 'Taqikrdnawa',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.isLoading ? ThemeMode.light : themeProvider.themeMode,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      initialRoute: SplashScreen.routeName,
      getPages: [
        GetPage(name: SplashScreen.routeName, page: () => const SplashScreen()),
        GetPage(name: AuthScreen.routeName, page: () => const AuthScreen()),
        GetPage(name: HomeScreen.routeName, page: () => const HomeScreen()),
        GetPage(name: SearchScreen.routeName, page: () => const SearchScreen()),
        GetPage(name: CategoryScreen.routeName, page: () => CategoryScreen()),
        GetPage(name: CategoryDetailsScreen.routeName, page: () => const CategoryDetailsScreen()),
        GetPage(name: ItemDetailsScreen.routeName, page: () => const ItemDetailsScreen()),
        GetPage(name: TrendsScreen.routeName, page: () => const TrendsScreen()),
        GetPage(name: CartScreen.routeName, page: () => const CartScreen()),
        GetPage(name: CheckoutScreen.routeName, page: () => const CheckoutScreen()),
        GetPage(name: FavoritesScreen.routeName, page: () => const FavoritesScreen()),
        GetPage(name: ProfileScreen.routeName, page: () => const ProfileScreen()),
        GetPage(name: EmailScreen.routeName, page: () => const EmailScreen()),
        GetPage(name: NotificationsScreen.routeName, page: () => const NotificationsScreen()),
        GetPage(name: OrderHistoryScreen.routeName, page: () => const OrderHistoryScreen()),
        GetPage(name: SettingsScreen.routeName, page: () => const SettingsScreen()),
        GetPage(name: CameraSearchScreen.routeName, page: () => const CameraSearchScreen()),
      ],
    );
  }
}
