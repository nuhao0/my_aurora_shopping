import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';

import 'package:taqikrdnawa/backend/providers/auth_provider.dart';
import 'package:taqikrdnawa/backend/controllers/profile_controller.dart';
import 'package:taqikrdnawa/frontend/screens/notifications_screen.dart';
import 'package:taqikrdnawa/frontend/screens/profile_screen.dart';
import 'package:taqikrdnawa/frontend/screens/email_screen.dart';
import 'package:taqikrdnawa/frontend/screens/auth_screen.dart';
import 'package:taqikrdnawa/frontend/screens/favorites_screen.dart';
import 'package:taqikrdnawa/frontend/screens/settings_screen.dart';
import 'package:taqikrdnawa/frontend/screens/camera_search_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    
    // Using Get.find to get the existing controller instance
    final profileController = Get.find<ProfileController>();

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Obx(() {
              final photoUrl = profileController.userData['photoUrl'];
              final displayName = profileController.userData['displayName'] ?? (user != null ? 'Your Account' : 'Guest');
              
              return UserAccountsDrawerHeader(
                accountName: Text(displayName),
                accountEmail: Text(user?.email ?? 'Login required'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                  child: photoUrl == null ? const Icon(Icons.person) : null,
                ),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
              );
            }),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () => Navigator.of(context).pushNamed(ProfileScreen.routeName),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorites'),
              onTap: () => Navigator.of(context).pushNamed(FavoritesScreen.routeName),
            ),
            ListTile(
              leading: const Icon(Icons.mail),
              title: const Text('Email'),
              onTap: () => Navigator.of(context).pushNamed(EmailScreen.routeName),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              onTap: () => Navigator.of(context).pushNamed(NotificationsScreen.routeName),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera Search'),
              onTap: () => Navigator.of(context).pushNamed(CameraSearchScreen.routeName),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share App'),
              onTap: () async {
                Navigator.of(context).pop();
                await SharePlus.instance.share(
                  ShareParams(
                    text: 'Aurora Shop - Shop anywhere globally!',
                    subject: 'Aurora Shop',
                  ),
                );
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(SettingsScreen.routeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log out'),
              onTap: () async {
                await context.read<AuthProvider>().signOut();
                if (!context.mounted) return;
                Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
