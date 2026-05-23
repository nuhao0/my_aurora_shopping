import 'package:flutter/material.dart';

class TrendsScreen extends StatelessWidget {
  static const routeName = '/trends';

  const TrendsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trends'),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: 8,
        itemBuilder: (ctx, i) => Card(
          child: ListTile(
            leading: Image.network('https://images.pexels.com/photos/19090/pexels-photo.jpg', width: 56, fit: BoxFit.cover),
            title: Text('Trend Item ${i+1}'),
            subtitle: Text('Popular now'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {},
          ),
        ),
      ),
    );
  }
}
