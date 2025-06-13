// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:trade_asia/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(TradeAsiaApp());

    // Verify that our counter starts at zero.
    expect(find.text('0'), findsNothing);
    expect(find.text('Tradeasia Products'), findsOneWidget);

    // Note: This test needs to be updated based on the actual app functionality
    // For now, just verify the app loads without crashing
  });
}
