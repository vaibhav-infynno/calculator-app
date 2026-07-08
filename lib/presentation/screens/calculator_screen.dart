import 'package:flutter/material.dart';

import '../../core/constants/app_dimensions.dart';
import '../widgets/display_panel.dart';
import '../widgets/keypad.dart';

/// CalculatorScreen is the main interface of the Calculator App.
/// It dynamically structures the DisplayPanel and the Keypad responsively.
class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: isLandscape ? _buildLandscapeLayout() : _buildPortraitLayout(),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout() {
    return const Column(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: DisplayPanel(),
          ),
        ),
        SizedBox(height: AppDimensions.paddingLarge),
        AspectRatio(aspectRatio: 4 / 5, child: Keypad()),
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    return const Row(
      children: [
        Expanded(
          child: Align(alignment: Alignment.center, child: DisplayPanel()),
        ),
        SizedBox(width: AppDimensions.paddingLarge),
        AspectRatio(aspectRatio: 4 / 5, child: Keypad()),
      ],
    );
  }
}
