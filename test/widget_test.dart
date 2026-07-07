import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_app/main.dart';

void main() {
  testWidgets('App launch smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CalculatorApp());

    // Verify that the initial display shows '0' (one in DisplayPanel and one on Keypad '0' button).
    expect(find.text('0'), findsNWidgets(2));
  });
}
