// ignore_for_file: use_build_context_synchronously

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mymy_m1/configs/languages/language_provider.dart';
import 'package:mymy_m1/pages/main_view_template.dart';
import 'package:provider/provider.dart';
import 'package:mymy_m1/configs/themes/theme_provider.dart';
import 'package:mymy_m1/services/notifications/custom_notification_service.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isChangingThemeMode = false;
  bool _isChangingTheme = false;
  bool _isChangingLang = false;
  @override
  Widget build(BuildContext context) {
    return mainView(
      context,
      appBarTitle: AppLocalizations.of(context)!.settings,
      body: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, child) {
          return ListView(
            children: [
              ListTile(
                title: const Text('Theme Mode'),
                trailing: _isChangingThemeMode
                    ? const CircularProgressIndicator()
                    : DropdownButton<ThemeMode>(
                        value: themeProvider.themeMode,
                        onChanged: (ThemeMode? newThemeMode) async {
                          setState(() => _isChangingThemeMode = true);
                          if (newThemeMode != null) {
                            await themeProvider.setThemeMode(newThemeMode);
                            Provider.of<CustomNotificationService>(context,
                                    listen: false)
                                .notify(
                                    AppLocalizations.of(context)!
                                        .newChangeApplied,
                                    CustomNotificationType.success);

                            setState(() => _isChangingThemeMode = false);
                          }
                        },
                        items: ThemeMode.values.map((ThemeMode mode) {
                          return DropdownMenuItem(
                            value: mode,
                            child: Text(
                                mode.toString().split('.').last.capitalize),
                          );
                        }).toList(),
                      ),
              ),
              ListTile(
                title: const Text('Theme'),
                trailing: _isChangingTheme
                    ? const CircularProgressIndicator()
                    : DropdownButton<String>(
                        value: themeProvider.currentThemeName,
                        onChanged: (String? newThemeName) async {
                          setState(() => _isChangingTheme = true);
                          if (newThemeName != null) {
                            await themeProvider.setTheme(newThemeName);
                            Provider.of<CustomNotificationService>(context,
                                    listen: false)
                                .notify(
                                    AppLocalizations.of(context)!
                                        .newChangeApplied,
                                    CustomNotificationType.success);
                            setState(() => _isChangingTheme = false);
                          }
                        },
                        items: themeProvider.availableThemes.map((String name) {
                          return DropdownMenuItem(
                            value: name,
                            child: Text(name),
                          );
                        }).toList(),
                      ),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.language),
                trailing: _isChangingLang
                    ? const CircularProgressIndicator()
                    : DropdownButton<Locale?>(
                        value: languageProvider.currentLocaleOrNull,
                        onChanged: (Locale? newLocale) async {
                          setState(() => _isChangingLang = true);
                          await languageProvider.setLocale(newLocale);
                          // print(
                          // "in the apploc: ${AppLocalizations.of(context)?.localeName}");
                          // print(
                          //     "current locale in prov: ${context.read<LanguageProvider>().currentLocale}");
                          Provider.of<CustomNotificationService>(context,
                                  listen: false)
                              .notify(
                                  AppLocalizations.of(context)!
                                      .newChangeApplied,
                                  CustomNotificationType.success);
                          setState(() => _isChangingLang = false);
                          // print(
                          //     "in the apploc: ${AppLocalizations.of(context)?.localeName}");
                        },
                        items: languageProvider.supportedLocalesWithDefault
                            .map((Locale? locale) {
                          return DropdownMenuItem(
                            value: locale,
                            child: Text(languageProvider.getLanguageName(
                                locale, context)),
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
