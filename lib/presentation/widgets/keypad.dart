import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../providers/calculator_provider.dart';
import 'calculator_button.dart';

/// Keypad widget renders the interactive button layout of the calculator.
class Keypad extends StatelessWidget {
  const Keypad({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Stylings based on brightness mode
    final Color numberBg = isDark ? AppColors.darkSurface : Colors.grey[200]!;
    final Color numberText = isDark
        ? AppColors.darkOnSurface
        : AppColors.lightOnSurface;

    final Color actionBg = isDark
        ? AppColors.darkSurfaceVariant
        : Colors.grey[300]!;
    final Color actionText = isDark
        ? AppColors.darkOnSurface
        : AppColors.lightOnSurface;

    final Color operatorBg = isDark
        ? AppColors.darkSecondary.withValues(alpha: 0.2)
        : AppColors.lightSecondary.withValues(alpha: 0.1);
    final Color operatorText = isDark
        ? AppColors.darkSecondary
        : AppColors.lightSecondary;

    final Color clearBg = isDark
        ? AppColors.clearButtonColor.withValues(alpha: 0.2)
        : AppColors.clearButtonColor.withValues(alpha: 0.1);
    const Color clearText = AppColors.clearButtonColor;

    const Color equalsBg = AppColors.equalsButtonColor;
    const Color equalsText = Colors.white;

    final provider = context.read<CalculatorProvider>();

    return Column(
      children: [
        // Row 1: AC, Backspace, Unary Negation (+/-), Division (÷)
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: CalculatorButton(
                  text: 'AC',
                  onTap: () => provider.clear(),
                  backgroundColor: clearBg,
                  textColor: clearText,
                ),
              ),
              const SizedBox(width: AppDimensions.buttonSpacing),
              Expanded(
                child: CalculatorButton(
                  text: '⌫',
                  onTap: () => provider.delete(),
                  backgroundColor: actionBg,
                  textColor: actionText,
                ),
              ),
              const SizedBox(width: AppDimensions.buttonSpacing),
              Expanded(
                child: CalculatorButton(
                  text: '+/-',
                  onTap: () => provider.append('+/-'),
                  backgroundColor: actionBg,
                  textColor: actionText,
                ),
              ),
              const SizedBox(width: AppDimensions.buttonSpacing),
              Expanded(
                child: CalculatorButton(
                  text: '÷',
                  onTap: () => provider.append('÷'),
                  backgroundColor: operatorBg,
                  textColor: operatorText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.buttonSpacing),
        // Row 2: 7, 8, 9, Multiplication (×)
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: CalculatorButton(
                  text: '7',
                  onTap: () => provider.append('7'),
                  backgroundColor: numberBg,
                  textColor: numberText,
                ),
              ),
              const SizedBox(width: AppDimensions.buttonSpacing),
              Expanded(
                child: CalculatorButton(
                  text: '8',
                  onTap: () => provider.append('8'),
                  backgroundColor: numberBg,
                  textColor: numberText,
                ),
              ),
              const SizedBox(width: AppDimensions.buttonSpacing),
              Expanded(
                child: CalculatorButton(
                  text: '9',
                  onTap: () => provider.append('9'),
                  backgroundColor: numberBg,
                  textColor: numberText,
                ),
              ),
              const SizedBox(width: AppDimensions.buttonSpacing),
              Expanded(
                child: CalculatorButton(
                  text: '×',
                  onTap: () => provider.append('×'),
                  backgroundColor: operatorBg,
                  textColor: operatorText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.buttonSpacing),
        // Row 3: 4, 5, 6, Subtraction (-)
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: CalculatorButton(
                  text: '4',
                  onTap: () => provider.append('4'),
                  backgroundColor: numberBg,
                  textColor: numberText,
                ),
              ),
              const SizedBox(width: AppDimensions.buttonSpacing),
              Expanded(
                child: CalculatorButton(
                  text: '5',
                  onTap: () => provider.append('5'),
                  backgroundColor: numberBg,
                  textColor: numberText,
                ),
              ),
              const SizedBox(width: AppDimensions.buttonSpacing),
              Expanded(
                child: CalculatorButton(
                  text: '6',
                  onTap: () => provider.append('6'),
                  backgroundColor: numberBg,
                  textColor: numberText,
                ),
              ),
              const SizedBox(width: AppDimensions.buttonSpacing),
              Expanded(
                child: CalculatorButton(
                  text: '-',
                  onTap: () => provider.append('-'),
                  backgroundColor: operatorBg,
                  textColor: operatorText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.buttonSpacing),
        // Row 4: 1, 2, 3, Addition (+)
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: CalculatorButton(
                  text: '1',
                  onTap: () => provider.append('1'),
                  backgroundColor: numberBg,
                  textColor: numberText,
                ),
              ),
              const SizedBox(width: AppDimensions.buttonSpacing),
              Expanded(
                child: CalculatorButton(
                  text: '2',
                  onTap: () => provider.append('2'),
                  backgroundColor: numberBg,
                  textColor: numberText,
                ),
              ),
              const SizedBox(width: AppDimensions.buttonSpacing),
              Expanded(
                child: CalculatorButton(
                  text: '3',
                  onTap: () => provider.append('3'),
                  backgroundColor: numberBg,
                  textColor: numberText,
                ),
              ),
              const SizedBox(width: AppDimensions.buttonSpacing),
              Expanded(
                child: CalculatorButton(
                  text: '+',
                  onTap: () => provider.append('+'),
                  backgroundColor: operatorBg,
                  textColor: operatorText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.buttonSpacing),
        // Row 5: 0 (flex 2), . (decimal), = (equals)
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: CalculatorButton(
                  text: '0',
                  onTap: () => provider.append('0'),
                  backgroundColor: numberBg,
                  textColor: numberText,
                ),
              ),
              const SizedBox(width: AppDimensions.buttonSpacing),
              Expanded(
                child: CalculatorButton(
                  text: '.',
                  onTap: () => provider.append('.'),
                  backgroundColor: numberBg,
                  textColor: numberText,
                ),
              ),
              const SizedBox(width: AppDimensions.buttonSpacing),
              Expanded(
                child: CalculatorButton(
                  text: '=',
                  onTap: () => provider.evaluate(),
                  backgroundColor: equalsBg,
                  textColor: equalsText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
