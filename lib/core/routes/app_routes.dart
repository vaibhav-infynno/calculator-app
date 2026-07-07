import 'package:flutter/material.dart';
import '../../presentation/screens/calculator_screen.dart';

/// AppRoutes manages the route definitions and navigation configurations.
class AppRoutes {
  AppRoutes._();

  static const String home = '/';

  static Map<String, WidgetBuilder> get routes {
    return {home: (context) => const CalculatorScreen()};
  }
}
