import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/category_screen.dart';
import 'screens/category_details_screen.dart';
import 'screens/item_details_screen.dart';
import 'screens/trends_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/email_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/checkout_screen.dart'; // New Checkout screen

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taqikrdnawa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (ctx) => SplashScreen(),
        AuthScreen.routeName: (ctx) => AuthScreen(),
        HomeScreen.routeName: (ctx) => const HomeScreen(),
        SearchScreen.routeName: (ctx) => SearchScreen(),
        CategoryScreen.routeName: (ctx) => CategoryScreen(),
        CategoryDetailsScreen.routeName: (ctx) => const CategoryDetailsScreen(),
        ItemDetailsScreen.routeName: (ctx) => const ItemDetailsScreen(),
        TrendsScreen.routeName: (ctx) => TrendsScreen(),
        CartScreen.routeName: (ctx) => const CartScreen(),
        CheckoutScreen.routeName: (ctx) => const CheckoutScreen(), // Added route
        FavoritesScreen.routeName: (ctx) => FavoritesScreen(),
        ProfileScreen.routeName: (ctx) => ProfileScreen(),
        EmailScreen.routeName: (ctx) => EmailScreen(),
        NotificationsScreen.routeName: (ctx) => NotificationsScreen(),
      },
    );
  }
}
