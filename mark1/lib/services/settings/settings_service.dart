import 'package:flutter/material.dart';
import 'package:mymy_m1/configs/themes/theme_provider.dart';
import 'package:mymy_m1/configs/languages/language_provider.dart';
import 'package:mymy_m1/services/notifications/notification_factory.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService with ChangeNotifier {
  final ThemeProvider themeProvider;
  final LanguageProvider languageProvider;
  late SharedPreferences _prefs;
  NotificationStyle _notificationStyle = NotificationStyle.snackBar;

  SettingsService({
    required this.themeProvider,
    required this.languageProvider,
  }) {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadNotificationStyle();
    themeProvider.addListener(notifyListeners);
    languageProvider.addListener(notifyListeners);
  }

  // Theme-related methods
  ThemeMode get themeMode => themeProvider.themeMode;
  String get currentThemeName => themeProvider.currentThemeName;
  List<String> get availableThemes => themeProvider.availableThemes;
  ThemeData get lightTheme => themeProvider.lightTheme;
  ThemeData get darkTheme => themeProvider.darkTheme;

  Future<bool> setThemeMode(ThemeMode mode) async {
    bool result = await themeProvider.setThemeMode(mode);
    notifyListeners();
    return result;
  }

  Future<bool> setTheme(String themeName) async {
    bool result = await themeProvider.setTheme(themeName);
    notifyListeners();
    return result;
  }

  // Language-related methods
  Locale get currentLocale => languageProvider.currentLocale;
  bool get isSystemDefault => languageProvider.isSystemDefault;
  List<Locale> get supportedLocales => languageProvider.supportedLocales;
  Locale? get currentLocaleOrNull => languageProvider.currentLocaleOrNull;
  List<Locale?> get supportedLocalesWithDefault =>
      languageProvider.supportedLocalesWithDefault;

  Future<bool> setLocale(Locale? locale) async {
    bool result = await languageProvider.setLocale(locale);
    notifyListeners();
    return result;
  }

  String getLanguageName(Locale? locale, BuildContext context) =>
      languageProvider.getLanguageName(locale, context);

  // Notification style methods
  NotificationStyle get notificationStyle => _notificationStyle;

  void _loadNotificationStyle() {
    final styleIndex = _prefs.getInt('notificationStyle') ?? 0;
    _notificationStyle = NotificationStyle.values[styleIndex];
    notifyListeners();
  }

  Future<bool> setNotificationStyle(NotificationStyle style) async {
    await _prefs.setInt('notificationStyle', style.index);
    _notificationStyle = style;
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    themeProvider.removeListener(notifyListeners);
    languageProvider.removeListener(notifyListeners);
    super.dispose();
  }
}
