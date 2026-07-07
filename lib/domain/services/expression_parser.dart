import '../../core/errors/failures.dart';
import '../models/token.dart';

/// ExpressionParser handles tokenizing of infix expression strings and
/// converting them to postfix (Reverse Polish Notation) using the Shunting-yard algorithm.
class ExpressionParser {
  static const Map<String, int> _precedence = {'+': 1, '-': 1, '×': 2, '÷': 2};

  /// Tokenizes an expression string into a list of operands and operators.
  /// Recognizes decimals and unary minus prefixing negative numbers.
  List<Token> tokenize(String expression) {
    final List<Token> tokens = [];
    final String cleaned = expression.replaceAll(' ', '');
    int i = 0;

    while (i < cleaned.length) {
      final String char = cleaned[i];

      if (char == '+' || char == '×' || char == '÷') {
        tokens.add(Token(TokenType.operator, char));
        i++;
      } else if (char == '-') {
        // A minus sign represents a negative prefix (unary minus) if:
        // 1. It is at the beginning of the expression string
        // 2. The previous token in the list is an operator
        final bool isUnary = tokens.isEmpty || tokens.last.isOperator;

        if (isUnary) {
          i++; // Consume '-'
          if (i < cleaned.length &&
              (_isDigit(cleaned[i]) || cleaned[i] == '.')) {
            final buffer = StringBuffer('-');
            while (i < cleaned.length &&
                (_isDigit(cleaned[i]) || cleaned[i] == '.')) {
              buffer.write(cleaned[i]);
              i++;
            }
            tokens.add(Token(TokenType.operand, buffer.toString()));
          } else {
            throw const InvalidExpressionFailure(
              'Error: Trailing negative sign',
            );
          }
        } else {
          // Binary subtraction
          tokens.add(const Token(TokenType.operator, '-'));
          i++;
        }
      } else if (_isDigit(char) || char == '.') {
        final buffer = StringBuffer();
        while (i < cleaned.length &&
            (_isDigit(cleaned[i]) || cleaned[i] == '.')) {
          buffer.write(cleaned[i]);
          i++;
        }
        tokens.add(Token(TokenType.operand, buffer.toString()));
      } else {
        throw InvalidExpressionFailure('Error: Invalid character "$char"');
      }
    }

    return tokens;
  }

  /// Converts a list of infix tokens to postfix notation using Shunting-yard.
  List<Token> parseToPostfix(List<Token> infixTokens) {
    final List<Token> output = [];
    final List<Token> operatorStack = [];

    for (final token in infixTokens) {
      if (token.isOperand) {
        output.add(token);
      } else if (token.isOperator) {
        final int currentPrecedence = _precedence[token.value] ?? 0;

        while (operatorStack.isNotEmpty &&
            operatorStack.last.isOperator &&
            (_precedence[operatorStack.last.value] ?? 0) >= currentPrecedence) {
          output.add(operatorStack.removeLast());
        }
        operatorStack.add(token);
      }
    }

    while (operatorStack.isNotEmpty) {
      output.add(operatorStack.removeLast());
    }

    return output;
  }

  bool _isDigit(String char) {
    if (char.isEmpty) return false;
    final int codeUnit = char.codeUnitAt(0);
    return codeUnit >= 48 && codeUnit <= 57;
  }
}
