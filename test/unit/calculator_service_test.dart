import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_app/core/errors/failures.dart';
import 'package:calculator_app/domain/services/calculator_service.dart';
import 'package:calculator_app/domain/services/expression_parser.dart';
import 'package:calculator_app/domain/services/validator_service.dart';

void main() {
  late CalculatorService calculator;

  setUp(() {
    final validator = ValidatorService();
    final parser = ExpressionParser();
    calculator = CalculatorService(validator: validator, parser: parser);
  });

  group('CalculatorService Core Arithmetic Tests', () {
    test('Calculates basic addition', () {
      expect(calculator.calculate('12+34'), '46');
    });

    test('Calculates basic subtraction', () {
      expect(calculator.calculate('100-35'), '65');
    });

    test('Calculates basic multiplication', () {
      expect(calculator.calculate('6×7'), '42');
    });

    test('Calculates basic division', () {
      expect(calculator.calculate('45÷9'), '5');
    });
  });

  group('CalculatorService Decimals and Precision Tests', () {
    test('Calculates decimal addition', () {
      expect(calculator.calculate('10.5+4.25'), '14.75');
    });

    test('Mitigates floating-point precision binary issues (0.1 + 0.2)', () {
      expect(calculator.calculate('0.1+0.2'), '0.3');
    });

    test('Rounds repeating decimals to maximum of 4 decimal places', () {
      expect(calculator.calculate('1÷3'), '0.3333');
      expect(calculator.calculate('2÷3'), '0.6667');
      expect(calculator.calculate('8÷7'), '1.1429');
    });
  });

  group('CalculatorService Operator Precedence Tests', () {
    test('Evaluates MDAS order correctly (Multiplication before Addition)', () {
      expect(calculator.calculate('3+5×2'), '13');
    });

    test('Evaluates MDAS order correctly (Division before Subtraction)', () {
      expect(calculator.calculate('10-8÷4'), '8');
    });

    test('Evaluates complex MDAS precedence expression', () {
      expect(calculator.calculate('3+5×2-8÷4'), '11');
    });
  });

  group('CalculatorService Negative Numbers Tests', () {
    test('Calculates expression with leading negative number', () {
      expect(calculator.calculate('-5+12'), '7');
    });

    test('Calculates expression with mid-expression negative numbers', () {
      expect(calculator.calculate('6×-3'), '-18');
      expect(calculator.calculate('10+-5'), '5');
      expect(calculator.calculate('-2×-4'), '8');
    });
  });

  group('CalculatorService Errors and Failures Tests', () {
    test('Throws DivisionByZeroFailure when dividing by zero', () {
      expect(
        () => calculator.calculate('5÷0'),
        throwsA(isA<DivisionByZeroFailure>()),
      );
    });

    test('Throws DivisionByZeroFailure when dividing by decimal zero', () {
      expect(
        () => calculator.calculate('5÷0.0'),
        throwsA(isA<DivisionByZeroFailure>()),
      );
    });

    test('Throws failure on trailing operator', () {
      expect(
        () => calculator.calculate('5+3+'),
        throwsA(isA<InvalidExpressionFailure>()),
      );
    });
  });

  group('CalculatorService Boundary Limits & Scientific Notation Tests', () {
    test('Handles large number multiplication gracefully', () {
      expect(calculator.calculate('999999×999999'), '999998000001');
    });

    test('Formats extreme large outputs to scientific notation', () {
      expect(calculator.calculate('1000000×1000000'), '1e+12');
      expect(calculator.calculate('123456×10000000'), '1.2346e+12');
    });

    test('Formats extreme small non-zero outputs to scientific notation', () {
      expect(calculator.calculate('1÷100000'), '1e-5');
      expect(calculator.calculate('1.23÷100000'), '1.23e-5');
    });
  });
}
