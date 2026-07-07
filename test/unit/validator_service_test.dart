import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_app/core/errors/failures.dart';
import 'package:calculator_app/domain/services/validator_service.dart';

void main() {
  late ValidatorService validator;

  setUp(() {
    validator = ValidatorService();
  });

  group('ValidatorService.isValidInput Tests', () {
    test('Allows first decimal point in operand', () {
      expect(validator.isValidInput('5', '.'), isTrue);
      expect(validator.isValidInput('12.3+', '.'), isTrue);
    });

    test('Blocks second decimal point in single operand', () {
      expect(validator.isValidInput('5.', '.'), isFalse);
      expect(validator.isValidInput('5.5', '.'), isFalse);
      expect(validator.isValidInput('12.3+4.5', '.'), isFalse);
    });

    test('Allows operator input if expression ends with number', () {
      expect(validator.isValidInput('123', '+'), isTrue);
      expect(validator.isValidInput('123', '×'), isTrue);
    });

    test('Allows minus at the beginning of expression', () {
      expect(validator.isValidInput('', '-'), isTrue);
    });

    test('Blocks other operators at the beginning of expression', () {
      expect(validator.isValidInput('', '+'), isFalse);
      expect(validator.isValidInput('', '×'), isFalse);
      expect(validator.isValidInput('', '÷'), isFalse);
    });

    test('Allows unary minus after binary operator', () {
      expect(validator.isValidInput('5×', '-'), isTrue);
      expect(validator.isValidInput('5+', '-'), isTrue);
    });

    test('Blocks consecutive minus operators', () {
      expect(validator.isValidInput('5-', '-'), isFalse);
    });

    test('Blocks triple consecutive operators', () {
      expect(validator.isValidInput('5×-', '+'), isFalse);
      expect(validator.isValidInput('5×-', '-'), isFalse);
    });
  });

  group('ValidatorService.toggleSign Tests', () {
    test('Appends minus to empty expression', () {
      expect(validator.toggleSign(''), '-');
    });

    test('Toggles sign of positive integer', () {
      expect(validator.toggleSign('5'), '-5');
    });

    test('Toggles sign of negative integer back to positive', () {
      expect(validator.toggleSign('-5'), '5');
    });

    test('Toggles sign of trailing operand in nested expression', () {
      expect(validator.toggleSign('3+5'), '3+-5');
      expect(validator.toggleSign('3+-5'), '3+5');
      expect(validator.toggleSign('3×-5.2'), '3×5.2');
    });
  });

  group('ValidatorService.validateExpression Tests', () {
    test('Throws failure on empty expression', () {
      expect(
        () => validator.validateExpression(''),
        throwsA(isA<InvalidExpressionFailure>()),
      );
    });

    test('Throws failure when expression ends with operator', () {
      expect(
        () => validator.validateExpression('5+'),
        throwsA(isA<InvalidExpressionFailure>()),
      );
      expect(
        () => validator.validateExpression('5×-'),
        throwsA(isA<InvalidExpressionFailure>()),
      );
    });

    test('Throws failure for orphaned decimal points', () {
      expect(
        () => validator.validateExpression('.'),
        throwsA(isA<InvalidExpressionFailure>()),
      );
      expect(
        () => validator.validateExpression('5+.'),
        throwsA(isA<InvalidExpressionFailure>()),
      );
      expect(
        () => validator.validateExpression('5+.+3'),
        throwsA(isA<InvalidExpressionFailure>()),
      );
    });

    test('Succeeds on valid syntax expressions', () {
      expect(() => validator.validateExpression('5'), returnsNormally);
      expect(() => validator.validateExpression('-5+3.5×-2'), returnsNormally);
    });
  });
}
