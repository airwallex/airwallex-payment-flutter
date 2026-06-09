# PaymentConsent

```dart
class PaymentConsent
```

**Annotations:** `@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake, includeIfNull: false)`

## Constructors

### PaymentConsent()

```dart
PaymentConsent({
 String? id,
 String? requestId,
 String? customerId,
 PaymentMethod? paymentMethod,
 String? status,
 NextTriggeredBy? nextTriggeredBy,
 MerchantTriggerReason? merchantTriggerReason,
 bool requiresCvc = false,
 String? createdAt,
 String? updatedAt,
 String? clientSecret,
})
```

<details>
<summary>Implementation</summary>

```dart
PaymentConsent({
  this.id,
  this.requestId,
  this.customerId,
  this.paymentMethod,
  this.status,
  this.nextTriggeredBy,
  this.merchantTriggerReason,
  &#47;&#47; ignore: deprecated_member_use_from_same_package
  this.requiresCvc = false,
  this.createdAt,
  this.updatedAt,
  this.clientSecret,
});
```

</details>

### PaymentConsent.fromJson()  *(factory)*

```dart
factory PaymentConsent.fromJson(Map<String, dynamic> json)
```

<details>
<summary>Implementation</summary>

```dart
factory PaymentConsent.fromJson(Map<String, dynamic> json) => _$PaymentConsentFromJson(json);
```

</details>

## Properties

### clientSecret

`String? clientSecret`

*(read / write)*

### createdAt

`String? createdAt`

*(read / write)*

### customerId

`String? customerId`

*(read / write)*

### hashCode

`int get hashCode`

The hash code for this object.

*(no setter)* *(inherited)*

### id

`String? id`

*(read / write)*

### merchantTriggerReason

`MerchantTriggerReason? merchantTriggerReason`

*(read / write)*

### nextTriggeredBy

`NextTriggeredBy? nextTriggeredBy`

*(read / write)*

### paymentMethod

`PaymentMethod? paymentMethod`

*(read / write)*

### requestId

`String? requestId`

*(read / write)*

### ~~requiresCvc~~

`bool requiresCvc`

**DEPRECATED**

*(deprecated)* *(read / write)*

### runtimeType

`Type get runtimeType`

A representation of the runtime type of the object.

*(no setter)* *(inherited)*

### status

`String? status`

*(read / write)*

### updatedAt

`String? updatedAt`

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
Map<String, dynamic> toJson() => _$PaymentConsentToJson(this);
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