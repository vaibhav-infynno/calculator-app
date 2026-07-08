import 'package:flutter/material.dart';
import '../../core/errors/failures.dart';
import '../../domain/models/token.dart';
import '../../domain/services/calculator_service.dart';
import '../../domain/services/expression_parser.dart';
import '../../domain/services/validator_service.dart';

/// CalculatorProvider manages the user interface state and integrates
/// presentation gestures with the domain logic.
class CalculatorProvider extends ChangeNotifier {
  final CalculatorService _calculatorService;
  final ValidatorService _validatorService;
  final ExpressionParser _parser;

  String _expression = '';
  String _result = '';
  bool _isEvaluated = false;
  bool _isError = false;

  String? _lastOperator;
  String? _lastOperand;

  CalculatorProvider({
    required CalculatorService calculatorService,
    required ValidatorService validatorService,
    required ExpressionParser parser,
  }) : _calculatorService = calculatorService,
       _validatorService = validatorService,
       _parser = parser;

  String get expression => _expression;
  String get result => _result;
  bool get isError => _isError;

  /// Appends an input string (digit, decimal, or operator) to the expression.
  void append(String value) {
    if (value == '+/-') {
      _toggleSign();
      return;
    }

    if (_isOperator(value)) {
      _appendOperator(value);
      return;
    }

    // Input is a digit or decimal point
    if (_isEvaluated) {
      // Start a fresh expression if a digit is typed after evaluation
      _expression = value == '.' ? '0.' : value;
      _result = '';
      _isEvaluated = false;
      _isError = false;
      _lastOperator = null;
      _lastOperand = null;
      notifyListeners();
    } else {
      // Check validation constraints
      if (_validatorService.isValidInput(_expression, value)) {
        if (_expression.isEmpty && value == '.') {
          _expression = '0.';
        } else {
          _expression += value;
        }
        notifyListeners();
      }
    }
  }

  /// Deletes the last character from the expression.
  void delete() {
    if (_isEvaluated) {
      // Clear result if we backspace after evaluation
      _result = '';
      _isEvaluated = false;
      _isError = false;
      notifyListeners();
      return;
    }

    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      notifyListeners();
    }
  }

  /// Clears the calculation state.
  void clear() {
    _expression = '';
    _result = '';
    _isEvaluated = false;
    _isError = false;
    _lastOperator = null;
    _lastOperand = null;
    notifyListeners();
  }

  /// Evaluates the expression.
  void evaluate() {
    if (_expression.isEmpty && _result.isEmpty) {
      return;
    }

    try {
      if (_isEvaluated && _lastOperator != null && _lastOperand != null) {
        // Repeated Equals: repeat last operation on the active result
        final String newExpr = _result + _lastOperator! + _lastOperand!;
        final String evalResult = _calculatorService.calculate(newExpr);
        _expression = newExpr;
        _result = evalResult;
        _isError = false;
      } else {
        // Normal Evaluation
        _validatorService.validateExpression(_expression);

        // Cache last operation for repeated equals
        _cacheLastOperation();

        final String evalResult = _calculatorService.calculate(_expression);
        _result = evalResult;
        _isEvaluated = true;
        _isError = false;
      }
    } on Failure catch (e) {
      _result = e.message;
      _isEvaluated = true;
      _isError = true;
      _lastOperator = null;
      _lastOperand = null;
    } catch (e) {
      _result = 'Format error';
      _isEvaluated = true;
      _isError = true;
      _lastOperator = null;
      _lastOperand = null;
    }
    notifyListeners();
  }

  void _appendOperator(String op) {
    if (_isEvaluated) {
      if (_isError) {
        return; // Block chaining on errors
      }
      // Chain operation using the result
      _expression = _result + op;
      _result = '';
      _isEvaluated = false;
      _lastOperator = null;
      _lastOperand = null;
      notifyListeners();
      return;
    }

    if (_expression.isEmpty) {
      if (op == '-') {
        _expression = '-';
        notifyListeners();
      }
      return;
    }

    final String lastChar = _expression.substring(_expression.length - 1);
    if (_isOperator(lastChar)) {
      // If we have two trailing operators (e.g. "5 × -") and we enter another, replace both
      if (_expression.length >= 2) {
        final String secondLastChar = _expression.substring(
          _expression.length - 2,
          _expression.length - 1,
        );
        if (_isOperator(secondLastChar)) {
          _expression = _expression.substring(0, _expression.length - 2) + op;
          notifyListeners();
          return;
        }
      }

      // If we have one trailing operator:
      if (op == '-') {
        // Allow unary minus
        if (lastChar != '-') {
          _expression += op;
          notifyListeners();
        }
      } else {
        // Replace last operator
        _expression = _expression.substring(0, _expression.length - 1) + op;
        notifyListeners();
      }
    } else {
      _expression += op;
      notifyListeners();
    }
  }

  void _toggleSign() {
    if (_isEvaluated) {
      if (_isError) return;
      _expression = _validatorService.toggleSign(_result);
      _result = '';
      _isEvaluated = false;
    } else {
      _expression = _validatorService.toggleSign(_expression);
    }
    notifyListeners();
  }

  void _cacheLastOperation() {
    try {
      final List<Token> tokens = _parser.tokenize(_expression);
      if (tokens.length >= 3) {
        final Token lastToken = tokens.removeLast();
        final Token secondLastToken = tokens.removeLast();
        if (secondLastToken.isOperator && lastToken.isOperand) {
          _lastOperator = secondLastToken.value;
          _lastOperand = lastToken.value;
        } else {
          _lastOperator = null;
          _lastOperand = null;
        }
      } else {
        _lastOperator = null;
        _lastOperand = null;
      }
    } catch (_) {
      _lastOperator = null;
      _lastOperand = null;
    }
  }

  bool _isOperator(String char) {
    return char == '+' || char == '-' || char == '×' || char == '÷';
  }
}
