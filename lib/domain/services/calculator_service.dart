import '../../core/errors/failures.dart';
import '../models/token.dart';
import 'expression_parser.dart';
import 'validator_service.dart';

/// CalculatorService orchestrates the validation, parsing, and execution of calculations.
class CalculatorService {
  final ValidatorService _validator;
  final ExpressionParser _parser;

  CalculatorService({
    required ValidatorService validator,
    required ExpressionParser parser,
  }) : _validator = validator,
       _parser = parser;

  /// Evaluates an infix mathematical expression string and returns a formatted result string.
  /// Decimals are limited to a maximum of 4 digits.
  String calculate(String expression) {
    // 1. Perform syntax validation
    _validator.validateExpression(expression);

    // 2. Tokenize infix expression
    final List<Token> infixTokens = _parser.tokenize(expression);

    // 3. Convert to postfix representation
    final List<Token> postfixTokens = _parser.parseToPostfix(infixTokens);

    // 4. Evaluate postfix expression
    final double rawResult = _evaluatePostfix(postfixTokens);

    // 5. Format output
    return _formatResult(rawResult);
  }

  double _evaluatePostfix(List<Token> postfixTokens) {
    final List<double> stack = [];

    for (final token in postfixTokens) {
      if (token.isOperand) {
        final double? val = double.tryParse(token.value);
        if (val == null) {
          throw InvalidExpressionFailure(
            'Error: Invalid operand "${token.value}"',
          );
        }
        stack.add(val);
      } else if (token.isOperator) {
        if (stack.length < 2) {
          throw const InvalidExpressionFailure('Error: Malformed expression');
        }
        final double right = stack.removeLast();
        final double left = stack.removeLast();

        double result;
        switch (token.value) {
          case '+':
            result = left + right;
            break;
          case '-':
            result = left - right;
            break;
          case '×':
            result = left * right;
            break;
          case '÷':
            if (right == 0.0) {
              throw const DivisionByZeroFailure();
            }
            result = left / right;
            break;
          default:
            throw InvalidExpressionFailure(
              'Error: Unknown operator "${token.value}"',
            );
        }
        stack.add(result);
      }
    }

    if (stack.length != 1) {
      throw const InvalidExpressionFailure('Error: Malformed expression');
    }

    return stack.single;
  }

  String _formatResult(double val) {
    if (val.isInfinite || val.isNaN) {
      throw const InvalidExpressionFailure('Error: Undefined result');
    }

    final double absVal = val.abs();

    // Check for extreme boundaries: use scientific notation
    if (val != 0.0 && (absVal < 0.0001 || absVal >= 1e12)) {
      return _formatExponential(val);
    }

    // Limit decimal precision to 4 digits
    final String fixedStr = val.toStringAsFixed(4);

    // Parse back to double to verify if it represents an integer value
    final double parsed = double.parse(fixedStr);
    if (parsed % 1 == 0) {
      return parsed.toInt().toString();
    }

    // Strip trailing zeros after the decimal point
    String formatted = fixedStr;
    while (formatted.endsWith('0')) {
      formatted = formatted.substring(0, formatted.length - 1);
    }
    if (formatted.endsWith('.')) {
      formatted = formatted.substring(0, formatted.length - 1);
    }

    return formatted;
  }

  String _formatExponential(double val) {
    final String expStr = val.toStringAsExponential(4);
    final List<String> parts = expStr.split('e');
    String coeff = parts[0];
    final String exp = parts[1];

    if (coeff.contains('.')) {
      while (coeff.endsWith('0')) {
        coeff = coeff.substring(0, coeff.length - 1);
      }
      if (coeff.endsWith('.')) {
        coeff = coeff.substring(0, coeff.length - 1);
      }
    }
    return '${coeff}e$exp';
  }
}
