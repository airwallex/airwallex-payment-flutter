import 'package:airwallex_payment_flutter_example/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('test presentEntirePaymentFlow', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    final button = find.text('presentEntirePaymentFlow');
    await tester.tap(button);
    await tester.pumpAndSettle();

    final dialog = find.byType(AlertDialog);
    expect(dialog, findsNothing,
        reason: 'Dialog should not be shown for valid parameters.');
  });
}

