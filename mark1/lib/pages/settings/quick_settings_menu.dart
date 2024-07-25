import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mymy_m1/services/settings/settings_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuickSettingsMenu extends StatelessWidget {
  const QuickSettingsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsService>(
      builder: (context, settings, child) {
        return PopupMenuButton<String>(
          icon: const Icon(Icons.settings_applications),
          onSelected: (String value) {
            switch (value) {
              case 'theme_mode':
                _changeThemeMode(context, settings);
                break;
              case 'theme':
                _changeTheme(context, settings);
                break;
              case 'language':
                _changeLanguage(context, settings);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'theme_mode',
              child: ListTile(
                leading: Icon(_getThemeModeIcon(settings.themeMode)),
                title: Text(
                    'Theme Mode: ${settings.themeMode.toString().split('.').last}'),
              ),
            ),
            PopupMenuItem<String>(
              value: 'theme',
              child: ListTile(
                leading: Icon(Icons.color_lens),
                title: Text('Theme: ${settings.currentThemeName}'),
              ),
            ),
            PopupMenuItem<String>(
              value: 'language',
              child: ListTile(
                leading: Icon(Icons.language),
                title: Text(
                    'Language: ${settings.getLanguageName(settings.currentLocaleOrNull, context)}'),
              ),
            ),
          ],
        );
      },
    );
  }

  void _changeThemeMode(BuildContext context, SettingsService settings) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.themeMode),
          content: SingleChildScrollView(
            child: ListBody(
              children: ThemeMode.values.map((mode) {
                return ListTile(
                  leading: Icon(_getThemeModeIcon(mode)),
                  title: Text(mode.toString().split('.').last),
                  onTap: () {
                    settings.setThemeMode(mode);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _changeTheme(BuildContext context, SettingsService settings) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.theme),
          content: SingleChildScrollView(
            child: ListBody(
              children: settings.availableThemes.map((theme) {
                return ListTile(
                  title: Text(theme),
                  onTap: () {
                    settings.setTheme(theme);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _changeLanguage(BuildContext context, SettingsService settings) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.heading_language),
          content: SingleChildScrollView(
            child: ListBody(
              children: settings.supportedLocalesWithDefault.map((locale) {
                return ListTile(
                  title: Text(settings.getLanguageName(locale, context)),
                  onTap: () {
                    settings.setLocale(locale);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  IconData _getThemeModeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.wb_sunny;
      case ThemeMode.dark:
        return Icons.nightlight_round;
      case ThemeMode.system:
        return Icons.settings_system_daydream;
    }
  }
}
