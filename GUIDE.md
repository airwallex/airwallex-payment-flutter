# Airwallex Flutter Plugin
The Airwallex Flutter Plugin is a flexible tool that allows you to integrate payment methods into your Flutter application. It also includes a pre-built UI, giving you the flexibility to use any part of it while replacing the rest with your own UI.

This section will guide you through the process of integrating the Airwallex Flutter Plugin. We assume that you are a Flutter developer familiar with the integration and use of Flutter plugins.

Our demo is open source on [Github](https://github.com/airwallex/airwallex-payment-flutter),which can help you better understand how to integrate the Airwallex Flutter Plugin into your Flutter project.

## Contents
* [Overview](#Overview)
    * [Airwallex API](#airwallex-api)
    * [Airwallex Native UI](#airwallex-native-ui)
* [Installation](#Installation)
* [Initialization](#Initialization)
* [Create Payment Intent](#create-payment-intent)
* [Create Payment Session](#create-payment-session)
    * [Create One Off Session](#create-one-off-session)
    * [Create Recurring Session](#create-recurring-session)
    * [Create Recurring With Intent Session](#create-recurring-with-intent-session)
* [Airwallex Native UI integration](#airwallex-native-ui-integration)
    * [Launch payment list page](#launch-payment-list-page)
    * [Launch card payment page](#launch-card-payment-page)
    * [Custom Theme](#custom-theme)
* [Low-level API Integration](#low-level-api-integration)
    * [Confirm payment with card details](#confirm-payment-with-card-details)
    * [Google Pay](#google-pay)
* [Plugin Example](#plugin-example)
* [Test Card Numbers](#test-card-numbers)
* [Contributing](#Contributing)

## Overview
### Airwallex API

Airwallex Flutter Plugin is a flexible tool that enables you to integrate payment methods into your Flutter application.

Payment methods supported:
- Cards: [`Visa, Mastercard`](#cards). If you want to integrate Airwallex API without our Native UI for card payments, then your website is required to be PCI-DSS compliant. 
- E-Wallets: [`Alipay`](#alipay), [`AlipayHK`](#alipayhk), [`DANA`](#dana), [`GCash`](#gcash), [`Kakao Pay`](#kakao-pay), [`Touch ‘n Go`](#touch-n-go), [`WeChat Pay`](#wechat-pay)

### Airwallex Native UI
Airwallex Native UI is a prebuilt UI which enables you to customize the UI color and fit your App theme. You can use these components separately, or pack our prebuilt UI into one flow to present your payment.

## Installation
To install the Plugin, in your `bpubspec.yaml`, add the following:
```yaml
dependencies:
  airwallex_payment_flutter: 0.0.1
```
### Android
We've noticed that with some versions of Gradle, building a release package can lead to these obfuscation issues.
```
E/AndroidRuntime(26598): Caused by: java.lang.IncompatibleClassChangeError: Class 'android.content.res.XmlBlock$Parser' does not implement interface 'q7.a' in call to 'int q7.a.next()' (declaration of 'k0.c' appears in /data/app/~~Ed8ejoXekHz3e7T6xxikvA==/com.example.airwallex_payment_flutter_example-bolBxWvE6SI_ArHfsB-Aow==/base.apk)
E/AndroidRuntime(26598): 	at k0.c.a(SourceFile:1)
E/AndroidRuntime(26598): 	at k0.h.k(SourceFile:1)
E/AndroidRuntime(26598): 	at k0.h.d(SourceFile:1)
E/AndroidRuntime(26598): 	at i0.a.c(SourceFile:1)
E/AndroidRuntime(26598): 	at j.a.a(SourceFile:1)
E/AndroidRuntime(26598): 	at androidx.appcompat.widget.g1.c(SourceFile:1)
E/AndroidRuntime(26598): 	at androidx.appcompat.widget.Toolbar.<init>(SourceFile:2)
E/AndroidRuntime(26598): 	at androidx.appcompat.widget.Toolbar.<init>(SourceFile:1)
```
A common solution is to add the following code to `android/app/gradle.properties`, but this will weaken R8's obfuscation capability.
```
android.enableR8.fullMode=false
```
We recommend adding the following code to `android/app/proguard-rules.pro` to resolve the obfuscation issues.
```
-keep class org.xmlpull.v1.XmlPullParser { *; }
-keep interface org.xmlpull.v1.XmlPullParser { *; }
```
You can also follow the relevant issues on the Flutter official page to get the best solution.[issues/146266](https://github.com/flutter/flutter/issues/146266)

## Initialization
Call the initialize method of the Airwallex Flutter Plugin to initialize the plugin.
```dart
import 'package:airwallex_payment_flutter/airwallex_payment_flutter.dart';
```
```dart
final airwallexPaymentFlutter = AirwallexPaymentFlutter();
airwallexPaymentFlutter.initialize('demo', true, false);
```
parameter `environment` specifies the environment options for the Airwallex Flutter Plugin, which include `staging`, `demo`, and `production`. 
If you are in the testing phase, it is recommended to set the environment to `staging` or `demo` for feature debugging. 
If you are in the production phase, it must be set to `production`.

## Create Payment Intent
Before confirming the `PaymentIntent`, You must create a `PaymentIntent` on the server and pass it to the client.

> Follow these steps to create a PaymentIntent on the Merchant’s server
>1. To begin you will need to obtain an access token to allow you to reach Airwallex API endpoints. Using your unique Client ID and API key (these can be generated within [Account settings > API keys](https://www.airwallex.com/app/settings/api)) you can call the Authentication API endpoint. On success, an access token will be granted.
>
>2. Create customer(optional) allows you to save your customers’ details, attach payment methods so you can quickly retrieve the supported payment methods as your customer checks out on your shopping site. [`/api/v1/pa/customers/create`](https://www.airwallex.com/docs/api#/Payment_Acceptance/Customers/_api_v1_pa_customers_create/post)
>
>3. Finally, you need to create a `PaymentIntent` object on the Merchant’s server via [`/api/v1/pa/payment_intents/create`](https://www.airwallex.com/docs/api#/Payment_Acceptance/Payment_Intents/_api_v1_pa_payment_intents_create/post) and pass it to the client.
>
>4. In the response of each payment intent, you will be returned with client_secret, which you will need to store for later uses.

After creating the payment intent, you need to pass some of the data from the PaymentIntent to the Airwallex Flutter Plugin and enable the shopper to complete the payment using the selected payment method.

## Create Payment Session
Whether you choose to call our UI components or use the lower-level API, you need to create a `PaymentSession` object before making the call. This object contains all the necessary information about the payment.

### Create One Off Session
GooglePayOptions and Shipping are optional, and you can choose whether to pass these parameters based on your needs.
```dart
import 'package:airwallex_payment_flutter/types/payment_session.dart';
import 'package:airwallex_payment_flutter/types/shipping.dart';
import 'package:airwallex_payment_flutter/types/google_pay_options.dart';

static BaseSession createOneOffSession(Map<String, dynamic> paymentIntent) {
  //get paymentIntent from your server, or you can only get paymentIntentId, clientSecret, amount, currency from your server
  final String paymentIntentId = paymentIntent['id'];
  final String clientSecret = paymentIntent['client_secret'];
  final int amount = paymentIntent['amount'];
  final String currency = paymentIntent['currency'];

  return OneOffSession(
    paymentIntentId: paymentIntentId,
    clientSecret: clientSecret,
    amount: amount,
    currency: currency,
    customerId: '',
    // shipping: createShipping(),
    isBillingRequired: true,
    isEmailRequired: false,
    countryCode: 'UK',
    returnUrl: 'airwallexcheckout://com.example.airwallex_payment_flutter_example',
    googlePayOptions: GooglePayOptions(
    billingAddressRequired: true,
    billingAddressParameters: BillingAddressParameters(format: Format.FULL),
    ),
    autoCapture: true,
    hidePaymentConsents: false,
    );
}
```
#### Set up GooglePayOptions
The Airwallex Flutter Plugin allows merchants to provide Google Pay as a payment method to their customers by the following steps:
- Make sure Google Pay is enabled on your Airwallex account.
- You can customize the Google Pay options to restrict as well as provide extra context. For more information, please refer to `GooglePayOptions` class.
```dart
final googlePayOptions = GooglePayOptions(
  billingAddressRequired: true,
  billingAddressParameters: BillingAddressParameters(format: Format.FULL),
)
```
- We currently only support AMEX, DISCOVER, JCB, Visa, and MasterCard for Google Pay, customers will only be able to select the cards of these payment networks during Google Pay.
> Please note that our Google Pay module only supports `OneOffSession` at the moment. We'll add support for recurring payment sessions in the future.

#### Set up returnUrl
Note that if you wish to use redirection to invoke third-party payments, you must provide a returnUrl to determine the page to redirect to after the payment is completed.
#####Android：
```
    <intent-filter>
        ...
        <data
            android:host="${applicationId}"
            android:scheme="airwallexcheckout" />
    </intent-filter>
```
#####iOS：

### Create Recurring Session

```dart
import 'package:airwallex_payment_flutter/types/payment_session.dart';
import 'package:airwallex_payment_flutter/types/shipping.dart';

//get clientSecret and customerId from your server
static BaseSession createRecurringSession(
      String clientSecret, String customerId) {
    return RecurringSession(
      customerId: customerId,
      clientSecret: clientSecret,
      //shipping: createShipping(),
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
```

### Create Recurring With Intent Session

```dart
import 'package:airwallex_payment_flutter/types/payment_session.dart';
import 'package:airwallex_payment_flutter/types/shipping.dart';

//get customerId and paymentIntent from your server
static BaseSession createRecurringWithIntentSession(
      Map<String, dynamic> paymentIntent, String customerId) {
    final String paymentIntentId = paymentIntent['id'];
    final String clientSecret = paymentIntent['client_secret'];
    final double amount = (paymentIntent['amount'] as int).toDouble();
    final String currency = paymentIntent['currency'];

    return RecurringWithIntentSession(
      customerId: customerId,
      clientSecret: clientSecret,
      currency: currency,
      countryCode: 'HK',
      amount: amount,
      paymentIntentId: paymentIntentId,
      // shipping: createShipping(),
      isBillingRequired: true,
      isEmailRequired: false,
      returnUrl:'airwallexcheckout://com.example.airwallex_payment_flutter_example',
      nextTriggeredBy: NextTriggeredBy.Merchant,
      merchantTriggerReason: MerchantTriggerReason.Scheduled,
    );
  }
```

## Airwallex Native UI integration
### Launch payment list page
- Use `presentEntirePaymentFlow` to launch the payment list page and complete the entire payment process
```dart
  final result = await airwallexPaymentFlutter.presentEntirePaymentFlow(paymentSession);
```
### Launch card payment page
- Use `presentCardPaymentFlow` to launch the card payment page and complete the entire payment process.
```kotlin
   final result = await airwallexPaymentFlutter.presentCardPaymentFlow(paymentSession);
```
### Custom Theme
#### Android：
You can overwrite these color values in your app. https://developer.android.com/guide/topics/ui/look-and-feel/themes#CustomizeTheme
Add the following color values in res/values/colors.xml.
```
    <color name="airwallex_tint_color">@color/airwallex_color_red</color>
```
#### iOS：

## Low-level API Integration
### Confirm payment with card details
Create a Card, and then call the `payWithCardDetails` method to complete the payment.
```dart
import 'package:airwallex_payment_flutter/types/card.dart';

static Card createDemoCard() {
    // this card number is for demo environment only
    return Card(
      number: "4012000300001003",
      name: "John Citizen",
      expiryMonth: "12",
      expiryYear: "2029",
      cvc: "737"
    );
  }
```
```dart
final result = await airwallexPaymentFlutter.payWithCardDetails(paymentSession, card);
```
### Google Pay
```dart
final result = await airwallexPaymentFlutter.startGooglePay(paymentSession);
```

## Plugin Example
This sample app demonstrates integrating with the  Airwallex Flutter Plugin using its prebuilt UI components to manage the checkout flow, including specifying a shipping address and selecting a Payment Method.

## Test Card Numbers
https://cardinaldocs.atlassian.net/wiki/spaces/CCen/pages/903577725/EMV+3DS+Test+Cases

## Contributing
We welcome contributions of any kind including new features, bug fixes, and documentation 
