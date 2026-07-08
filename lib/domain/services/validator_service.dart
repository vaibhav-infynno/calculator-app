import '../../core/errors/failures.dart';

/// ValidatorService validates inputs and full expressions for syntactical correctness.
class ValidatorService {
  /// Validates whether a character can be appended to the current expression string.
  bool isValidInput(String expression, String input) {
    if (input.isEmpty) return false;

    // Decimal point constraints: only one decimal point per operand
    if (input == '.') {
      final int lastOperatorIdx = _findLastOperatorIndex(expression);
      final String currentOperand = lastOperatorIdx == -1
          ? expression
          : expression.substring(lastOperatorIdx + 1);
      return !currentOperand.contains('.');
    }

    // Operator constraints
    if (_isOperator(input)) {
      if (expression.isEmpty) {
        return input == '-'; // Only allow minus as a leading operator
      }

      final String lastChar = expression.substring(expression.length - 1);
      if (_isOperator(lastChar)) {
        // Block consecutive operators if they would exceed binary + unary combination limit (e.g. "× - -")
        if (expression.length >= 2) {
          final String secondLastChar = expression.substring(
            expression.length - 2,
            expression.length - 1,
          );
          if (_isOperator(secondLastChar) && lastChar == '-') {
            return false;
          }
        }

        // Allow unary minus after operators, but block other double operator inputs
        if (input == '-') {
          return lastChar != '-'; // Cannot type "5 - -"
        }
      }
    }

    return true;
  }

  /// Toggles the negative sign of the active operand in the expression.
  String toggleSign(String expression) {
    if (expression.isEmpty) {
      return '-';
    }

    final int lastOperatorIdx = _findLastOperatorIndex(expression);
    if (lastOperatorIdx == -1) {
      if (expression.startsWith('-')) {
        return expression.substring(1);
      } else {
        return '-$expression';
      }
    } else {
      final String prefix = expression.substring(0, lastOperatorIdx + 1);
      final String operand = expression.substring(lastOperatorIdx + 1);

      if (operand.startsWith('-')) {
        return '$prefix${operand.substring(1)}';
      } else {
        return '$prefix-$operand';
      }
    }
  }

  /// Performs syntax validation before final calculation.
  void validateExpression(String expression) {
    if (expression.isEmpty) {
      throw const InvalidExpressionFailure('Format error');
    }

    final String cleaned = expression.replaceAll(' ', '');
    final String lastChar = cleaned.substring(cleaned.length - 1);

    if (_isOperator(lastChar)) {
      throw const InvalidExpressionFailure('Format error');
    }

    // Verify all decimal points are associated with valid numbers (e.g., "." is not a valid number)
    final RegExp invalidDecimal = RegExp(r'(^|[\+\-\×\÷])\.(?:[\+\-\×\÷]|$)');
    if (invalidDecimal.hasMatch(cleaned)) {
      throw const InvalidExpressionFailure('Format error');
    }
  }

  bool _isOperator(String char) {
    return char == '+' || char == '-' || char == '×' || char == '÷';
  }

  int _findLastOperatorIndex(String expression) {
    for (int i = expression.length - 1; i >= 0; i--) {
      final String char = expression[i];
      if (_isOperator(char)) {
        // If it is unary minus (at start or preceded by operator), it is not a boundary
        final bool isUnary = i == 0 || _isOperator(expression[i - 1]);
        if (!isUnary) {
          return i;
        }
      }
    }
    return -1;
  }
}
