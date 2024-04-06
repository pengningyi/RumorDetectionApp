import 'package:flutter/material.dart';
import './language_setting_page.dart';
import './theme_setting_page.dart';
import '../../general/theme_provider.dart';
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Theme'),
            onTap: () {
              // Navigate to theme settings page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ThemeSettingsPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Language'),
            onTap: () {
              // Navigate to language settings page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LanguageSettingsPage()),
              );
            },
          ),
          // Add more setting options as needed
        ],
      ),
    );
  }
}

