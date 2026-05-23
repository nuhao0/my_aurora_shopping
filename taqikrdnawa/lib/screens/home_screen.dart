import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/bottom_nav.dart';
import 'notfications_screen.dart';
import 'trends_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'email_screen.dart';
import 'category_screen.dart'; // Correct import

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
    CategoryScreen(),
    TrendsScreen(),
    const CartScreen(),
    ProfileScreen(),
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
        backgroundColor: Colors.purple,
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Title + Icons
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
                      onPressed: () => Navigator.pushNamed(
                          context, NotificationsScreen.routeName),
                    ),
                    IconButton(
                      icon: const Icon(Icons.mail, color: Colors.white),
                      onPressed: () =>
                          Navigator.pushNamed(context, EmailScreen.routeName),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.white),
                      onPressed: () => Navigator.pushNamed(
                          context, FavoritesScreen.routeName),
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 8),
            // Row 2: Search Bar
            GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, SearchScreen.routeName),
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
      bottomNavigationBar:
      AuroraBottomNav(currentIndex: _selectedIndex, onTap: _onNavTap),
    );
  }
}

// --------------------------------------
// HomeTab with auto-swiping banners
// --------------------------------------
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
    {'label': 'Women', 'img': 'https://images.pexels.com/photos/428340/pexels-photo-428340.jpeg'},
    {'label': 'Plus Size', 'img': 'https://images.pexels.com/photos/1036623/pexels-photo-1036623.jpeg'},
    {'label': 'Kids', 'img': 'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg'},
    {'label': 'Men', 'img': 'https://images.pexels.com/photos/428340/pexels-photo-428340.jpeg'},
    {'label': 'Shoes', 'img': 'https://images.pexels.com/photos/2529148/pexels-photo-2529148.jpeg'},
    {'label': 'Tops', 'img': 'https://images.pexels.com/photos/2983464/pexels-photo-2983464.jpeg'},
  ];

  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.93);

    // Auto scroll every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < bannerUrls.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
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
    return ListView(
      children: [
        // ⭐ Banners
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

        // ⭐ Categories Title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            'Categories',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),

        // ⭐ Categories Bar
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (ctx, i) {
              return Padding(
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
                    Text(
                      categories[i]['label']!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        const Divider(),

        // ⭐ Top Offers Title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            'Top Offers',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

        // ⭐ Sample Product List
        ...List.generate(
          6,
              (index) => ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://images.pexels.com/photos/298863/pexels-photo-298863.jpeg',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text('Product ${index + 1}'),
            subtitle: Text('€${20 + index * 5}'),
            trailing: const Icon(Icons.add_shopping_cart),
          ),
        ),

        const SizedBox(height: 80), // space for bottom nav
      ],
    );
  }
}
