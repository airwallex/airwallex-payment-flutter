import 'package:airwallex_payment_flutter/types/card.dart';
import 'package:airwallex_payment_flutter/types/payment_result.dart';
import 'package:airwallex_payment_flutter/types/payment_session.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:airwallex_payment_flutter/airwallex_payment_flutter_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelAirwallexPaymentFlutter platform =
      MethodChannelAirwallexPaymentFlutter();
  const MethodChannel channel =
      MethodChannel('samples.flutter.dev/airwallex_payment');

  OneOffSession createMockSession() {
    return OneOffSession(
      paymentIntentId: 'mockPaymentIntentId',
      clientSecret: 'mockClientSecret',
      amount: 100.0,
      currency: 'USD',
      isBillingRequired: true,
      isEmailRequired: false,
      countryCode: 'HK',
      returnUrl:
          'airwallexcheckout://com.example.airwallex_payment_flutter_example',
      autoCapture: true,
      hidePaymentConsents: false,
    );
  }

  Card createMockCard() {
    return Card(
      number: '4111111111111111',
      expiryMonth: '12',
      expiryYear: '2024',
      cvc: '123',
      name: 'Mock User',
    );
  }

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'initialize':
            return 'initialized_value';
          case 'presentEntirePaymentFlow':
          case 'presentCardPaymentFlow':
            return {'status': 'success', 'consentId': '123'};
          case 'startPayWithCardDetails':
            return {'status': 'success', 'consentId': 'pay_with_card_123'};
          case 'startGooglePay':
            return {'status': 'success', 'consentId': 'google_pay_123'};
          default:
            return null;
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('MethodChannelAirwallexPaymentFlutter', () {
    test('initialize should return true', () async {
      final bool result = await platform.initialize('test', true, true);
      expect(result, isTrue);
    });

    test('presentEntirePaymentFlow should return PaymentSuccessResult',
        () async {
      final session = createMockSession();
      final result = await platform.presentEntirePaymentFlow(session);

      expect(result, isA<PaymentSuccessResult>());
      expect((result as PaymentSuccessResult).paymentConsentId, '123');
    });

    test('presentCardPaymentFlow should return PaymentSuccessResult', () async {
      final session = createMockSession();
      final result = await platform.presentCardPaymentFlow(session);

      expect(result, isA<PaymentSuccessResult>());
      expect((result as PaymentSuccessResult).paymentConsentId, '123');
    });

    test('startPayWithCardDetails should return PaymentSuccessResult',
        () async {
      final session = createMockSession();
      final card = createMockCard();
      final result = await platform.startPayWithCardDetails(session, card);

      expect(result, isA<PaymentSuccessResult>());
      expect((result as PaymentSuccessResult).paymentConsentId,
          'pay_with_card_123');
    });

    test('startGooglePay should return PaymentSuccessResult', () async {
      final session = createMockSession();
      final result = await platform.startGooglePay(session);
      expect(result, isA<PaymentSuccessResult>());
      expect(
          (result as PaymentSuccessResult).paymentConsentId, 'google_pay_123');
    });

    test('presentCardPaymentFlow should return PaymentCancelledResult on cancelled status', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
            (MethodCall methodCall) async {
          if (methodCall.method == 'presentCardPaymentFlow') {
            return {'status': 'cancelled'};
          }
          return null;
        },
      );

      final session = createMockSession();
      final result = await platform.presentCardPaymentFlow(session);

      expect(result, isA<PaymentCancelledResult>());
    });

  });
}
