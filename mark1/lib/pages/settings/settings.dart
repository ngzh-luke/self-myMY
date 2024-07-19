import 'package:flutter/material.dart';
import 'package:mymy_m1/configs/languages/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:mymy_m1/configs/themes/theme_provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, child) {
          return ListView(
            children: [
              ListTile(
                title: const Text('Theme Mode'),
                trailing: DropdownButton<ThemeMode>(
                  value: themeProvider.themeMode,
                  onChanged: (ThemeMode? newThemeMode) {
                    if (newThemeMode != null) {
                      themeProvider.setThemeMode(newThemeMode);
                    }
                  },
                  items: ThemeMode.values.map((ThemeMode mode) {
                    return DropdownMenuItem(
                      value: mode,
                      child: Text(mode.toString().split('.').last),
                    );
                  }).toList(),
                ),
              ),
              ListTile(
                title: const Text('Theme'),
                trailing: DropdownButton<String>(
                  value: themeProvider.currentThemeName,
                  onChanged: (String? newThemeName) {
                    if (newThemeName != null) {
                      themeProvider.setTheme(newThemeName);
                    }
                  },
                  items: ['sixPM' /* Add more theme names here */]
                      .map((String name) {
                    return DropdownMenuItem(
                      value: name,
                      child: Text(name),
                    );
                  }).toList(),
                ),
              ),
              ListTile(
                title: const Text('Language'),
                trailing: DropdownButton<Locale>(
                  value: languageProvider.currentLocale,
                  onChanged: (Locale? newLocale) {
                    if (newLocale != null) {
                      languageProvider.setLocale(newLocale);
                    }
                  },
                  items: languageProvider.supportedLocales.map((Locale locale) {
                    return DropdownMenuItem(
                      value: locale,
                      child: Text(locale.languageCode),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
