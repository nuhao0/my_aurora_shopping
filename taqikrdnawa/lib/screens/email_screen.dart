import 'package:flutter/material.dart';

class EmailScreen extends StatelessWidget {
  static const routeName = '/email';

  const EmailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email'),
        backgroundColor: Colors.purple,
      ),
      body: Center(child: Text('Messages and support emails will appear here')),
    );
  }
}
