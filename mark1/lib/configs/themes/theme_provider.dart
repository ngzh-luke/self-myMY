import 'package:flutter/material.dart';
import 'package:mymy_m1/helpers/logs/log_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mymy_m1/configs/themes/theme_collections.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _currentThemeName = 'original';
  late SharedPreferences _prefs;

  ThemeProvider() {
    loadFromPrefs();
  }

  List<String> get availableThemes => ThemeCollections.availableThemes;
  ThemeMode get themeMode => _themeMode;
  String get currentThemeName => _currentThemeName;

  ThemeData get lightTheme =>
      ThemeCollections.getThemeByName(_currentThemeName, isDark: false);
  ThemeData get darkTheme =>
      ThemeCollections.getThemeByName(_currentThemeName, isDark: true);

  Future<bool> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await _saveToPrefs();
    return true;
  }

  Future<bool> setTheme(String themeName) async {
    if (availableThemes.contains(themeName)) {
      _currentThemeName = themeName;
      notifyListeners();
      await _saveToPrefs();
      return true;
    }
    return false;
  }

  Future<void> loadFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _themeMode =
        ThemeMode.values[_prefs.getInt('themeMode') ?? ThemeMode.system.index];
    _currentThemeName = _prefs.getString('themeName') ?? 'original';

    // Apply user preference before falling back to system default
    if (_themeMode == ThemeMode.system) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      _themeMode =
          brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    }

    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    await _prefs.setInt('themeMode', _themeMode.index);
    await _prefs.setString('themeName', _currentThemeName);
    LogHelper.logger.i(
        "\t New Prefs: Theme name: $_currentThemeName | Theme mode: ${ThemeMode.values[_prefs.getInt('themeMode') ?? ThemeMode.system.index].toString().split('.').last} ");
  }
}
