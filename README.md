# Calculator App

A premium, production-grade Calculator application built with Flutter, focusing heavily on **Clean Architecture**, **SOLID principles**, strict **lints**, and **comprehensive testing**.

The application features a modern Material 3 design system with a responsive viewport (supporting mobile, tablet, portrait, and landscape orientations), tactile haptic feedback, and built-in screen-reader accessibility semantics.

---

## Architecture

This application is designed following **Clean Architecture** principles to separate business logic from the UI framework completely.

```
┌────────────────────────────────────────────────────────┐
│                   Presentation Layer                   │
│  (Widgets, Screens, Themes, CalculatorProvider)        │
└───────────────────────────┬────────────────────────────┘
                            │ (Uses via Dependency Injection)
                            ▼
┌────────────────────────────────────────────────────────┐
│                      Domain Layer                      │
│  (Pure Dart: CalculatorService, ValidatorService,     │
│   ExpressionParser, Token Models)                      │
└────────────────────────────────────────────────────────┘
```

### 1. Presentation Layer (Flutter-dependent)
* **Widgets & Screens**: Decoupled layout components (`DisplayPanel`, `Keypad`, `CalculatorButton`) structured responsively.
* **CalculatorProvider**: Manages UI state and coordinates interaction gestures. It is completely isolated from parsing and mathematical computations, acting strictly as a state controller.
* **Themes & Styles**: Formulates the Material 3 light/dark style tokens (`AppColors`, `AppDimensions`, `AppTheme`).

### 2. Domain Layer (Pure Dart)
* **Token Model**: Represents individual arithmetic elements (operands and operators) immutably.
* **ExpressionParser**: Houses the tokenizer and implements the **Shunting-yard algorithm** to parse infix inputs into Postfix (Reverse Polish Notation) lists honoring operator precedence.
* **ValidatorService**: Enforces real-time input rules (e.g., blocking duplicate decimals, double operators) and validates full expressions.
* **CalculatorService**: Evaluates postfix tokens using a stack-based algorithm, formats results to a maximum of **4 decimal digits**, and handles division by zero error states.

---

## Folder Structure

The project conforms to the following layer-first folder layout:

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart         # Material 3 slate light/dark palettes
│   │   └── app_dimensions.dart     # Responsive layout dimensions & spacings
│   ├── errors/
│   │   └── failures.dart           # Typed domain failures & exception types
│   ├── routes/
│   │   └── app_routes.dart         # Home page and route mappings
│   └── theme/
│       └── app_theme.dart          # M3 light/dark ThemeData setups
├── domain/
│   ├── models/
│   │   └── token.dart              # Operator/operand token model
│   └── services/
│       ├── calculator_service.dart # Evaluation engine & output rounding
│       ├── expression_parser.dart  # Infix-to-postfix Shunting-yard engine
│       └── validator_service.dart  # Sign-toggles & syntax validation rules
├── presentation/
│   ├── providers/
│   │   └── calculator_provider.dart# State controller linking UI to domain
│   ├── screens/
│   │   └── calculator_screen.dart  # Responsive layout wrapper
│   └── widgets/
│       ├── calculator_button.dart  # Tactile, accessible button widget
│       ├── display_panel.dart      # Output screen with animations & scrolling
│       └── keypad.dart             # Button arrangements
└── main.dart                       # App bootstrapping and MultiProvider
```

---

## Design Decisions

1. **Provider State Management**: Chosen because it is lightweight, officially recommended, and integrates cleanly with Flutter's change notification system. Fine-grained rebuild optimizations are enforced via `Selector` structures on text nodes and `context.read` context boundaries for keys.
2. **Zero Evaluation Dependencies**: To ensure engineering quality, the tokenizer, parser, and stack evaluator were implemented completely from scratch in pure Dart without using packages like `petitparser` or `eval`.
3. **No Parentheses**: Excluded per user preference. The app only parses sequential infix expressions containing numbers and operators.
4. **4-Decimal Digit Precision**: Formats results to a maximum of 4 decimal places (e.g., `1 / 3` formats as `0.3333`, `0.1 + 0.2` formats as `0.3`), stripping any trailing zeros to clean up whole integers.
5. **Tactile Haptic Feedback**: Integrates Dart's native `HapticFeedback.lightImpact()` on key presses to simulate physical key feedback.
6. **Accessible Semantics**: Implements a mapped `Semantics` structure for all keys (e.g., `AC` announces as `"Clear All"`, `⌫` as `"Backspace"`), conforming to mobile screen-reader guidelines.

---

## How to Run

Ensure you have the Flutter SDK installed and configured.

1. Clone or navigate to the project directory:
   ```bash
   cd projects/calculator_app
   ```
2. Fetch package dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

---

## How to Test & Coverage

The test suite covers arithmetic correctness, edge cases, validation rules, state transitions, widget layouts, and responsive orientations.

* **Run all tests**:
  ```bash
  flutter test
  ```
* **Generate coverage reports**:
  ```bash
  flutter test --coverage
  ```
* **Verify coverage output**:
  The command outputs test coverage directly to `coverage/lcov.info`.

---

## Packages Used

* **`provider`**: Scoped state management injection.
* **`flutter_lints`**: Strict static analysis rules.
* **`flutter_test`**: Unit and widget testing frame.

