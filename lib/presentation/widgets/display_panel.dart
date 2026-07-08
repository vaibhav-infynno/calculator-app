import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../providers/calculator_provider.dart';

/// DisplayPanel renders the calculator's input and calculation output.
/// It uses Selectors to optimize rebuilds.
class DisplayPanel extends StatelessWidget {
  const DisplayPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color expressionColor = isDark
        ? AppColors.darkOnBg
        : AppColors.lightOnBg;
    final Color resultColor = isDark
        ? AppColors.darkSecondary
        : AppColors.lightSecondary;
    final Color containerColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurfaceVariant.withValues(alpha: 0.5);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Select strictly the expression to avoid unnecessary rebuilds of other parts
          Selector<CalculatorProvider, String>(
            selector: (context, provider) => provider.expression,
            builder: (context, expression, child) {
              final displayText = expression.isEmpty ? '0' : expression;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Text(
                  displayText,
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: expressionColor,
                  ),
                  maxLines: 1,
                ),
              );
            },
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          // Select strictly the result and error state to avoid unnecessary rebuilds of other parts
          Selector<CalculatorProvider, ({String result, bool isError})>(
            selector: (context, provider) => (
              result: provider.result,
              isError: provider.isError,
            ),
            builder: (context, state, child) {
              final result = state.result;
              final isError = state.isError;

              final TextStyle? textStyle = isError
                  ? theme.textTheme.displayMedium?.copyWith(
                      color: AppColors.clearButtonColor,
                      fontWeight: FontWeight.w500,
                    )
                  : theme.textTheme.displayLarge?.copyWith(
                      color: resultColor,
                    );

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.96,
                        end: 1.0,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: result.isEmpty
                    ? const SizedBox.shrink(key: ValueKey('empty_result'))
                    : SingleChildScrollView(
                        key: ValueKey(result),
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Text(
                          result,
                          style: textStyle,
                          maxLines: 1,
                        ),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
