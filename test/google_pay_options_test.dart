import 'package:airwallex_payment_flutter/types/google_pay_options.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('GooglePayOptions', () {
    test('toJson returns correct JSON with all values set', () {
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

      final json = options.toJson();

      expect(json['allowedCardAuthMethods'], ['PAN_ONLY', 'CRYPTOGRAM_3DS']);
      expect(json['merchantName'], 'Example Merchant');
      expect(json['allowPrepaidCards'], true);
      expect(json['allowCreditCards'], true);
      expect(json['assuranceDetailsRequired'], false);
      expect(json['billingAddressRequired'], true);
      expect(json['billingAddressParameters'], billingParams.toJson());
      expect(json['transactionId'], 'T12345');
      expect(json['totalPriceLabel'], 'Total');
      expect(json['checkoutOption'], 'ACTIVE');
      expect(json['emailRequired'], false);
      expect(json['shippingAddressRequired'], true);
      expect(json['shippingAddressParameters'], shippingParams.toJson());
      expect(json['allowedCardNetworks'], ['AMEX', 'DISCOVER', 'JCB', 'MASTERCARD', 'VISA']);
      expect(json['skipReadinessCheck'], false);
    });

    test('toJson uses default allowedCardNetworks if not provided', () {
      final options = GooglePayOptions();

      final json = options.toJson();

      expect(json['allowedCardNetworks'], ['AMEX', 'DISCOVER', 'JCB', 'MASTERCARD', 'VISA']);
    });
  });
}