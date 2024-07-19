// Theme collections

// template for themes
// SixPM theme
// https://rydmike.com/flexcolorscheme/themesplayground-latest/
// // Theme config for FlexColorScheme version 7.3.x. Make sure you use
// // same or higher package version, but still same major version. If you
// // use a lower package version, some properties may not be supported.
// // In that case remove them after copying this theme to your app.
// theme: FlexThemeData.light(
//   colors: const FlexSchemeColor(
//     primary: Color(0xffe65100),
//     primaryContainer: Color(0xffffcc80),
//     secondary: Color(0xff2979ff),
//     secondaryContainer: Color(0xffe4eaff),
//     tertiary: Color(0xff2962ff),
//     tertiaryContainer: Color(0xffcbd6ff),
//     appBarColor: Color(0xffe4eaff),
//     error: Color(0xffb00020),
//   ),
//   surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
//   blendLevel: 7,
//   subThemesData: const FlexSubThemesData(
//     blendOnLevel: 10,
//     blendOnColors: false,
//     useTextTheme: true,
//     useM2StyleDividerInM3: true,
//     alignedDropdown: true,
//     useInputDecoratorThemeInDialogs: true,
//   ),
//   visualDensity: FlexColorScheme.comfortablePlatformDensity,
//   useMaterial3: true,
//   swapLegacyOnMaterial3: true,
//   // To use the Playground font, add GoogleFonts package and uncomment
//   // fontFamily: GoogleFonts.notoSans().fontFamily,
// ),
// darkTheme: FlexThemeData.dark(
//   colors: const FlexSchemeColor(
//     primary: Color(0xffffb300),
//     primaryContainer: Color(0xffc87200),
//     secondary: Color(0xff82b1ff),
//     secondaryContainer: Color(0xff3770cf),
//     tertiary: Color(0xff448aff),
//     tertiaryContainer: Color(0xff0b429c),
//     appBarColor: Color(0xff3770cf),
//     error: Color(0xffcf6679),
//   ),
//   surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
//   blendLevel: 13,
//   subThemesData: const FlexSubThemesData(
//     blendOnLevel: 20,
//     useTextTheme: true,
//     useM2StyleDividerInM3: true,
//     alignedDropdown: true,
//     useInputDecoratorThemeInDialogs: true,
//   ),
//   visualDensity: FlexColorScheme.comfortablePlatformDensity,
//   useMaterial3: true,
//   swapLegacyOnMaterial3: true,
//   // To use the Playground font, add GoogleFonts package and uncomment
//   // fontFamily: GoogleFonts.notoSans().fontFamily,
// ),
// // If you do not have a themeMode switch, uncomment this line
// // to let the device system mode control the theme mode:
// // themeMode: ThemeMode.system,
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeCollections {
  ThemeCollections._(); // Private constructor to prevent instantiation

  static const List<String> availableThemes = ['sixPM'];

  // Define color schemes for sixPM Light Theme
  static const FlexSchemeColor _sixPMLightColors = FlexSchemeColor(
    primary: Color(0xffe65100),
    primaryContainer: Color(0xffffcc80),
    secondary: Color(0xff2979ff),
    secondaryContainer: Color(0xffe4eaff),
    tertiary: Color(0xff2962ff),
    tertiaryContainer: Color(0xffcbd6ff),
    appBarColor: Color(0xffe4eaff),
    error: Color(0xffb00020),
  );

  // Define color schemes for sixPM Dark Theme
  static const FlexSchemeColor _sixPMDarkColors = FlexSchemeColor(
    primary: Color(0xffffb300),
    primaryContainer: Color(0xffc87200),
    secondary: Color(0xff82b1ff),
    secondaryContainer: Color(0xff3770cf),
    tertiary: Color(0xff448aff),
    tertiaryContainer: Color(0xff0b429c),
    appBarColor: Color(0xff3770cf),
    error: Color(0xffcf6679),
  );

  // Define common sixPM theme settings
  static const _surfaceMode = FlexSurfaceMode.levelSurfacesLowScaffold;
  static const _blendLevel = 7;
  static const _subThemesData = FlexSubThemesData(
    blendOnLevel: 10,
    blendOnColors: false,
    useTextTheme: true,
    useM2StyleDividerInM3: true,
    alignedDropdown: true,
    useInputDecoratorThemeInDialogs: true,
  );
  static final _visualDensity = FlexColorScheme.comfortablePlatformDensity;
  static const _useMaterial3 = true;
  static const _swapLegacyOnMaterial3 = true;

  // Define font families for all themes
  static final _fontFamily = GoogleFonts.chewy().fontFamily;
  static final _fontFamilyFallback = <String>[
    GoogleFonts.krub().fontFamily!,
    GoogleFonts.maShanZheng().fontFamily!,
    GoogleFonts.notoSans().fontFamily!
  ];

  // Create sixPM Light theme data
  static final sixPMThemeLight = _createThemeData(
    colors: _sixPMLightColors,
    brightness: Brightness.light,
  );

  // Create sixPM Dark theme data
  static final sixPMThemeDark = _createThemeData(
    colors: _sixPMDarkColors,
    brightness: Brightness.dark,
  );

  // Helper method to create ThemeData
  static ThemeData _createThemeData({
    required FlexSchemeColor colors,
    required Brightness brightness,
  }) {
    return FlexThemeData.light(
      colors: colors,
      surfaceMode: _surfaceMode,
      blendLevel: _blendLevel,
      subThemesData: _subThemesData,
      visualDensity: _visualDensity,
      useMaterial3: _useMaterial3,
      swapLegacyOnMaterial3: _swapLegacyOnMaterial3,
      fontFamily: _fontFamily,
      fontFamilyFallback: _fontFamilyFallback,
    ).copyWith(
      brightness: brightness,
    );
  }

  // Animation curve for theme transitions
  static const themeChangeAnimationCurve = Curves.easeInOut;
  static const themeChangeAnimationDuration = Duration(milliseconds: 300);

  // Method to get a theme by name
  static ThemeData getThemeByName(String name, {required bool isDark}) {
    switch (name) {
      case 'sixPM':
        return isDark ? sixPMThemeDark : sixPMThemeLight;
      // Add more cases for other themes
      default:
        return isDark ? sixPMThemeDark : sixPMThemeLight;
    }
  }
}
