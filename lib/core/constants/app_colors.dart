import 'package:flutter/material.dart';

/// AppColors defines the design palette for a premium calculator user interface.
/// It implements a clean, modern slate-colored dark palette and light palette.
class AppColors {
  AppColors._();

  // Dark Mode Palette
  static const Color darkBg = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkSurfaceVariant = Color(0xFF334155); // Slate 700
  static const Color darkPrimary = Color(0xFF8B5CF6); // Violet 500 (Accent)
  static const Color darkSecondary = Color(
    0xFF06B6D4,
  ); // Cyan 500 (Operator accents)
  static const Color darkOnBg = Color(0xFFF8FAFC); // Slate 50
  static const Color darkOnSurface = Color(0xFFF1F5F9); // Slate 100
  static const Color darkTextMuted = Color(0xFF94A3B8); // Slate 400

  // Operator Color Definitions
  static const Color operatorColor = Color(0xFF3B82F6); // Blue 500
  static const Color equalsButtonColor = Color(0xFF10B981); // Emerald 500
  static const Color clearButtonColor = Color(0xFFEF4444); // Red 500

  // Light Mode Palette
  static const Color lightBg = Color(0xFFF8FAFC); // Slate 50
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFE2E8F0); // Slate 200
  static const Color lightPrimary = Color(0xFF7C3AED); // Violet 600
  static const Color lightSecondary = Color(0xFF0891B2); // Cyan 600
  static const Color lightOnBg = Color(0xFF0F172A); // Slate 900
  static const Color lightOnSurface = Color(0xFF1E293B); // Slate 800
  static const Color lightTextMuted = Color(0xFF64748B); // Slate 500
}
