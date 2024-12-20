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
    final amountValue = paymentIntent['amount'];
    final double amount = (amountValue is int) ? amountValue.toDouble() : amountValue as double;
    final String currency = paymentIntent['currency'];
    final String? customerId = paymentIntent['customer_id'];

    print('paymentIntentId: $paymentIntentId\n'
        'clientSecret: $clientSecret\n'
        'amount: $amount\n'
        'currency: $currency');

    return OneOffSession(
      customerId: customerId,
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
        billingAddressParameters: BillingAddressParameters(format: Format.full),
      ),
      applePayOptions: ApplePayOptions(
        merchantIdentifier: 'merchant.com.airwallex.paymentacceptance',
        supportedNetworks: [ApplePaySupportedNetwork.visa, ApplePaySupportedNetwork.masterCard, ApplePaySupportedNetwork.unionPay],
        additionalPaymentSummaryItems: [CartSummaryItem(label: "goods", amount: 2, type: CartSummaryItemType.pendingType), CartSummaryItem(label: "tax", amount: 1)],
        merchantCapabilities: [ApplePayMerchantCapability.supports3DS, ApplePayMerchantCapability.supportsCredit, ApplePayMerchantCapability.supportsDebit],
        requiredBillingContactFields: [ContactField.name, ContactField.postalAddress, ContactField.emailAddress],
        supportedCountries: ['HK', 'US', 'AU'],
        totalPriceLabel: "COMPANY, INC."
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
      nextTriggeredBy: NextTriggeredBy.customer,
      merchantTriggerReason: MerchantTriggerReason.scheduled,
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
      nextTriggeredBy: NextTriggeredBy.merchant,
      merchantTriggerReason: MerchantTriggerReason.scheduled,
    );
  }

  static Shipping createShipping() {
    ShippingAddress exampleAddress = ShippingAddress(
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
