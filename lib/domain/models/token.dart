enum TokenType { operand, operator }

/// Token represents a parsed element of a mathematical expression.
class Token {
  final TokenType type;
  final String value;

  const Token(this.type, this.value);

  bool get isOperator => type == TokenType.operator;
  bool get isOperand => type == TokenType.operand;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Token &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          value == other.value;

  @override
  int get hashCode => type.hashCode ^ value.hashCode;

  @override
  String toString() => 'Token($type, $value)';
}
