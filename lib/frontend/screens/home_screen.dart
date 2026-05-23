import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taqikrdnawa/backend/backend.dart';
import 'package:taqikrdnawa/frontend/widgets/app_drawer.dart';
import 'package:taqikrdnawa/frontend/widgets/bottom_nav.dart';
import 'package:taqikrdnawa/backend/providers/product_provider.dart';
import 'package:taqikrdnawa/backend/providers/auth_provider.dart';
import 'package:taqikrdnawa/backend/cubits/favorites_cubit.dart';
import 'package:taqikrdnawa/backend/models/favorite_item.dart';
import 'notifications_screen.dart';
import 'trends_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'email_screen.dart';
import 'category_screen.dart';
import 'item_details_screen.dart';
import 'category_details_screen.dart';
import 'camera_search_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = [
    const HomeTab(),
    const CategoryScreen(isStandalone: false),
    const TrendsScreen(isStandalone: false),
    const CartScreen(isStandalone: false),
    const ProfileScreen(isStandalone: false),
  ];

  void _onNavTap(int i) {
    setState(() {
      _selectedIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Aurora",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications, color: Colors.white),
                      onPressed: () => Navigator.pushNamed(context, NotificationsScreen.routeName),
                    ),
                    IconButton(
                      icon: const Icon(Icons.mail, color: Colors.white),
                      onPressed: () => Navigator.pushNamed(context, EmailScreen.routeName),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.white),
                      onPressed: () => Navigator.pushNamed(context, FavoritesScreen.routeName),
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: () => Navigator.pushNamed(context, CameraSearchScreen.routeName),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, SearchScreen.routeName),
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      "Search items…",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: _tabs[_selectedIndex],
      bottomNavigationBar: AuroraBottomNav(currentIndex: _selectedIndex, onTap: _onNavTap),
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<String> bannerUrls = [
    'https://images.pexels.com/photos/291762/pexels-photo-291762.jpeg',
    'https://images.pexels.com/photos/46710/pexels-photo-46710.jpeg',
    'https://images.pexels.com/photos/2983464/pexels-photo-2983464.jpeg',
  ];

  final List<Map<String, String>> categories = [
    {'id': 'women', 'label': 'Women', 'img': 'https://images.pexels.com/photos/2983464/pexels-photo-2983464.jpeg'},
    {'id': 'beauty', 'label': 'Beauty', 'img': 'https://images.pexels.com/photos/1036623/pexels-photo-1036623.jpeg'},
    {'id': 'kids', 'label': 'Kids', 'img': 'https://images.pexels.com/photos/1620760/pexels-photo-1620760.jpeg'},
    {'id': 'men', 'label': 'Men', 'img': 'https://images.pexels.com/photos/1043474/pexels-photo-1043474.jpeg'},
    {'id': 'shoes', 'label': 'Shoes', 'img': 'https://images.pexels.com/photos/2529148/pexels-photo-2529148.jpeg'},
    {'id': 'jackets', 'label': 'Jackets', 'img': 'https://images.pexels.com/photos/1183266/pexels-photo-1183266.jpeg'},
  ];

  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.93);
    
    // Trigger initial reactive state loading
    final auth = context.read<AuthProvider>();
    if (auth.user != null) {
      final uid = auth.user!.uid;
      // Initialize BLoC, Cubit, and GetX streams
      context.read<FavoritesCubit>().loadFavorites(uid);
      context.read<CartBloc>().add(LoadCart(uid));
      Get.find<NotificationsController>().bindNotifications(uid);
      
      debugPrint('LOG: Global state initialized for user: $uid');
    }

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < bannerUrls.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = context.watch<ProductProvider>();
    final auth = context.watch<AuthProvider>();
    final uid = auth.user?.uid;

    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, favState) {
        return ListView(
          children: [
            SizedBox(
              height: 210,
              child: PageView.builder(
                controller: _pageController,
                itemCount: bannerUrls.length,
                itemBuilder: (ctx, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        bannerUrls[i],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text('Categories', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (ctx, i) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        CategoryDetailsScreen.routeName,
                        arguments: {'id': categories[i]['id'], 'name': categories[i]['label']},
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          ClipOval(
                            child: Image.network(
                              categories[i]['img']!,
                              width: 75,
                              height: 75,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(categories[i]['label']!, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text('Top Offers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            if (productsProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (productsProvider.items.isNotEmpty)
              ...productsProvider.items.take(3).map(
                    (item) => ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(ItemDetailsScreen.routeName, arguments: {
                          'title': item.title,
                          'image': item.image,
                          'price': item.price,
                          'heroTag': 'offer_${item.id}',
                          'productId': item.id.toString(),
                          'category': item.category,
                          'description': item.description,
                        });
                      },
                      leading: Hero(
                        tag: 'offer_${item.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(item.image, width: 60, height: 60, fit: BoxFit.cover),
                        ),
                      ),
                      title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                      trailing: const Icon(Icons.add_shopping_cart),
                    ),
                  )
            else
              const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('No offers available.')),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text('Trending Now', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            if (productsProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productsProvider.items.length.clamp(0, 10),
                  itemBuilder: (context, index) {
                    final item = productsProvider.items[index];
                    final isFav = favState is FavoritesLoaded && favState.isFavorite(item.id.toString());
                    return Container(
                      width: 180,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Card(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.of(context).pushNamed(ItemDetailsScreen.routeName, arguments: {
                              'title': item.title,
                              'image': item.image,
                              'price': item.price,
                              'heroTag': 'product_${item.id}',
                              'productId': item.id.toString(),
                              'category': item.category,
                              'description': item.description,
                            });
                          },
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                    child: Image.network(item.image, height: 180, width: double.infinity, fit: BoxFit.cover),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              Positioned(
                                right: 6,
                                top: 6,
                                child: IconButton(
                                  icon: Icon(
                                    isFav ? Icons.favorite : Icons.favorite_border,
                                    color: isFav ? Colors.pink : Colors.white,
                                  ),
                                  style: IconButton.styleFrom(backgroundColor: Colors.black45),
                                  onPressed: () {
                                    if (uid != null) {
                                      context.read<FavoritesCubit>().toggleFavorite(
                                            uid,
                                            FavoriteItem(
                                              productId: item.id.toString(),
                                              title: item.title,
                                              image: item.image,
                                              price: item.price,
                                              category: item.category,
                                            ),
                                          );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 80),
          ],
        );
      },
    );
  }
}
