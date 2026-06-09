# Airwallex

```dart
class Airwallex
```

## Constructors

### Airwallex()

```dart
Airwallex()
```

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
  return AirwallexPaymentFlutterPlatform.instance
      .payWithCardDetails(session, card, saveCard);
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
  return AirwallexPaymentFlutterPlatform.instance
      .payWithConsent(session, consent);
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
  return AirwallexPaymentFlutterPlatform.instance
      .presentCardPaymentFlow(session, supportedBrands: supportedBrands);
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
  return AirwallexPaymentFlutterPlatform.instance
      .presentEntirePaymentFlow(session, configuration: configuration);
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
  return AirwallexPaymentFlutterPlatform.instance.startApplePay(session);
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
  return AirwallexPaymentFlutterPlatform.instance.startGooglePay(session);
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

## Static Methods

### initialize()

```dart
void initialize({
 Environment environment = Environment.production,
 bool enableLogging = true,
 bool saveLogToLocal = false,
})
```

<details>
<summary>Implementation</summary>

```dart
static void initialize({
    Environment environment = Environment.production, bool enableLogging = true, bool saveLogToLocal = false}) {
  if (enableLogging && kDebugMode) {
    debugPrint('[AirwallexSdk] Current connected environment: ${environment.name}');
  }
  AirwallexPaymentFlutterPlatform.instance.initialize(environment, enableLogging, saveLogToLocal);
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
static void setTintColor(Color color) {
  AirwallexPaymentFlutterPlatform.instance.setTintColor(color);
}
```

</details>