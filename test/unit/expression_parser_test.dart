import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_app/core/errors/failures.dart';
import 'package:calculator_app/domain/models/token.dart';
import 'package:calculator_app/domain/services/expression_parser.dart';

void main() {
  late ExpressionParser parser;

  setUp(() {
    parser = ExpressionParser();
  });

  group('ExpressionParser Tokenizer Tests', () {
    test('Tokenizes basic addition expression', () {
      final tokens = parser.tokenize('12+345');
      expect(tokens, [
        const Token(TokenType.operand, '12'),
        const Token(TokenType.operator, '+'),
        const Token(TokenType.operand, '345'),
      ]);
    });

    test('Tokenizes expression with decimals', () {
      final tokens = parser.tokenize('12.34×0.56');
      expect(tokens, [
        const Token(TokenType.operand, '12.34'),
        const Token(TokenType.operator, '×'),
        const Token(TokenType.operand, '0.56'),
      ]);
    });

    test('Identifies leading negative sign as unary minus operand', () {
      final tokens = parser.tokenize('-5+10');
      expect(tokens, [
        const Token(TokenType.operand, '-5'),
        const Token(TokenType.operator, '+'),
        const Token(TokenType.operand, '10'),
      ]);
    });

    test('Identifies mid-expression unary minus after operator', () {
      final tokens = parser.tokenize('5×-3');
      expect(tokens, [
        const Token(TokenType.operand, '5'),
        const Token(TokenType.operator, '×'),
        const Token(TokenType.operand, '-3'),
      ]);
    });

    test('Treats hyphen as binary subtraction if preceded by operand', () {
      final tokens = parser.tokenize('5-3');
      expect(tokens, [
        const Token(TokenType.operand, '5'),
        const Token(TokenType.operator, '-'),
        const Token(TokenType.operand, '3'),
      ]);
    });

    test('Throws failure for trailing negative sign', () {
      expect(
        () => parser.tokenize('5×-'),
        throwsA(isA<InvalidExpressionFailure>()),
      );
    });

    test('Throws failure for invalid characters', () {
      expect(
        () => parser.tokenize('5+abc'),
        throwsA(isA<InvalidExpressionFailure>()),
      );
    });
  });

  group('ExpressionParser Shunting-yard Tests', () {
    test('Converts simple infix to postfix', () {
      final infix = [
        const Token(TokenType.operand, '5'),
        const Token(TokenType.operator, '+'),
        const Token(TokenType.operand, '3'),
      ];
      final postfix = parser.parseToPostfix(infix);
      expect(postfix, [
        const Token(TokenType.operand, '5'),
        const Token(TokenType.operand, '3'),
        const Token(TokenType.operator, '+'),
      ]);
    });

    test('Converts infix with precedence rules to postfix', () {
      final infix = [
        const Token(TokenType.operand, '3'),
        const Token(TokenType.operator, '+'),
        const Token(TokenType.operand, '5'),
        const Token(TokenType.operator, '×'),
        const Token(TokenType.operand, '2'),
      ];
      final postfix = parser.parseToPostfix(infix);
      expect(postfix, [
        const Token(TokenType.operand, '3'),
        const Token(TokenType.operand, '5'),
        const Token(TokenType.operand, '2'),
        const Token(TokenType.operator, '×'),
        const Token(TokenType.operator, '+'),
      ]);
    });

    test('Maintains left-to-right order for equal precedence operators', () {
      final infix = [
        const Token(TokenType.operand, '5'),
        const Token(TokenType.operator, '-'),
        const Token(TokenType.operand, '3'),
        const Token(TokenType.operator, '+'),
        const Token(TokenType.operand, '2'),
      ];
      final postfix = parser.parseToPostfix(infix);
      expect(postfix, [
        const Token(TokenType.operand, '5'),
        const Token(TokenType.operand, '3'),
        const Token(TokenType.operator, '-'),
        const Token(TokenType.operand, '2'),
        const Token(TokenType.operator, '+'),
      ]);
    });
  });
}
