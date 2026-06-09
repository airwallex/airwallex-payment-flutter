# AirwallexPaymentFlutterPlatform

```dart
abstract class AirwallexPaymentFlutterPlatform extends PlatformInterface
```

**Inheritance**

Object → PlatformInterface → **AirwallexPaymentFlutterPlatform**

**Implementers**

- [MethodChannelAirwallexPaymentFlutter](../airwallex_payment_flutter_method_channel/MethodChannelAirwallexPaymentFlutter.md)

*(abstract)*

## Constructors

### AirwallexPaymentFlutterPlatform()

```dart
AirwallexPaymentFlutterPlatform()
```

Constructs a AirwallexPaymentFlutterPlatform.

<details>
<summary>Implementation</summary>

```dart
AirwallexPaymentFlutterPlatform() : super(token: _token);
```

</details>

## Properties

### hashCode

`int get hashCode`

The hash code for this object.

*(no setter)* *(inherited)*

### runtimeType

`Type get runtimeType`

A representation of the runtime type of the object.

*(no setter)* *(inherited)*

## Methods

### initialize()

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
void initialize(
    Environment environment, bool enableLogging, bool saveLogToLocal) {
  throw UnimplementedError('initialize() has not been implemented.');
}
```

</details>

### noSuchMethod()

`dynamic noSuchMethod(Invocation invocation)`

Invoked when a nonexistent method or property is accessed.

*(inherited)*

### payWithCardDetails()

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
Future<PaymentResult> payWithCardDetails(BaseSession session, Card card, bool saveCard) {
  throw UnimplementedError('payWithCardDetails() has not been implemented.');
}
```

</details>

### payWithConsent()

```dart
Future<PaymentResult> payWithConsent(
 BaseSession session,
 PaymentConsent consent,
)
```

<details>
<summary>Implementation</summary>

```dart
Future<PaymentResult> payWithConsent(BaseSession session, PaymentConsent consent) {
  throw UnimplementedError('payWithConsent() has not been implemented.');
}
```

</details>

### presentCardPaymentFlow()

```dart
Future<PaymentResult> presentCardPaymentFlow(
 BaseSession session, {
 List<CardBrand>? supportedBrands,
})
```

<details>
<summary>Implementation</summary>

```dart
Future<PaymentResult> presentCardPaymentFlow(
  BaseSession session, {
  List<CardBrand>? supportedBrands,
}) {
  throw UnimplementedError('presentCardPaymentFlow() has not been implemented.');
}
```

</details>

### presentEntirePaymentFlow()

```dart
Future<PaymentResult> presentEntirePaymentFlow(
 BaseSession session, {
 PaymentSheetConfiguration? configuration,
})
```

<details>
<summary>Implementation</summary>

```dart
Future<PaymentResult> presentEntirePaymentFlow(
  BaseSession session, {
  PaymentSheetConfiguration? configuration,
}) {
  throw UnimplementedError('presentEntirePaymentFlow() has not been implemented.');
}
```

</details>

### setTintColor()

```dart
void setTintColor(Color color)
```

<details>
<summary>Implementation</summary>

```dart
void setTintColor(Color color) {
  throw UnimplementedError('setTintColor() has not been implemented.');
}
```

</details>

### startApplePay()

```dart
Future<PaymentResult> startApplePay(BaseSession session)
```

<details>
<summary>Implementation</summary>

```dart
Future<PaymentResult> startApplePay(BaseSession session) {
  throw UnimplementedError('startApplePay() has not been implemented.');
}
```

</details>

### startGooglePay()

```dart
Future<PaymentResult> startGooglePay(BaseSession session)
```

<details>
<summary>Implementation</summary>

```dart
Future<PaymentResult> startGooglePay(BaseSession session) {
  throw UnimplementedError('startGooglePay() has not been implemented.');
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

## Static Properties

### instance  *(read / write)*

```dart
AirwallexPaymentFlutterPlatform get instance
```

**getter:**

The default instance of [AirwallexPaymentFlutterPlatform](AirwallexPaymentFlutterPlatform.md) to use.

Defaults to [MethodChannelAirwallexPaymentFlutter](../airwallex_payment_flutter_method_channel/MethodChannelAirwallexPaymentFlutter.md).

**setter:**

Platform-specific implementations should set this with their own
platform-specific class that extends [AirwallexPaymentFlutterPlatform](AirwallexPaymentFlutterPlatform.md) when
they register themselves.

<details>
<summary>Implementation</summary>

```dart
static AirwallexPaymentFlutterPlatform get instance => _instance;

static set instance(AirwallexPaymentFlutterPlatform instance) {
  PlatformInterface.verifyToken(instance, _token);
  _instance = instance;
}
```

</details>