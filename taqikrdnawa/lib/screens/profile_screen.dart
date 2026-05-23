import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
            SizedBox(height: 12),
            Text('Guest User', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('guest@aurora.com'),
            SizedBox(height: 20),
            ListTile(leading: Icon(Icons.edit), title: Text('Edit Profile')),
            ListTile(leading: Icon(Icons.history), title: Text('Order History')),
            ListTile(leading: Icon(Icons.logout), title: Text('Log out'), onTap: () {
              Navigator.of(context).pushReplacementNamed('/auth');
            }),
          ],
        ),
      ),
    );
  }
}
