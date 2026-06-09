# BaseSession

```dart
abstract class BaseSession
```

**Implementers**

- [OneOffSession](OneOffSession.md)
- [RecurringSession](RecurringSession.md)
- [RecurringWithIntentSession](RecurringWithIntentSession.md)

*(abstract)*

## Constructors

### BaseSession()

```dart
BaseSession({
 required String type,
 required String clientSecret,
 String? customerId,
 Shipping? shipping,
 bool? isBillingRequired,
 bool? isEmailRequired,
 required String currency,
 required String countryCode,
 required double amount,
 String? returnUrl,
 GooglePayOptions? googlePayOptions,
 ApplePayOptions? applePayOptions,
 List<String>? paymentMethods,
})
```

<details>
<summary>Implementation</summary>

```dart
BaseSession({
  required this.type,
  required this.clientSecret,
  this.customerId,
  this.shipping,
  this.isBillingRequired,
  this.isEmailRequired,
  required this.currency,
  required this.countryCode,
  required this.amount,
  this.returnUrl,
  this.googlePayOptions,
  this.applePayOptions,
  this.paymentMethods,
}) : assert(customerId == null || customerId.isNotEmpty,
          'customerId must not be an empty string');
```

</details>

## Properties

### amount

`double amount`

*(read / write)*

### applePayOptions

`ApplePayOptions? applePayOptions`

*(read / write)*

### clientSecret

`String clientSecret`

*(read / write)*

### countryCode

`String countryCode`

*(read / write)*

### currency

`String currency`

*(read / write)*

### customerId

`String? customerId`

*(read / write)*

### googlePayOptions

`GooglePayOptions? googlePayOptions`

*(read / write)*

### hashCode

`int get hashCode`

The hash code for this object.

*(no setter)* *(inherited)*

### isBillingRequired

`bool? isBillingRequired`

*(read / write)*

### isEmailRequired

`bool? isEmailRequired`

*(read / write)*

### paymentMethods

`List<String>? paymentMethods`

*(read / write)*

### returnUrl

`String? returnUrl`

*(read / write)*

### runtimeType

`Type get runtimeType`

A representation of the runtime type of the object.

*(no setter)* *(inherited)*

### shipping

`Shipping? shipping`

*(read / write)*

### type

`String type`

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

### toString()

`String toString()`

A string representation of this object.

*(inherited)*

## Operators

### operator ==()

`bool operator ==(Object other)`

The equality operator.

*(inherited)*