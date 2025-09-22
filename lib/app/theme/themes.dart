import 'package:flutter/material.dart';

import '../constants/color_res.dart';
import '../constants/font_res.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,

  // Enable Material 3
  fontFamily: FontRes.poppins,
  primaryColor: ColorRes.primary,
  scaffoldBackgroundColor: ColorRes.background,
  dividerColor: ColorRes.divider,
  disabledColor: ColorRes.disabled,
  shadowColor: ColorRes.shadow,

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0.0,
    scrolledUnderElevation: 0.0,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w800,
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
  ), dialogTheme: const DialogThemeData(backgroundColor: ColorRes.overlay),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorRes.primary,
      foregroundColor: ColorRes.white,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      elevation: 0,
      shadowColor: Colors.transparent,
    ),
  ),
);
