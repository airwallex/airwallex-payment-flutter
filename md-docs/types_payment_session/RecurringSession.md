# RecurringSession

```dart
class RecurringSession extends BaseSession
```

**Annotations:** `@JsonSerializable(explicitToJson: true)`

**Inheritance**

Object → [BaseSession](BaseSession.md) → **RecurringSession**

## Constructors

### RecurringSession()

```dart
RecurringSession({
 String? customerId,
 required String clientSecret,
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
 required NextTriggeredBy nextTriggeredBy,
 required MerchantTriggerReason merchantTriggerReason,
})
```

<details>
<summary>Implementation</summary>

```dart
RecurringSession({
  super.customerId,
  required super.clientSecret,
  super.shipping,
  super.isBillingRequired,
  super.isEmailRequired,
  required super.currency,
  required super.countryCode,
  required super.amount,
  super.returnUrl,
  super.googlePayOptions,
  super.applePayOptions,
  super.paymentMethods,
  required this.nextTriggeredBy,
  required this.merchantTriggerReason,
}) : super(type: 'Recurring');
```

</details>

## Properties

### amount

`double amount`

*Inherited from BaseSession.*

*(read / write)* *(inherited)*

### applePayOptions

`ApplePayOptions? applePayOptions`

*Inherited from BaseSession.*

*(read / write)* *(inherited)*

### clientSecret

`String clientSecret`

*Inherited from BaseSession.*

*(read / write)* *(inherited)*

### countryCode

`String countryCode`

*Inherited from BaseSession.*

*(read / write)* *(inherited)*

### currency

`String currency`

*Inherited from BaseSession.*

*(read / write)* *(inherited)*

### customerId

`String? customerId`

*Inherited from BaseSession.*

*(read / write)* *(inherited)*

### googlePayOptions

`GooglePayOptions? googlePayOptions`

*Inherited from BaseSession.*

*(read / write)* *(inherited)*

### hashCode

`int get hashCode`

The hash code for this object.

*(no setter)* *(inherited)*

### isBillingRequired

`bool? isBillingRequired`

*Inherited from BaseSession.*

*(read / write)* *(inherited)*

### isEmailRequired

`bool? isEmailRequired`

*Inherited from BaseSession.*

*(read / write)* *(inherited)*

### merchantTriggerReason

`MerchantTriggerReason merchantTriggerReason`

*(read / write)*

### nextTriggeredBy

`NextTriggeredBy nextTriggeredBy`

*(read / write)*

### paymentMethods

`List<String>? paymentMethods`

*Inherited from BaseSession.*

*(read / write)* *(inherited)*

### returnUrl

`String? returnUrl`

*Inherited from BaseSession.*

*(read / write)* *(inherited)*

### runtimeType

`Type get runtimeType`

A representation of the runtime type of the object.

*(no setter)* *(inherited)*

### shipping

`Shipping? shipping`

*Inherited from BaseSession.*

*(read / write)* *(inherited)*

### type

`String type`

*Inherited from BaseSession.*

*(read / write)* *(inherited)*

## Methods

### noSuchMethod()

`dynamic noSuchMethod(Invocation invocation)`

Invoked when a nonexistent method or property is accessed.

*(inherited)*

### toJson()  *(override)*

```dart
Map<String, dynamic> toJson()
```

<details>
<summary>Implementation</summary>

```dart
@override
Map<String, dynamic> toJson() => _$RecurringSessionToJson(this);
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