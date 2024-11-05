import 'dart:convert';

import 'package:airwallex_payment_flutter_example/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test multiple payment flows', (WidgetTester tester) async {
    await testStartPayWithCardDetails(tester);
    await testPresentCardPaymentFlow(tester);
    await closeNativeScreenAndSettle(tester);
    await testPresentEntirePaymentFlow(tester);
  });
}

Future<void> testStartPayWithCardDetails(WidgetTester tester) async {
  app.main();
  await tester.pumpAndSettle();

  final startPayButton = find.text('payWithCardDetails');
  await tester.tap(startPayButton);
  await tester.pumpAndSettle();

  final successTextFinder = find.text('success');
  expect(successTextFinder, findsOneWidget,
      reason: 'The dialog should show "success" as the message.');

  final closeSuccessDialogButton = find.text('OK');
  await tester.tap(closeSuccessDialogButton);
  await tester.pumpAndSettle();
}

Future<void> testPresentCardPaymentFlow(WidgetTester tester) async {
  app.main();
  await tester.pumpAndSettle();

  final presentCardFlowButton = find.text('presentCardPaymentFlow');
  await tester.tap(presentCardFlowButton);
  await tester.pumpAndSettle();

  final dialog = find.byType(AlertDialog);
  expect(dialog, findsNothing,
      reason: 'Dialog should not be shown for valid parameters.');
}

Future<void> testPresentEntirePaymentFlow(WidgetTester tester) async {
  app.main();
  await tester.pumpAndSettle();

  final entirePaymentFlowButton = find.text('presentEntirePaymentFlow');
  await tester.tap(entirePaymentFlowButton);
  await tester.pumpAndSettle();

  final dialog = find.byType(AlertDialog);
  expect(dialog, findsNothing,
      reason: 'Dialog should not be shown for valid parameters.');
}

const platform = MethodChannel('airwallex_payment_flutter',  JSONMethodCodec());

Future<void> closeNativeScreenAndSettle(WidgetTester tester) async {
  await closeNativeScreen();
  app.main();
  await tester.pumpAndSettle();
  final closeSuccessDialogButton = find.text('OK');
  await tester.tap(closeSuccessDialogButton);
  await tester.pumpAndSettle();
}

Future<void> closeNativeScreen() async {
  try {
    await platform.invokeMethod('closeNativeScreen');
  } on PlatformException catch (e) {
    print("Failed to close native screen: '${e.message}'.");
  }
}
