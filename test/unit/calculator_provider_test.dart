import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_app/domain/services/calculator_service.dart';
import 'package:calculator_app/domain/services/expression_parser.dart';
import 'package:calculator_app/domain/services/validator_service.dart';
import 'package:calculator_app/presentation/providers/calculator_provider.dart';

void main() {
  late CalculatorProvider provider;

  setUp(() {
    final validator = ValidatorService();
    final parser = ExpressionParser();
    final calculator = CalculatorService(validator: validator, parser: parser);
    provider = CalculatorProvider(
      calculatorService: calculator,
      validatorService: validator,
      parser: parser,
    );
  });

  group('CalculatorProvider State Tests', () {
    test('Initial state is empty', () {
      expect(provider.expression, '');
      expect(provider.result, '');
    });

    test('Appends digits and constructs expression', () {
      provider.append('1');
      provider.append('2');
      provider.append('+');
      provider.append('3');
      expect(provider.expression, '12+3');
      expect(provider.result, '');
    });

    test('Toggles sign of current expression', () {
      provider.append('5');
      provider.append('+/-');
      expect(provider.expression, '-5');

      provider.append('+');
      provider.append('3');
      provider.append('+/-');
      expect(provider.expression, '-5+-3');
    });

    test('Evaluates valid expression', () {
      provider.append('5');
      provider.append('×');
      provider.append('3');
      provider.evaluate();
      expect(provider.result, '15');
    });

    test('Clears expression and result state', () {
      provider.append('5');
      provider.append('+');
      provider.evaluate();
      provider.clear();
      expect(provider.expression, '');
      expect(provider.result, '');
    });

    test('Deletes last character (Backspace)', () {
      provider.append('1');
      provider.append('2');
      provider.delete();
      expect(provider.expression, '1');
    });

    test('Smart operator replacement replaces trailing operator', () {
      provider.append('5');
      provider.append('+');
      provider.append('×');
      expect(provider.expression, '5×');
    });

    test(
      'Allows unary minus after binary operator but replaces duplicate operators',
      () {
        provider.append('5');
        provider.append('×');
        provider.append('-');
        expect(provider.expression, '5×-');

        // Now typing another operator replaces both
        provider.append('+');
        expect(provider.expression, '5+');
      },
    );

    test('Chains operations using prior calculation result', () {
      provider.append('5');
      provider.append('+');
      provider.append('3');
      provider.evaluate(); // Result is '8'

      provider.append('×'); // Chains: starts from '8×'
      provider.append('2');
      expect(provider.expression, '8×2');
      expect(provider.result, '');

      provider.evaluate();
      expect(provider.result, '16');
    });

    test('Repeated equals repeats last operation on new result', () {
      provider.append('5');
      provider.append('+');
      provider.append('3');
      provider.evaluate(); // Result: '8'
      expect(provider.result, '8');

      provider.evaluate(); // Repeated: '8 + 3' -> Result: '11'
      expect(provider.result, '11');

      provider.evaluate(); // Repeated: '11 + 3' -> Result: '14'
      expect(provider.result, '14');
    });

    test(
      'Typing digits after evaluation clears active screen and starts fresh',
      () {
        provider.append('5');
        provider.append('+');
        provider.append('3');
        provider.evaluate(); // Result: '8'

        provider.append('2'); // Clears and starts from '2'
        expect(provider.expression, '2');
        expect(provider.result, '');
      },
    );

    test('Handles validation errors and populates failure message', () {
      provider.append('5');
      provider.append('÷');
      provider.append('0');
      provider.evaluate();
      expect(provider.result, 'Cannot divide by zero');
    });

    test('Blocks leading operators (except minus) from being appended', () {
      provider.append('+');
      expect(provider.expression, '');

      provider.append('×');
      expect(provider.expression, '');

      provider.append('÷');
      expect(provider.expression, '');

      provider.append('-');
      expect(provider.expression, '-');
    });

    test('Evaluates a long expression correctly with correct precedence', () {
      provider.append('2');
      provider.append('+');
      provider.append('3');
      provider.append('×');
      provider.append('4');
      provider.append('-');
      provider.append('12');
      provider.append('÷');
      provider.append('3'); // 2 + 12 - 4 = 10
      provider.evaluate();
      expect(provider.result, '10');
    });

    test(
      'Handles empty input evaluation gracefully (does not update state)',
      () {
        provider.evaluate();
        expect(provider.expression, '');
        expect(provider.result, '');
      },
    );
  });
}
