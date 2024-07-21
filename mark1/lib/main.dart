// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mymy_m1/configs/languages/language_provider.dart';
import 'package:mymy_m1/configs/themes/theme_provider.dart';
import 'package:mymy_m1/configs/themes/theme_collections.dart';
import 'package:mymy_m1/navigation/pages_router.dart';
import 'package:mymy_m1/services/notifications/custom_notification_listener.dart';
import 'package:mymy_m1/services/notifications/custom_notification_service.dart';
import 'package:mymy_m1/services/settings/settings_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final languageProvider = LanguageProvider();
  await languageProvider.loadFromPrefs();

  final themeProvider = ThemeProvider();
  await themeProvider.loadFromPrefs();

  final settingsService = SettingsService(
    themeProvider: themeProvider,
    languageProvider: languageProvider,
  );

  // Print user preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print("\n<------------------->");
  print(' User Preferences:');
  print('Language Code: ${prefs.getString('languageCode')}');
  print('Is System Default Language: ${prefs.getBool('isSystemDefault')}');
  print(
      'Theme Mode: ${ThemeMode.values[prefs.getInt('themeMode') ?? ThemeMode.system.index].toString().split('.').last}');
  print('Theme Name: ${prefs.getString('themeName')}');
  print("<------------------->");

  // Print what will be applied
  print("\n<------------------->");
  print(' Applied Settings:');
  print(
      'Language: ${languageProvider.currentLocale.languageCode} (Is System Default: ${languageProvider.isSystemDefault})');
  print('Theme Mode: ${themeProvider.themeMode.toString().split(".").last}');
  print('Theme Name: ${themeProvider.currentThemeName}');
  print("<------------------->");

  // Report System default
  print("\n<------------------->");
  print(" Device Default:");
  String deviceLocale =
      WidgetsBinding.instance.platformDispatcher.locales.toString();
  print('Device Default Locale: $deviceLocale');
  print(
      "Device Default Theme mode: ${WidgetsBinding.instance.platformDispatcher.platformBrightness.toString().split(".").last}");
  print("<------------------->");

  // Delay to allow time for reading the console output
  await Future.delayed(const Duration(seconds: 1));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: languageProvider),
        ChangeNotifierProvider.value(value: settingsService),
        ChangeNotifierProvider(create: (_) => CustomNotificationService()),
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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final CustomNotificationService _notificationService =
      CustomNotificationService();
  late bool _isLoading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialization();
    WidgetsBinding.instance.addObserver(this);
  }

  void initialization() async {
    setState(() => _isLoading = true);
    print("\n<------------------->");
    print(" Available Resources:");
    print("loading resources...");
    print("Available localizations: ${AppLocalizations.supportedLocales}");
    print("Available Themes: ${ThemeCollections.availableThemes}");
    // await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    print("resources are loaded successfully\n");
    print("<------------------->\n");
    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _notificationService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      _notificationService.dispose();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsService>(
      builder: (context, settings, child) {
        return _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : MaterialApp.router(
                routerConfig: router,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: settings.supportedLocales,
                locale: settings.currentLocale,
                title: "myMY M1 by LukeCreated",
                theme: settings.lightTheme,
                darkTheme: settings.darkTheme,
                themeMode: settings.themeMode,
                builder: (context, child) {
                  return ScaffoldMessenger(
                    child: CustomNotificationListener(
                      child: child ?? const SizedBox.shrink(),
                    ),
                  );
                });
      },
    );
  }
}
