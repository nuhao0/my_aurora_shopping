import 'package:flutter/material.dart';
import '../screens/notfications_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/email_screen.dart';
import '../screens/auth_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Guest User'),
              accountEmail: Text('guest@aurora.com'),
              currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
              decoration: BoxDecoration(color: Colors.purple),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () => Navigator.of(context).pushNamed(ProfileScreen.routeName),
            ),
            ListTile(
              leading: Icon(Icons.mail),
              title: Text('Email'),
              onTap: () => Navigator.of(context).pushNamed(EmailScreen.routeName),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () => Navigator.of(context).pushNamed(NotificationsScreen.routeName),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share App'),
              onTap: () {
                // For demo: just show snackbar
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Share clicked')));
              },
            ),
            Spacer(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log out'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
