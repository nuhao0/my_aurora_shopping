import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:taqikrdnawa/backend/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Appearance',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            value: isDark,
            onChanged: (v) => themeProvider.setDarkMode(v),
            title: const Text('Dark mode'),
            subtitle: const Text('Switch between light and dark theme'),
          ),
          const Divider(height: 32),
          const Text(
            'Other',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const ListTile(
            leading: Icon(Icons.color_lens),
            title: Text('Aurora/SHEIN theme'),
            subtitle: Text('Theme is applied across the app'),
          ),
        ],
      ),
    );
  }
}

