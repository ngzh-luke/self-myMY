// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mymy_m1/configs/languages/language_provider.dart';
import 'package:mymy_m1/navigation/pages_router.dart';
import 'package:provider/provider.dart';
import 'package:mymy_m1/configs/themes/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final languageProvider = LanguageProvider();
  await languageProvider.loadFromPrefs();

  final themeProvider = ThemeProvider();
  await themeProvider.loadFromPrefs();

  // Print user preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print('\nUser Preferences:');
  print('Language Code: ${prefs.getString('languageCode')}');
  print('Is System Default Language: ${prefs.getBool('isSystemDefault')}');
  print('Theme Mode: ${prefs.getInt('themeMode')}');
  print('Theme Name: ${prefs.getString('themeName')}');

  // Print what will be applied
  print('\nApplied Settings:');
  print(
      'Language: ${languageProvider.currentLocale.languageCode} (Is System Default: ${languageProvider.isSystemDefault})');
  print('Theme Mode: ${themeProvider.themeMode}');
  print('Theme Name: ${themeProvider.currentThemeName}');

  // Get system locale
  String deviceLocale =
      WidgetsBinding.instance.platformDispatcher.locales.toString();
  print('\nDevice Default Locale: $deviceLocale');

  // Delay to allow time for reading the console output
  await Future.delayed(const Duration(seconds: 2));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: languageProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialization();
  }

  void initialization() async {
    print("\n");
    print("Available localizations: ${AppLocalizations.supportedLocales}");
    print("loading resources...");
    await Future.delayed(const Duration(seconds: 1));
    print("resources are loaded successfully");
    FlutterNativeSplash.remove();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: languageProvider.supportedLocales,
          locale: languageProvider.currentLocale,
          // supportedLocales: AppLocalizations.supportedLocales, // can be added like this as well
          // supportedLocales: const [
          //   Locale('th'), // Thai
          //   Locale('en'), // English
          //   Locale('zh'), // Chinese
          // ],
          title: "myMY M1 by LukeCreated",
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.themeMode,
        );
      },
    );
  }
}
