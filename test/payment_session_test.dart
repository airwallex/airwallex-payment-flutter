import 'package:airwallex_payment_flutter/types/merchant_trigger_reason.dart';
import 'package:airwallex_payment_flutter/types/next_triggered_by.dart';
import 'package:airwallex_payment_flutter/types/payment_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OneOffSession', () {
    test('toJson includes OneOff specific fields', () {
      final session = OneOffSession(
        clientSecret: 'testSecret',
        currency: 'HKD',
        countryCode: 'HK',
        amount: 50.00,
        paymentIntentId: 'intent123',
        autoCapture: true,
        hidePaymentConsents: false,
      );

      final json = session.toJson();

      expect(json['paymentIntentId'], equals('intent123'));
      expect(json['autoCapture'], isTrue);
      expect(json['hidePaymentConsents'], isFalse);
      expect(json['type'], equals('OneOff'));
    });
  });

  group('RecurringSession', () {
    test('toJson includes Recurring specific fields', () {
      final session = RecurringSession(
        customerId: 'cust123',
        clientSecret: 'testSecret',
        currency: 'HKD',
        countryCode: 'HK',
        amount: 99.99,
        nextTriggeredBy: NextTriggeredBy.merchant,
        merchantTriggerReason: MerchantTriggerReason.scheduled,
      );

      final json = session.toJson();

      expect(json['nextTriggeredBy'], equals('merchant'));
      expect(json['merchantTriggerReason'], equals('scheduled'));
      expect(json['type'], equals('Recurring'));
    });
  });

  group('RecurringWithIntentSession', () {
    test('toJson includes RecurringWithIntent specific fields', () {
      final session = RecurringWithIntentSession(
        customerId: 'cust123',
        clientSecret: 'testSecret',
        currency: 'HKD',
        countryCode: 'HK',
        amount: 99.99,
        paymentIntentId: 'intent123',
        autoCapture: false,
        nextTriggeredBy: NextTriggeredBy.customer,
        merchantTriggerReason: MerchantTriggerReason.unscheduled,
      );

      final json = session.toJson();

      expect(json['paymentIntentId'], equals('intent123'));
      expect(json['autoCapture'], isFalse);
      expect(json['nextTriggeredBy'], equals('customer'));
      expect(json['merchantTriggerReason'], equals('unscheduled'));
      expect(json['type'], equals('RecurringWithIntent'));
    });
  });
}
