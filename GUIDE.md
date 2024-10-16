# Airwallex Flutter Plugin
The Airwallex Flutter Plugin is a flexible tool that allows you to integrate payment methods into your Flutter application. It also includes a pre-built UI, giving you the flexibility to use any part of it while replacing the rest with your own UI.

This section will guide you through the process of integrating the Airwallex Flutter Plugin. We assume that you are a Flutter developer familiar with the integration and use of Flutter plugins.

Our demo is open source on [Github](https://github.com/airwallex/airwallex-payment-flutter),which can help you better understand how to integrate the Airwallex Flutter Plugin into your Flutter project.

## Contents
* [Overview](#Overview)
    * [Airwallex API](#airwallex-api)
    * [Airwallex Native UI](#airwallex-native-ui)
* [Installation](#Installation)
* [Environment](#Environment)
    * [Android Configuration](#android-configuration)
    * [iOS Configuration](#ios-configuration)
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
## Environment
The Airwallex Flutter Plugin allows setting up three environments: `staging`, `demo`, and `production`.
If you are in the testing phase, it is recommended to set the environment to `staging` or `demo` for functionality debugging. If you are in the production phase, you must set it to `production`. 
The method of setting the environment differs across platforms.

#### Android Configuration:
For the Android platform, by default, the release build uses the `production` environment, and the debug build uses the `demo` environment.
If you need to change the environment, you must manually specify it during the build phase with the following command:
```
flutter build apk --debug -Penv=staging
```
This command generates an APK for the specified environment, which you need to manually install on the device.

#### iOS Configuration:

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

static Map<String, dynamic> createOneOffSession(Map<String, dynamic> paymentIntent) {
  //get paymentIntent from your server, or you can only get paymentIntentId, clientSecret, amount, currency from your server
  final String paymentIntentId = paymentIntent['id'];
  final String clientSecret = paymentIntent['client_secret'];
  final int amount = paymentIntent['amount'];
  final String currency = paymentIntent['currency'];

  final paramMap = OneOffSession(
    paymentIntentId: paymentIntentId,
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
    ).toMap();
    paramMap['clientSecret'] = clientSecret;
  return paramMap;
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
The current version does not support passing the RecurringSessions object, but this feature will be supported in upcoming versions.

### Create Recurring With Intent Session
The current version does not support passing the RecurringWithIntentSession object, but this feature will be supported in upcoming versions.

## Airwallex Native UI integration
### Launch payment list page
- Use `presentEntirePaymentFlow` to launch the payment list page and complete the entire payment process
```dart
   final result = await platform.invokeMethod('presentEntirePaymentFlow', paymentSession);
```
### Launch card payment page
- Use `presentCardPaymentFlow` to launch the card payment page and complete the entire payment process.
```kotlin
   final result = await platform.invokeMethod('presentCardPaymentFlow', paymentSession);
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
Create a Card, and then call the `startPayWithCardDetails` method to complete the payment.
```dart
import 'package:airwallex_payment_flutter/types/card.dart';

static Map<String, dynamic> createDemoCard() {
    final card = Card(
      number: "4012000300001003",
      name: "John Citizen",
      expiryMonth: "12",
      expiryYear: "2029",
      cvc: "737"
    );

    return card.toMap();
  }
```
```dart
final params = {
        ...paymentSession,
        ...cardParams,
      };
final result = await platform.invokeMethod('startPayWithCardDetails', params);
```

## Plugin Example
This sample app demonstrates integrating with the  Airwallex Flutter Plugin using its prebuilt UI components to manage the checkout flow, including specifying a shipping address and selecting a Payment Method.

## Test Card Numbers
https://cardinaldocs.atlassian.net/wiki/spaces/CCen/pages/903577725/EMV+3DS+Test+Cases

## Contributing
We welcome contributions of any kind including new features, bug fixes, and documentation 
