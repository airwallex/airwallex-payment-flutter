# ApplePayOptions

```dart
class ApplePayOptions
```

**Annotations:** `@JsonSerializable(explicitToJson: true)`

## Constructors

### ApplePayOptions()

```dart
ApplePayOptions({
 required String merchantIdentifier,
 List<ApplePaySupportedNetwork>? supportedNetworks,
 List<CartSummaryItem>? additionalPaymentSummaryItems,
 List<ApplePayMerchantCapability>? merchantCapabilities,
 List<ContactField>? requiredBillingContactFields,
 List<String>? supportedCountries,
 String? totalPriceLabel,
})
```

<details>
<summary>Implementation</summary>

```dart
ApplePayOptions({
  required this.merchantIdentifier,
  this.supportedNetworks,
  this.additionalPaymentSummaryItems,
  this.merchantCapabilities,
  this.requiredBillingContactFields,
  this.supportedCountries,
  this.totalPriceLabel,
});
```

</details>

### ApplePayOptions.fromJson()  *(factory)*

```dart
factory ApplePayOptions.fromJson(Map<String, dynamic> json)
```

<details>
<summary>Implementation</summary>

```dart
factory ApplePayOptions.fromJson(Map<String, dynamic> json) => _$ApplePayOptionsFromJson(json);
```

</details>

## Properties

### additionalPaymentSummaryItems

`List<CartSummaryItem>? additionalPaymentSummaryItems`

*(read / write)*

### hashCode

`int get hashCode`

The hash code for this object.

*(no setter)* *(inherited)*

### merchantCapabilities

`List<ApplePayMerchantCapability>? merchantCapabilities`

*(read / write)*

### merchantIdentifier

`String merchantIdentifier`

*(read / write)*

### requiredBillingContactFields

`List<ContactField>? requiredBillingContactFields`

*(read / write)*

### runtimeType

`Type get runtimeType`

A representation of the runtime type of the object.

*(no setter)* *(inherited)*

### supportedCountries

`List<String>? supportedCountries`

*(read / write)*

### supportedNetworks

`List<ApplePaySupportedNetwork>? supportedNetworks`

*(read / write)*

### totalPriceLabel

`String? totalPriceLabel`

*(read / write)*

## Methods

### noSuchMethod()

`dynamic noSuchMethod(Invocation invocation)`

Invoked when a nonexistent method or property is accessed.

*(inherited)*

### toJson()

```dart
Map<String, dynamic> toJson()
```

<details>
<summary>Implementation</summary>

```dart
Map<String, dynamic> toJson() => _$ApplePayOptionsToJson(this);
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