import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 定义主题模型
enum AppTheme { light, dark, blue, green, yellow}

class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme = ThemeData.light();

  ThemeData get currentTheme => _currentTheme;

  // 切换主题
  void toggleTheme(AppTheme theme) {
    switch (theme) {
      case AppTheme.light:
        _currentTheme = ThemeData.light();
        break;
      case AppTheme.dark:
        _currentTheme = ThemeData.dark();
        break;
      case AppTheme.blue:
        _currentTheme = ThemeData(
          colorSchemeSeed: Colors.blue,
        );
        break;
      case AppTheme.green:
        _currentTheme = ThemeData(
          colorSchemeSeed: Colors.green,
        );
        break;
      case AppTheme.yellow:
        _currentTheme = ThemeData(
          colorSchemeSeed: Colors.yellow,
        );
        break;
    }
    _saveThemeToPrefs(theme);
    notifyListeners();
  }

  // 加载上次保存的主题
  Future<void> loadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedThemeIndex = prefs.getInt('theme') ?? 0;
    final savedTheme = AppTheme.values[savedThemeIndex];
    _currentTheme = _buildThemeData(savedTheme);
    notifyListeners();
    print('Theme loaded: $savedTheme');
  }


  // 将主题保存到 SharedPreferences
  Future<void> _saveThemeToPrefs(AppTheme theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('theme', theme.index);
    print('Theme $theme');
  }

  ThemeData _buildThemeData(AppTheme theme) {
    switch (theme) {
      case AppTheme.light:
        return ThemeData.light();
      case AppTheme.dark:
        return ThemeData.dark();
      case AppTheme.blue:
        return ThemeData(
          colorSchemeSeed: Colors.blue,
        );
      case AppTheme.green:
        return ThemeData(
          colorSchemeSeed: Colors.green,
        );
      case AppTheme.yellow:
        return ThemeData(
          colorSchemeSeed: Colors.yellow,
        );
    }
  }
}

