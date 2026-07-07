import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'domain/services/calculator_service.dart';
import 'domain/services/expression_parser.dart';
import 'domain/services/validator_service.dart';
import 'presentation/providers/calculator_provider.dart';

void main() {
  runApp(const CalculatorApp());
}

/// CalculatorApp is the root application widget.
class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final validator = ValidatorService();
            final parser = ExpressionParser();
            return CalculatorProvider(
              calculatorService: CalculatorService(
                validator: validator,
                parser: parser,
              ),
              validatorService: validator,
              parser: parser,
            );
          },
        ),
      ],
      child: MaterialApp(
        title: 'Precision Calculator',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode:
            ThemeMode.system, // Dynamically matches system light/dark settings
        initialRoute: AppRoutes.home,
        routes: AppRoutes.routes,
      ),
    );
  }
}
