import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mymy_m1/configs/languages/language_provider.dart';
import 'package:mymy_m1/configs/themes/theme_provider.dart';
import 'package:mymy_m1/configs/themes/theme_collections.dart';
import 'package:mymy_m1/firebase_options.dart';
import 'package:mymy_m1/helpers/logs/log_helper.dart';
import 'package:mymy_m1/navigation/pages_router.dart';
import 'package:mymy_m1/helpers/getit/get_it.dart';
import 'package:mymy_m1/services/notifications/notification_manager.dart';
import 'package:mymy_m1/services/settings/settings_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loader_overlay/loader_overlay.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final languageProvider = LanguageProvider();
  await languageProvider.loadFromPrefs();

  final themeProvider = ThemeProvider();
  await themeProvider.loadFromPrefs();

  final settingsService = SettingsService(
    themeProvider: themeProvider,
    languageProvider: languageProvider,
  );

  // Log user preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print("\n<------------------->");
  print(' User Preferences:');
  print('Language Code: ${prefs.getString('languageCode')}');
  print('Is System Default Language: ${prefs.getBool('isSystemDefault')}');
  print(
      'Theme Mode: ${ThemeMode.values[prefs.getInt('themeMode') ?? ThemeMode.system.index].toString().split('.').last}');
  print('Theme Name: ${prefs.getString('themeName')}');
  print("<------------------->");

  // Log what will be applied
  print("\n<------------------->");
  print(' Applied Settings:');
  print(
      'Language: ${languageProvider.currentLocale.languageCode} (Is System Default: ${languageProvider.isSystemDefault})');
  LogHelper.logger
      .d('Theme Mode: ${themeProvider.themeMode.toString().split(".").last}');
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

  await Future.delayed(const Duration(
      seconds: 1)); // Delay to allow time for reading the console output

  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider.value(value: themeProvider),
        // ChangeNotifierProvider.value(value: languageProvider),
        ChangeNotifierProvider.value(value: settingsService),
        ProxyProvider<SettingsService, NotificationManager>(
          update: (_, settings, __) => NotificationManager(settings),
          dispose: (_, manager) => manager.dispose(),
        ),
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
    setupDependencies();
    print("Available localizations: ${AppLocalizations.supportedLocales}");
    print("Available Themes: ${ThemeCollections.availableThemes}");
    setState(() => _isLoading = false);
    print("resources are loaded successfully\n");
    print("<------------------->\n");
    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // TODO: add dispose()
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      // TODO: add dispose()
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsService>(
      builder: (context, settings, child) {
        return _isLoading
            ? Center(
                child: LoadingAnimationWidget.twoRotatingArc(
                    color: Theme.of(context).colorScheme.secondary, size: 65),
              )
            : SafeArea(
                child: GlobalLoaderOverlay(
                  useDefaultLoading: false,
                  overlayWholeScreen: true,
                  overlayColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  overlayWidgetBuilder: (progress) => Center(
                    child: LoadingAnimationWidget.twoRotatingArc(
                        color: Colors.yellowAccent, size: 65),
                  ),
                  child: MaterialApp.router(
                      debugShowCheckedModeBanner: false,
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
                        return child ?? const SizedBox.shrink();
                      }),
                ),
              );
      },
    );
  }
}
