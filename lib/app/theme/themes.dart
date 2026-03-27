import 'package:flutter/material.dart';

import '../constants/app_font_sizes.dart';
import '../constants/color_res.dart';
import '../constants/font_res.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,

  // Enable Material 3
  fontFamily: FontRes.poppins,
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontFamily: FontRes.poppins),
    displayMedium: TextStyle(fontFamily: FontRes.poppins),
    displaySmall: TextStyle(fontFamily: FontRes.poppins),
    headlineLarge: TextStyle(fontFamily: FontRes.poppins),
    headlineMedium: TextStyle(fontFamily: FontRes.poppins),
    headlineSmall: TextStyle(fontFamily: FontRes.poppins),
    titleLarge: TextStyle(fontFamily: FontRes.poppins),
    titleMedium: TextStyle(fontFamily: FontRes.poppins),
    titleSmall: TextStyle(fontFamily: FontRes.poppins),
    bodyLarge: TextStyle(fontFamily: FontRes.poppins),
    bodyMedium: TextStyle(fontFamily: FontRes.poppins),
    bodySmall: TextStyle(fontFamily: FontRes.poppins),
    labelLarge: TextStyle(fontFamily: FontRes.poppins),
    labelMedium: TextStyle(fontFamily: FontRes.poppins),
    labelSmall: TextStyle(fontFamily: FontRes.poppins),
  ),
  primaryColor: ColorRes.primary,
  indicatorColor: ColorRes.primary,
  scaffoldBackgroundColor: ColorRes.background,
  dividerColor: ColorRes.divider,
  disabledColor: ColorRes.disabled,
  shadowColor: ColorRes.shadow,

  appBarTheme: AppBarTheme(
    backgroundColor: ColorRes.transparentColor,
    surfaceTintColor: ColorRes.transparentColor,
    elevation: 0.0,
    scrolledUnderElevation: 0.0,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: AppFontWeights.extraBold,
      color: ColorRes.textPrimary,
    ),
  ),

  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    // theme colors
    primary: ColorRes.primary,
    secondary: ColorRes.secondary,
    surface: ColorRes.surface,
    shadow: ColorRes.shadow,
    error: ColorRes.error,

    // text colors
    onPrimary: ColorRes.textPrimary,
    onSecondary: ColorRes.textSecondary,
    onSurface: ColorRes.textSecondary,
    onError: ColorRes.error,
  ),
  checkboxTheme: CheckboxThemeData(
    checkColor: WidgetStateProperty.all(ColorRes.white),
    // or any desired color
  ),
  dialogTheme: const DialogThemeData(backgroundColor: ColorRes.overlay),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorRes.primary,
      foregroundColor: ColorRes.white,
      textStyle: TextStyle(fontSize: 16, fontWeight: AppFontWeights.semiBold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      elevation: 0,
      shadowColor: ColorRes.transparentColor,
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: ColorRes.primary,
      textStyle: TextStyle(fontSize: 16, fontWeight: AppFontWeights.semiBold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      side: BorderSide(color: ColorRes.primary, width: 1.5),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    ),
  ),
);
