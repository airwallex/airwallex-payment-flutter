import 'package:airwallex_payment_flutter_example/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('test startPayWithCardDetails', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    final button = find.text('startPayWithCardDetails');
    await tester.tap(button);
    await tester.pumpAndSettle();

    final successTextFinder = find.text('success');
    expect(successTextFinder, findsOneWidget,
        reason: 'The dialog should show "success" as the message.');

    final closeButton = find.text('OK');
    await tester.tap(closeButton);
    await tester.pumpAndSettle();
  });
}
