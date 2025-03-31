import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1E88E5); // Blue
  static const Color secondary = Color(0xFFD32F2F); // Red
  static const Color accent = Color(0xFF43A047); // Green
  static const Color background = Colors.black;
  static const Color text = Colors.white;
  static const Color hint = Colors.grey;
}

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.background,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.text),
    bodyMedium: TextStyle(color: AppColors.text),
  ),
  colorScheme: ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.background,
    onSurface: AppColors.text,
  ),
);
