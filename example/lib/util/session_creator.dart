import 'package:airwallex_payment_flutter/types/payment_session.dart';
import 'package:airwallex_payment_flutter/types/shipping.dart';
import 'package:airwallex_payment_flutter/types/google_pay_options.dart';
import 'package:airwallex_payment_flutter/types/next_triggered_by.dart';
import 'package:airwallex_payment_flutter/types/merchant_trigger_reason.dart';
import 'package:airwallex_payment_flutter/types/apple_pay_options.dart';

class SessionCreator {
  static Map<String, dynamic> createOneOffSession(
      Map<String, dynamic> paymentIntent) {
    final String paymentIntentId = paymentIntent['id'];
    final String clientSecret = paymentIntent['client_secret'];
    final double amount = (paymentIntent['amount'] as int).toDouble();
    final String currency = paymentIntent['currency'];

    print('paymentIntentId: $paymentIntentId\n'
        'clientSecret: $clientSecret\n'
        'amount: $amount\n'
        'currency: $currency');

    final paramMap = OneOffSession(
      paymentIntentId: paymentIntentId,
      clientSecret: clientSecret,
      amount: amount,
      currency: currency,
      customerId: '',
      shipping: createShipping(),
      isBillingRequired: true,
      isEmailRequired: false,
      countryCode: 'HK',
      returnUrl: 'airwallexcheckout://com.example.airwallex_payment_flutter_example',
      googlePayOptions: GooglePayOptions(
        billingAddressRequired: true,
        billingAddressParameters: BillingAddressParameters(format: Format.FULL),
      ),
      // paymentMethods: ['card'],
      autoCapture: true,
      hidePaymentConsents: false,
    ).toMap();
    return paramMap;
  }

  static Map<String, dynamic> createRecurringSession(
      String clientSecret, String customerId) {
    print('clientSecret: $clientSecret\n'
        'customerId: $customerId');

    final paramMap = RecurringSession(
      customerId: customerId,
      clientSecret: clientSecret,
      shipping: createShipping(),
      isBillingRequired: true,
      isEmailRequired: false,
      amount: 1.00,
      currency: 'HKD',
      countryCode: 'HK',
      returnUrl: 'airwallexcheckout://com.example.airwallex_payment_flutter_example',
      nextTriggeredBy: NextTriggeredBy.Merchant,
      merchantTriggerReason: MerchantTriggerReason.Scheduled,
    ).toMap();
    return paramMap;
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
