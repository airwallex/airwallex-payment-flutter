import 'package:airwallex_payment_flutter/types/apple_pay_options.dart';
import 'package:airwallex_payment_flutter/types/google_pay_options.dart';
import 'package:airwallex_payment_flutter/types/merchant_trigger_reason.dart';
import 'package:airwallex_payment_flutter/types/next_triggered_by.dart';
import 'package:airwallex_payment_flutter/types/payment_session.dart';
import 'package:airwallex_payment_flutter/types/shipping.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BaseSession', () {
    test('toMap returns correct map', () {
      final session = BaseSession(
        clientSecret: 'testSecret',
        currency: 'HKD',
        countryCode: 'HK',
        amount: 99.99,
        customerId: 'cust123',
        shipping: Shipping(
          firstName: 'John',
          lastName: 'Doe',
          address: Address(city: 'Hometown', countryCode: 'HK'),
        ),
        isBillingRequired: true,
        isEmailRequired: false,
        returnUrl: 'http://example.com',
        googlePayOptions: GooglePayOptions(
          allowedCardNetworks: [
            'AMEX',
            'DISCOVER',
            'JCB',
            'MASTERCARD',
            'VISA'
          ],
        ),
        applePayOptions: ApplePayOptions(
          merchantIdentifier: 'merchant.com.example',
        ),
        paymentMethods: ['card', 'paypal'],
      );

      final map = session.toMap();

      expect(map['clientSecret'], equals('testSecret'));
      expect(map['currency'], equals('HKD'));
      expect(map['countryCode'], equals('HK'));
      expect(map['amount'], equals(99.99));
      expect(map['customerId'], equals('cust123'));
      expect(map['shipping'], isNotNull);
      expect(map['isBillingRequired'], isTrue);
      expect(map['isEmailRequired'], isFalse);
      expect(map['returnUrl'], equals('http://example.com'));
      expect(map['googlePayOptions'], isNotNull);
      expect(map['applePayOptions'], isNotNull);
      expect(map['paymentMethods'], containsAll(['card', 'paypal']));
    });
  });

  group('OneOffSession', () {
    test('toMap includes OneOff specific fields', () {
      final session = OneOffSession(
        clientSecret: 'testSecret',
        currency: 'HKD',
        countryCode: 'HK',
        amount: 50.00,
        paymentIntentId: 'intent123',
        autoCapture: true,
        hidePaymentConsents: false,
      );

      final map = session.toMap();

      expect(map['paymentIntentId'], equals('intent123'));
      expect(map['autoCapture'], isTrue);
      expect(map['hidePaymentConsents'], isFalse);
      expect(map['type'], equals('OneOff'));
    });
  });

  group('RecurringSession', () {
    test('toMap includes Recurring specific fields', () {
      final session = RecurringSession(
        customerId: 'cust123',
        clientSecret: 'testSecret',
        currency: 'HKD',
        countryCode: 'HK',
        amount: 99.99,
        nextTriggeredBy: NextTriggeredBy.merchant,
        merchantTriggerReason: MerchantTriggerReason.scheduled,
      );

      final map = session.toMap();

      expect(map['nextTriggeredBy'], equals(NextTriggeredBy.merchant.toMap()));
      expect(map['merchantTriggerReason'],
          equals(MerchantTriggerReason.scheduled.toMap()));
      expect(map['type'], equals('Recurring'));
    });
  });

  group('RecurringWithIntentSession', () {
    test('toMap includes RecurringWithIntent specific fields', () {
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

      final map = session.toMap();

      expect(map['paymentIntentId'], equals('intent123'));
      expect(map['autoCapture'], isFalse);
      expect(map['nextTriggeredBy'], equals(NextTriggeredBy.customer.toMap()));
      expect(map['merchantTriggerReason'],
          equals(MerchantTriggerReason.unscheduled.toMap()));
      expect(map['type'], equals('RecurringWithIntent'));
    });
  });
}
