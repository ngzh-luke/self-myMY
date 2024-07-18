// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mymy_m1/services/pages_router.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
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
    await Future.delayed(const Duration(seconds: 3));
    print("resources are loaded successfully");
    FlutterNativeSplash.remove();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // supportedLocales: AppLocalizations.supportedLocales, // can be added like this as well
      supportedLocales: const [
        Locale('th'), // Thai
        Locale('en'), // English
        Locale('zh'), // Chinese
      ],
      title: "myMY M1 by LukeCreated",
      theme: FlexThemeData.light(
        colors: const FlexSchemeColor(
          primary: Color(0xffe65100),
          primaryContainer: Color(0xffffcc80),
          secondary: Color(0xff2979ff),
          secondaryContainer: Color(0xffe4eaff),
          tertiary: Color(0xff2962ff),
          tertiaryContainer: Color(0xffcbd6ff),
          appBarColor: Color(0xffe4eaff),
          error: Color(0xffb00020),
        ),
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 7,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        fontFamily: GoogleFonts.chewy().fontFamily,
        fontFamilyFallback: <String>[
          GoogleFonts.krub().fontFamily!,
          GoogleFonts.maShanZheng().fontFamily!,
          GoogleFonts.notoSans().fontFamily!
        ],
      ),
      darkTheme: FlexThemeData.dark(
        colors: const FlexSchemeColor(
          primary: Color(0xffffb300),
          primaryContainer: Color(0xffc87200),
          secondary: Color(0xff82b1ff),
          secondaryContainer: Color(0xff3770cf),
          tertiary: Color(0xff448aff),
          tertiaryContainer: Color(0xff0b429c),
          appBarColor: Color(0xff3770cf),
          error: Color(0xffcf6679),
        ),
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 13,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        fontFamily: GoogleFonts.chewy().fontFamily,
        fontFamilyFallback: <String>[
          GoogleFonts.krub().fontFamily!,
          GoogleFonts.maShanZheng().fontFamily!,
          GoogleFonts.notoSans().fontFamily!
        ],
      ),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,
      themeAnimationCurve: Curves.decelerate,
    );
  }
}
