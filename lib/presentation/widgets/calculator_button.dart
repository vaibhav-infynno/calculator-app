import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// CalculatorButton is a premium responsive button component.
/// It uses dynamic styling, provides haptic feedback, and implements
/// full screen-reader semantics for accessibility.
class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;

  const CalculatorButton({
    required this.text,
    required this.onTap,
    required this.backgroundColor,
    required this.textColor,
    this.fontSize = 24.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: _getSemanticsLabel(text),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24.0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          splashColor: textColor.withValues(alpha: 0.15),
          highlightColor: textColor.withValues(alpha: 0.08),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getSemanticsLabel(String val) {
    switch (val) {
      case 'AC':
        return 'Clear All';
      case '⌫':
        return 'Backspace';
      case '+/-':
        return 'Toggle Sign';
      case '÷':
        return 'Divide';
      case '×':
        return 'Multiply';
      case '-':
        return 'Minus';
      case '+':
        return 'Plus';
      case '=':
        return 'Equals';
      case '.':
        return 'Decimal Point';
      default:
        return val;
    }
  }
}
