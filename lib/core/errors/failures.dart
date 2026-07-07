/// Base Failure class that represents any error encountered in the application.
abstract class Failure implements Exception {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;
}

/// Failure representing division by zero.
class DivisionByZeroFailure extends Failure {
  const DivisionByZeroFailure() : super('Error: Division by zero');
}

/// Failure representing syntactically malformed expressions.
class InvalidExpressionFailure extends Failure {
  const InvalidExpressionFailure([
    super.message = 'Error: Malformed expression',
  ]);
}

/// Failure representing tokenization or parsing errors.
class ParserFailure extends Failure {
  const ParserFailure([super.message = 'Error: Parsing failed']);
}

/// Failure representing validation constraints (e.g. typing multiple decimals).
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
