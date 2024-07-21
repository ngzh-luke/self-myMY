import 'package:flutter/material.dart';
import 'package:mymy_m1/configs/themes/theme_provider.dart';
import 'package:mymy_m1/configs/languages/language_provider.dart';

class SettingsService with ChangeNotifier {
  final ThemeProvider themeProvider;
  final LanguageProvider languageProvider;

  SettingsService({
    required this.themeProvider,
    required this.languageProvider,
  }) {
    themeProvider.addListener(notifyListeners);
    languageProvider.addListener(notifyListeners);
  }

  // Theme-related methods
  ThemeMode get themeMode => themeProvider.themeMode;
  String get currentThemeName => themeProvider.currentThemeName;
  List<String> get availableThemes => themeProvider.availableThemes;
  ThemeData get lightTheme => themeProvider.lightTheme;
  ThemeData get darkTheme => themeProvider.darkTheme;

  Future<bool> setThemeMode(ThemeMode mode) => themeProvider.setThemeMode(mode);
  Future<bool> setTheme(String themeName) => themeProvider.setTheme(themeName);

  // Language-related methods
  Locale get currentLocale => languageProvider.currentLocale;
  bool get isSystemDefault => languageProvider.isSystemDefault;
  List<Locale> get supportedLocales => languageProvider.supportedLocales;
  Locale? get currentLocaleOrNull => languageProvider.currentLocaleOrNull;
  List<Locale?> get supportedLocalesWithDefault =>
      languageProvider.supportedLocalesWithDefault;

  Future<bool> setLocale(Locale? locale) => languageProvider.setLocale(locale);
  String getLanguageName(Locale? locale, BuildContext context) =>
      languageProvider.getLanguageName(locale, context);

  @override
  void dispose() {
    themeProvider.removeListener(notifyListeners);
    languageProvider.removeListener(notifyListeners);
    super.dispose();
  }
}
