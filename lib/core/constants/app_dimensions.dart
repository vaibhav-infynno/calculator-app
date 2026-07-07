import 'package:flutter/material.dart';

/// AppDimensions defines the padding, spacing, and layout limits for the application.
class AppDimensions {
  AppDimensions._();

  // Spacings and Paddings
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;

  // Grid/Layout Specs
  static const double buttonSpacing = 12.0;
  static const double maxContentWidth = 600.0;
  static const double displayMinHeight = 180.0;

  // Font Sizes
  static const double fontDisplayLarge = 48.0;
  static const double fontDisplaySmall = 32.0;
  static const double fontBodyLarge = 20.0;
  static const double fontBodyMedium = 16.0;

  /// Helper to calculate aspect ratio or sizes dynamically if needed.
  static double getButtonSize(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double padding =
        MediaQuery.of(context).padding.left +
        MediaQuery.of(context).padding.right;
    final double availableWidth = screenWidth - padding - (paddingMedium * 2);
    // Standard calculator keypad has 4 columns
    return (availableWidth - (buttonSpacing * 3)) / 4;
  }
}
