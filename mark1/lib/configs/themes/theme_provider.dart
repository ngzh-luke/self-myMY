import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mymy_m1/configs/themes/theme_collections.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _currentThemeName = 'sixPM';
  late SharedPreferences _prefs;

  ThemeProvider() {
    loadFromPrefs();
  }

  ThemeMode get themeMode => _themeMode;
  String get currentThemeName => _currentThemeName;

  ThemeData get lightTheme =>
      ThemeCollections.getThemeByName(_currentThemeName, isDark: false);
  ThemeData get darkTheme =>
      ThemeCollections.getThemeByName(_currentThemeName, isDark: true);

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
    _saveToPrefs();
  }

  void setTheme(String themeName) {
    _currentThemeName = themeName;
    notifyListeners();
    _saveToPrefs();
  }

  Future<void> loadFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _themeMode =
        ThemeMode.values[_prefs.getInt('themeMode') ?? ThemeMode.system.index];
    _currentThemeName = _prefs.getString('themeName') ?? 'sixPM';
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    await _prefs.setInt('themeMode', _themeMode.index);
    await _prefs.setString('themeName', _currentThemeName);
  }
}
