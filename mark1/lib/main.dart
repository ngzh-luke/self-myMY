// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mymy_m1/configs/languages/language_provider.dart';
import 'package:mymy_m1/navigation/pages_router.dart';
import 'package:provider/provider.dart';
import 'package:mymy_m1/configs/themes/theme_provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
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
    print("Localizations: ${AppLocalizations.supportedLocales}");
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
