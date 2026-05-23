import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  static const routeName = '/notifications';

  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.purple,
      ),
      body: ListView(
        children: List.generate(6, (i) => ListTile(title: Text('Notification ${i+1}'), subtitle: Text('Details here'))),
      ),
    );
  }
}
