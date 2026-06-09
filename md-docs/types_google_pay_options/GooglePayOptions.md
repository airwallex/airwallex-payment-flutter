# GooglePayOptions

```dart
class GooglePayOptions
```

**Annotations:** `@JsonSerializable(explicitToJson: true)`

## Constructors

### GooglePayOptions()

```dart
GooglePayOptions({
 List<String>? allowedCardAuthMethods,
 String? merchantName,
 bool? allowPrepaidCards,
 bool? allowCreditCards,
 bool? assuranceDetailsRequired,
 bool? billingAddressRequired,
 BillingAddressParameters? billingAddressParameters,
 String? transactionId,
 String? totalPriceLabel,
 String? checkoutOption,
 bool? emailRequired,
 bool? shippingAddressRequired,
 ShippingAddressParameters? shippingAddressParameters,
 List<String>? allowedCardNetworks,
 bool? skipReadinessCheck,
})
```

<details>
<summary>Implementation</summary>

```dart
GooglePayOptions({
  this.allowedCardAuthMethods,
  this.merchantName,
  this.allowPrepaidCards,
  this.allowCreditCards,
  this.assuranceDetailsRequired,
  this.billingAddressRequired,
  this.billingAddressParameters,
  this.transactionId,
  this.totalPriceLabel,
  this.checkoutOption,
  this.emailRequired,
  this.shippingAddressRequired,
  this.shippingAddressParameters,
  List<String>? allowedCardNetworks,
  this.skipReadinessCheck,
}) : allowedCardNetworks =
          allowedCardNetworks ?? googlePaySupportedNetworks();
```

</details>

### GooglePayOptions.fromJson()  *(factory)*

```dart
factory GooglePayOptions.fromJson(Map<String, dynamic> json)
```

<details>
<summary>Implementation</summary>

```dart
factory GooglePayOptions.fromJson(Map<String, dynamic> json) => _$GooglePayOptionsFromJson(json);
```

</details>

## Properties

### allowCreditCards

`bool? allowCreditCards`

*(read / write)*

### allowedCardAuthMethods

`List<String>? allowedCardAuthMethods`

*(read / write)*

### allowedCardNetworks

`List<String> allowedCardNetworks`

*(read / write)*

### allowPrepaidCards

`bool? allowPrepaidCards`

*(read / write)*

### assuranceDetailsRequired

`bool? assuranceDetailsRequired`

*(read / write)*

### billingAddressParameters

`BillingAddressParameters? billingAddressParameters`

*(read / write)*

### billingAddressRequired

`bool? billingAddressRequired`

*(read / write)*

### checkoutOption

`String? checkoutOption`

*(read / write)*

### emailRequired

`bool? emailRequired`

*(read / write)*

### hashCode

`int get hashCode`

The hash code for this object.

*(no setter)* *(inherited)*

### merchantName

`String? merchantName`

*(read / write)*

### runtimeType

`Type get runtimeType`

A representation of the runtime type of the object.

*(no setter)* *(inherited)*

### shippingAddressParameters

`ShippingAddressParameters? shippingAddressParameters`

*(read / write)*

### shippingAddressRequired

`bool? shippingAddressRequired`

*(read / write)*

### skipReadinessCheck

`bool? skipReadinessCheck`

*(read / write)*

### totalPriceLabel

`String? totalPriceLabel`

*(read / write)*

### transactionId

`String? transactionId`

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
Map<String, dynamic> toJson() => _$GooglePayOptionsToJson(this);
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