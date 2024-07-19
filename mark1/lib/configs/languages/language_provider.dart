import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _currentLocale = const Locale('en');
  late SharedPreferences _prefs;

  LanguageProvider() {
    loadFromPrefs();
  }

  Locale get currentLocale => _currentLocale;

  List<Locale> get supportedLocales => const [
        Locale('en'), // English
        Locale('th'), // Thai
        Locale('zh'), // Chinese
      ];

  void setLocale(Locale locale) {
    if (!supportedLocales.contains(locale)) return;
    _currentLocale = locale;
    notifyListeners();
    _saveToPrefs();
  }

  Future<void> loadFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final String? languageCode = _prefs.getString('languageCode');
    if (languageCode != null) {
      _currentLocale = Locale(languageCode);
      notifyListeners();
    }
  }

  Future<void> _saveToPrefs() async {
    await _prefs.setString('languageCode', _currentLocale.languageCode);
  }
}
