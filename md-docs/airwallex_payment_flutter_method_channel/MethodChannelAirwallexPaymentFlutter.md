# MethodChannelAirwallexPaymentFlutter

```dart
class MethodChannelAirwallexPaymentFlutter extends AirwallexPaymentFlutterPlatform
```

An implementation of [AirwallexPaymentFlutterPlatform](../airwallex_payment_flutter_platform_interface/AirwallexPaymentFlutterPlatform.md) that uses method channels.

**Inheritance**

Object → PlatformInterface → [AirwallexPaymentFlutterPlatform](../airwallex_payment_flutter_platform_interface/AirwallexPaymentFlutterPlatform.md) → **MethodChannelAirwallexPaymentFlutter**

## Constructors

### MethodChannelAirwallexPaymentFlutter()

```dart
MethodChannelAirwallexPaymentFlutter()
```

## Properties

### hashCode

`int get hashCode`

The hash code for this object.

*(no setter)* *(inherited)*

### methodChannel

`final MethodChannel methodChannel`

The method channel used to interact with the native platform.

*(final)*

### runtimeType

`Type get runtimeType`

A representation of the runtime type of the object.

*(no setter)* *(inherited)*

## Methods

### initialize()  *(override)*

```dart
void initialize(
 Environment environment,
 bool enableLogging,
 bool saveLogToLocal,
)
```

<details>
<summary>Implementation</summary>

```dart
@override
void initialize(
    Environment environment, bool enableLogging, bool saveLogToLocal) {
  methodChannel.invokeMethod('initialize', {
    'environment': environment.name,
    'enableLogging': enableLogging,
    'saveLogToLocal': saveLogToLocal,
  });
}
```

</details>

### noSuchMethod()

`dynamic noSuchMethod(Invocation invocation)`

Invoked when a nonexistent method or property is accessed.

*(inherited)*

### parsePaymentResult()

```dart
PaymentResult parsePaymentResult(dynamic result)
```

<details>
<summary>Implementation</summary>

```dart
PaymentResult parsePaymentResult(result) {
  if (result == null) {
    throw Exception('Result is null');
  }
  switch (result['status']) {
    case 'success':
      return PaymentSuccessResult(
        paymentConsentId: result['consentId'],
      );
    case 'inProgress':
      return PaymentInProgressResult();
    case 'cancelled':
      return PaymentCancelledResult();
    default:
      throw Exception('Unknown status: ${result['status']}');
  }
}
```

</details>

### payWithCardDetails()  *(override)*

```dart
Future<PaymentResult> payWithCardDetails(
 BaseSession session,
 Card card,
 bool saveCard,
)
```

<details>
<summary>Implementation</summary>

```dart
@override
Future<PaymentResult> payWithCardDetails(
    BaseSession session, Card card, bool saveCard) async {
  final result = await methodChannel.invokeMethod('payWithCardDetails', {
    'session': session.toJson(),
    'card': card.toJson(),
    'saveCard': saveCard,
  });
  return parsePaymentResult(result);
}
```

</details>

### payWithConsent()  *(override)*

```dart
Future<PaymentResult> payWithConsent(
 BaseSession session,
 PaymentConsent consent,
)
```

<details>
<summary>Implementation</summary>

```dart
@override
Future<PaymentResult> payWithConsent(
    BaseSession session, PaymentConsent consent) async {
  final result = await methodChannel.invokeMethod('payWithConsent', {
    'session': session.toJson(),
    'consent': consent.toJson(),
  });
  return parsePaymentResult(result);
}
```

</details>

### presentCardPaymentFlow()  *(override)*

```dart
Future<PaymentResult> presentCardPaymentFlow(
 BaseSession session, {
 List<CardBrand>? supportedBrands,
})
```

<details>
<summary>Implementation</summary>

```dart
@override
Future<PaymentResult> presentCardPaymentFlow(
  BaseSession session, {
  List<CardBrand>? supportedBrands,
}) async {
  final result = await methodChannel.invokeMethod('presentCardPaymentFlow', {
    'session': session.toJson(),
    if (supportedBrands != null && supportedBrands.isNotEmpty)
      'supportedBrands': supportedBrands.map((b) => b.value).toList(),
  });
  return parsePaymentResult(result);
}
```

</details>

### presentEntirePaymentFlow()  *(override)*

```dart
Future<PaymentResult> presentEntirePaymentFlow(
 BaseSession session, {
 PaymentSheetConfiguration? configuration,
})
```

<details>
<summary>Implementation</summary>

```dart
@override
Future<PaymentResult> presentEntirePaymentFlow(
  BaseSession session, {
  PaymentSheetConfiguration? configuration,
}) async {
  final result = await methodChannel.invokeMethod(
      'presentEntirePaymentFlow', {
    'session': session.toJson(),
    if (configuration != null) 'configuration': configuration.toJson(),
  });
  return parsePaymentResult(result);
}
```

</details>

### setTintColor()  *(override)*

```dart
void setTintColor(Color color)
```

<details>
<summary>Implementation</summary>

```dart
@override
void setTintColor(Color color) {
  if (Platform.isIOS) {
    &#47;&#47; ignore: deprecated_member_use
    methodChannel.invokeMethod('setTintColor', {
      'red': color.red, &#47;&#47; ignore: deprecated_member_use
      'green': color.green, &#47;&#47; ignore: deprecated_member_use
      'blue': color.blue, &#47;&#47; ignore: deprecated_member_use
      'alpha': color.alpha, &#47;&#47; ignore: deprecated_member_use
    });
  }
}
```

</details>

### startApplePay()  *(override)*

```dart
Future<PaymentResult> startApplePay(BaseSession session)
```

<details>
<summary>Implementation</summary>

```dart
@override
Future<PaymentResult> startApplePay(BaseSession session) async {
  final result = await methodChannel
      .invokeMethod('startApplePay', {'session': session.toJson()});
  return parsePaymentResult(result);
}
```

</details>

### startGooglePay()  *(override)*

```dart
Future<PaymentResult> startGooglePay(BaseSession session)
```

<details>
<summary>Implementation</summary>

```dart
@override
Future<PaymentResult> startGooglePay(BaseSession session) async {
  final result = await methodChannel
      .invokeMethod('startGooglePay', {'session': session.toJson()});
  return parsePaymentResult(result);
}
```

</details>

### toString()

`String toString()`

A string representation of this object.

*(inherited)*

## Operators

### operator ==()

`bool operator ==(Object other)`

The equality operator.

*(inherited)*