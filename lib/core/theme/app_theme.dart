import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// AppTheme defines the Material 3 light and dark color schemes and text themes.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        surface: AppColors.lightBg,
        surfaceContainerHighest: AppColors.lightSurfaceVariant,
        primary: AppColors.lightPrimary,
        secondary: AppColors.lightSecondary,
        onSurface: AppColors.lightOnSurface,
      ),
      scaffoldBackgroundColor: AppColors.lightBg,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: AppColors.lightOnBg,
        ),
        displayMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: AppColors.lightOnBg,
        ),
        bodyLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          color: AppColors.lightOnSurface,
        ),
        bodyMedium: TextStyle(fontSize: 16, color: AppColors.lightTextMuted),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.darkBg,
        surfaceContainerHighest: AppColors.darkSurfaceVariant,
        primary: AppColors.darkPrimary,
        secondary: AppColors.darkSecondary,
        onSurface: AppColors.darkOnSurface,
      ),
      scaffoldBackgroundColor: AppColors.darkBg,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: AppColors.darkOnBg,
        ),
        displayMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: AppColors.darkOnBg,
        ),
        bodyLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          color: AppColors.darkOnSurface,
        ),
        bodyMedium: TextStyle(fontSize: 16, color: AppColors.darkTextMuted),
      ),
    );
  }
}
