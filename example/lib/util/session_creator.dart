import 'package:airwallex_payment_flutter/types/payment_session.dart';
import 'package:airwallex_payment_flutter/types/shipping.dart';
import 'package:airwallex_payment_flutter/types/google_pay_options.dart';
import 'package:airwallex_payment_flutter/types/next_triggered_by.dart';
import 'package:airwallex_payment_flutter/types/merchant_trigger_reason.dart';
import 'package:airwallex_payment_flutter/types/apple_pay_options.dart';

class SessionCreator {
  static BaseSession createOneOffSession(Map<String, dynamic> paymentIntent) {
    final String paymentIntentId = paymentIntent['id'];
    final String clientSecret = paymentIntent['client_secret'];
    final double amount = (paymentIntent['amount'] as int).toDouble();
    final String currency = paymentIntent['currency'];

    print('paymentIntentId: $paymentIntentId\n'
        'clientSecret: $clientSecret\n'
        'amount: $amount\n'
        'currency: $currency');

    return OneOffSession(
      paymentIntentId: paymentIntentId,
      clientSecret: clientSecret,
      amount: amount,
      currency: currency,
      shipping: createShipping(),
      isBillingRequired: true,
      isEmailRequired: false,
      countryCode: 'HK',
      returnUrl:
          'airwallexcheckout://com.example.airwallex_payment_flutter_example',
      googlePayOptions: GooglePayOptions(
        billingAddressRequired: true,
        billingAddressParameters: BillingAddressParameters(format: Format.FULL),
      ),
      // paymentMethods: ['card'],
      autoCapture: true,
      hidePaymentConsents: false,
    );
  }

  static BaseSession createRecurringSession(
      String clientSecret, String customerId) {
    print('clientSecret: $clientSecret\n'
        'customerId: $customerId');

    return RecurringSession(
      customerId: customerId,
      clientSecret: clientSecret,
      shipping: createShipping(),
      isBillingRequired: true,
      isEmailRequired: false,
      amount: 1.00,
      currency: 'HKD',
      countryCode: 'HK',
      returnUrl:
          'airwallexcheckout://com.example.airwallex_payment_flutter_example',
      nextTriggeredBy: NextTriggeredBy.Merchant,
      merchantTriggerReason: MerchantTriggerReason.Scheduled,
    );
  }

  static BaseSession createRecurringWithIntentSession(
      Map<String, dynamic> paymentIntent, String customerId) {
    final String paymentIntentId = paymentIntent['id'];
    final String clientSecret = paymentIntent['client_secret'];
    final double amount = (paymentIntent['amount'] as int).toDouble();
    final String currency = paymentIntent['currency'];

    print('paymentIntentId: $paymentIntentId\n'
        'clientSecret: $clientSecret\n'
        'amount: $amount\n'
        'customerId: $customerId\n'
        'currency: $currency');

    return RecurringWithIntentSession(
      customerId: customerId,
      clientSecret: clientSecret,
      currency: currency,
      countryCode: 'HK',
      amount: amount,
      paymentIntentId: paymentIntentId,
      shipping: createShipping(),
      isBillingRequired: true,
      isEmailRequired: false,
      returnUrl:
          'airwallexcheckout://com.example.airwallex_payment_flutter_example',
      nextTriggeredBy: NextTriggeredBy.Merchant,
      merchantTriggerReason: MerchantTriggerReason.Scheduled,
    );
  }

  static Shipping createShipping() {
    Address exampleAddress = Address(
      city: "Example City",
      countryCode: "UK",
      street: "123 Example Street",
      postcode: "12345",
      state: "Example State",
    );

    return Shipping(
      firstName: "John",
      lastName: "Doe",
      phoneNumber: "123-456-7890",
      shippingMethod: "Standard",
      email: "john.doe@example.com",
      dateOfBirth: "2000-01-01",
      address: exampleAddress,
    );
  }
}
