import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../general/theme_provider.dart';

class ThemeSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                themeProvider.toggleTheme(AppTheme.light);
              },
              child: Text('Light Theme'),
            ),
            ElevatedButton(
              onPressed: () {
                themeProvider.toggleTheme(AppTheme.dark);
              },
              child: Text('Dark Theme'),
            ),
            ElevatedButton(
              onPressed: () {
                themeProvider.toggleTheme(AppTheme.blue);
              },
              child: Text('Blue Theme'),
            ),
            ElevatedButton(
              onPressed: () {
                themeProvider.toggleTheme(AppTheme.green);
              },
              child: Text('Green Theme'),
            ),
            ElevatedButton(
              onPressed: () {
                themeProvider.toggleTheme(AppTheme.yellow);
              },
              child: Text('Yellow Theme'),
            ),
          ],
        ),
      ),
    );
  }
}
