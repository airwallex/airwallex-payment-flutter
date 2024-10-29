import 'package:airwallex_payment_flutter/types/google_pay_options.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('GooglePayOptions', () {
    test('toMap returns correct map with all values set', () {
      final billingParams = BillingAddressParameters(
        format: Format.full,
        phoneNumberRequired: true,
      );

      final shippingParams = ShippingAddressParameters(
        allowedCountryCodes: ['US', 'CA'],
        phoneNumberRequired: true,
      );

      final options = GooglePayOptions(
        allowedCardAuthMethods: ['PAN_ONLY', 'CRYPTOGRAM_3DS'],
        merchantName: 'Example Merchant',
        allowPrepaidCards: true,
        allowCreditCards: true,
        assuranceDetailsRequired: false,
        billingAddressRequired: true,
        billingAddressParameters: billingParams,
        transactionId: 'T12345',
        totalPriceLabel: 'Total',
        checkoutOption: 'ACTIVE',
        emailRequired: false,
        shippingAddressRequired: true,
        shippingAddressParameters: shippingParams,
        allowedCardNetworks: ['AMEX', 'DISCOVER', 'JCB', 'MASTERCARD', 'VISA'],
        skipReadinessCheck: false,
      );

      final map = options.toMap();

      expect(map['allowedCardAuthMethods'], ['PAN_ONLY', 'CRYPTOGRAM_3DS']);
      expect(map['merchantName'], 'Example Merchant');
      expect(map['allowPrepaidCards'], true);
      expect(map['allowCreditCards'], true);
      expect(map['assuranceDetailsRequired'], false);
      expect(map['billingAddressRequired'], true);
      expect(map['billingAddressParameters'], billingParams.toMap());
      expect(map['transactionId'], 'T12345');
      expect(map['totalPriceLabel'], 'Total');
      expect(map['checkoutOption'], 'ACTIVE');
      expect(map['emailRequired'], false);
      expect(map['shippingAddressRequired'], true);
      expect(map['shippingAddressParameters'], shippingParams.toMap());
      expect(map['allowedCardNetworks'], ['AMEX', 'DISCOVER', 'JCB', 'MASTERCARD', 'VISA']);
      expect(map['skipReadinessCheck'], false);
    });

    test('toMap uses default allowedCardNetworks if not provided', () {
      final options = GooglePayOptions();

      final map = options.toMap();

      expect(map['allowedCardNetworks'], ['AMEX', 'DISCOVER', 'JCB', 'MASTERCARD', 'VISA']);
    });
  });
}