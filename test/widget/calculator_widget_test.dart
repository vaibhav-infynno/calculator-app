import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_app/main.dart';
import 'package:calculator_app/presentation/widgets/display_panel.dart';
import 'package:calculator_app/presentation/widgets/keypad.dart';

void main() {
  // Helper to pump the application with default settings
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await tester.pumpAndSettle();
  }

  // Helper to tap a key by its text value
  Future<void> tapKey(WidgetTester tester, String label) async {
    final finder = find.widgetWithText(GestureDetector, label);
    if (finder.evaluate().isNotEmpty) {
      await tester.tap(finder);
    } else {
      // InkWell/InkResponse inside Material buttons can also be searched by text directly
      await tester.tap(find.text(label));
    }
    await tester.pumpAndSettle();
  }

  // Helper to locate text specifically in the DisplayPanel to avoid matching keypad keys
  Finder findInDisplay(String val) {
    return find.descendant(
      of: find.byType(DisplayPanel),
      matching: find.text(val),
    );
  }

  group('Calculator Widget Tests - UI and Interactions', () {
    testWidgets('App launch renders display panel and keypad', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);

      expect(find.byType(DisplayPanel), findsOneWidget);
      expect(find.byType(Keypad), findsOneWidget);
      // Keypad has standard buttons
      expect(find.text('AC'), findsOneWidget);
      expect(find.text('⌫'), findsOneWidget);
      expect(find.text('÷'), findsOneWidget);
      expect(find.text('='), findsOneWidget);
    });

    testWidgets('Typing numbers updates display', (WidgetTester tester) async {
      await pumpApp(tester);

      await tapKey(tester, '7');
      await tapKey(tester, '8');
      await tapKey(tester, '9');

      // The expression should show '789'
      expect(find.text('789'), findsOneWidget);
    });

    testWidgets('Typing arithmetic expressions shows correct tokens', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);

      await tapKey(tester, '5');
      await tapKey(tester, '+');
      await tapKey(tester, '3');

      expect(find.text('5+3'), findsOneWidget);
    });

    testWidgets('Tapping Equals performs calculation and displays result', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);

      await tapKey(tester, '5');
      await tapKey(tester, '×');
      await tapKey(tester, '3');
      await tapKey(tester, '=');

      expect(find.text('5×3'), findsOneWidget);
      expect(find.text('15'), findsOneWidget);
    });

    testWidgets('Tapping AC clears all displays', (WidgetTester tester) async {
      await pumpApp(tester);

      await tapKey(tester, '9');
      await tapKey(tester, '+');
      await tapKey(tester, '2');
      await tapKey(tester, '=');

      expect(find.text('11'), findsOneWidget);

      await tapKey(tester, 'AC');

      expect(
        find.text('0'),
        findsNWidgets(2),
      ); // Display resets to '0' and keypad has '0' button
    });

    testWidgets('Tapping Backspace deletes the last character', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);

      await tapKey(tester, '1');
      await tapKey(tester, '2');
      await tapKey(tester, '3');
      expect(find.text('123'), findsOneWidget);

      await tapKey(tester, '⌫');
      expect(find.text('12'), findsOneWidget);
    });

    testWidgets('Operator replacement rules are updated in display', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);

      await tapKey(tester, '5');
      await tapKey(tester, '+');
      await tapKey(tester, '×'); // Replaces '+' with '×'

      expect(find.text('5×'), findsOneWidget);
    });

    testWidgets('Unary negation (+/-) toggles leading minus', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);

      await tapKey(tester, '8');
      await tapKey(tester, '+/-');
      expect(findInDisplay('-8'), findsOneWidget);

      await tapKey(tester, '+/-');
      expect(findInDisplay('8'), findsOneWidget);
    });

    testWidgets('Validation blocks duplicate decimal point insertion', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);

      await tapKey(tester, '5');
      await tapKey(tester, '.');
      await tapKey(tester, '.');

      expect(findInDisplay('5.'), findsOneWidget); // Second dot is ignored
    });

    testWidgets('Displays division by zero errors cleanly', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);

      await tapKey(tester, '9');
      await tapKey(tester, '÷');
      await tapKey(tester, '0');
      await tapKey(tester, '=');

      expect(findInDisplay('Error: Division by zero'), findsOneWidget);
    });

    testWidgets('Repeated equals repeats last operation', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);

      await tapKey(tester, '4');
      await tapKey(tester, '+');
      await tapKey(tester, '2');
      await tapKey(tester, '='); // Result: 6
      expect(findInDisplay('6'), findsOneWidget);

      await tapKey(tester, '='); // Result: 8
      expect(findInDisplay('8'), findsOneWidget);

      await tapKey(tester, '='); // Result: 10
      expect(findInDisplay('10'), findsOneWidget);
    });

    testWidgets('Chaining continues operation on result', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);

      await tapKey(tester, '3');
      await tapKey(tester, '×');
      await tapKey(tester, '4');
      await tapKey(tester, '='); // Result: 12

      await tapKey(tester, '-'); // Chains: expression becomes 12-
      await tapKey(tester, '2');
      await tapKey(tester, '='); // Result: 10
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets(
      'Long expressions are entered and do not cause display overflows',
      (WidgetTester tester) async {
        await pumpApp(tester);

        // Input a very long calculation
        for (int i = 0; i < 5; i++) {
          await tapKey(tester, '1');
          await tapKey(tester, '2');
          await tapKey(tester, '3');
          await tapKey(tester, '+');
        }
        await tapKey(tester, '9');

        // Verify that the long expression string is rendered successfully without crashing
        expect(findInDisplay('123+123+123+123+123+9'), findsOneWidget);
      },
    );
  });

  group('Calculator Widget Tests - Responsive Viewports', () {
    testWidgets('Layout renders in Portrait orientation without overflows', (
      WidgetTester tester,
    ) async {
      // Set portrait dimensions (e.g. 360 x 800)
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await pumpApp(tester);

      // Verify basic widgets render
      expect(find.byType(DisplayPanel), findsOneWidget);
      expect(find.byType(Keypad), findsOneWidget);
    });

    testWidgets('Layout renders in Landscape orientation without overflows', (
      WidgetTester tester,
    ) async {
      // Set landscape dimensions (e.g. 800 x 360)
      tester.view.physicalSize = const Size(800, 360);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await pumpApp(tester);

      // Verify basic widgets render
      expect(find.byType(DisplayPanel), findsOneWidget);
      expect(find.byType(Keypad), findsOneWidget);
    });
  });

  group('Mandatory Widget Test Cases', () {
    testWidgets('WT001: App opens, display shows 0', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      expect(findInDisplay('0'), findsOneWidget);
    });

    testWidgets('WT002: Press 5, display updates', (WidgetTester tester) async {
      await pumpApp(tester);
      await tapKey(tester, '5');
      expect(findInDisplay('5'), findsOneWidget);
    });

    testWidgets('WT003: Press C/AC, display resets', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await tapKey(tester, '5');
      await tapKey(tester, 'AC');
      expect(findInDisplay('0'), findsOneWidget);
    });

    testWidgets('WT004: Backspace, last digit removed', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await tapKey(tester, '5');
      await tapKey(tester, '3');
      await tapKey(tester, '⌫');
      expect(findInDisplay('5'), findsOneWidget);
    });

    testWidgets('WT005: 2 + 3 = 5', (WidgetTester tester) async {
      await pumpApp(tester);
      await tapKey(tester, '2');
      await tapKey(tester, '+');
      await tapKey(tester, '3');
      await tapKey(tester, '=');
      expect(findInDisplay('5'), findsOneWidget);
    });

    testWidgets('WT006: 9 - 4 = 5', (WidgetTester tester) async {
      await pumpApp(tester);
      await tapKey(tester, '9');
      await tapKey(tester, '-');
      await tapKey(tester, '4');
      await tapKey(tester, '=');
      expect(findInDisplay('5'), findsOneWidget);
    });

    testWidgets('WT007: 5 × 5 = 25', (WidgetTester tester) async {
      await pumpApp(tester);
      await tapKey(tester, '5');
      await tapKey(tester, '×');
      await tapKey(tester, '5');
      await tapKey(tester, '=');
      expect(findInDisplay('25'), findsOneWidget);
    });

    testWidgets('WT008: 8 ÷ 2 = 4', (WidgetTester tester) async {
      await pumpApp(tester);
      await tapKey(tester, '8');
      await tapKey(tester, '÷');
      await tapKey(tester, '2');
      await tapKey(tester, '=');
      expect(findInDisplay('4'), findsOneWidget);
    });

    testWidgets('WT009: 5 ÷ 0, Error shown', (WidgetTester tester) async {
      await pumpApp(tester);
      await tapKey(tester, '5');
      await tapKey(tester, '÷');
      await tapKey(tester, '0');
      await tapKey(tester, '=');
      expect(findInDisplay('Error: Division by zero'), findsOneWidget);
    });

    testWidgets('WT010: Decimal input, correct display', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await tapKey(tester, '5');
      await tapKey(tester, '.');
      await tapKey(tester, '2');
      expect(findInDisplay('5.2'), findsOneWidget);
    });

    testWidgets('WT011: Multiple operators, validation works', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await tapKey(tester, '5');
      await tapKey(tester, '+');
      await tapKey(tester, '×');
      await tapKey(tester, '3');
      expect(findInDisplay('5×3'), findsOneWidget);
    });

    testWidgets('WT012: Long expression, correct result', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await tapKey(tester, '3');
      await tapKey(tester, '+');
      await tapKey(tester, '5');
      await tapKey(tester, '×');
      await tapKey(tester, '2');
      await tapKey(tester, '-');
      await tapKey(tester, '8');
      await tapKey(tester, '÷');
      await tapKey(tester, '4');
      await tapKey(tester, '=');
      expect(findInDisplay('11'), findsOneWidget);
    });
  });
}
