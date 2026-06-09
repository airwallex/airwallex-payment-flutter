# Billing

```dart
class Billing
```

**Annotations:** `@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake, includeIfNull: false)`

## Constructors

### Billing()

```dart
Billing({
 String? firstName,
 String? lastName,
 String? phoneNumber,
 String? shippingMethod,
 String? email,
 String? dateOfBirth,
 BillingAddress? address,
})
```

<details>
<summary>Implementation</summary>

```dart
Billing({
  this.firstName,
  this.lastName,
  this.phoneNumber,
  this.shippingMethod,
  this.email,
  this.dateOfBirth,
  this.address,
});
```

</details>

### Billing.fromJson()  *(factory)*

```dart
factory Billing.fromJson(Map<String, dynamic> json)
```

<details>
<summary>Implementation</summary>

```dart
factory Billing.fromJson(Map<String, dynamic> json) => _$BillingFromJson(json);
```

</details>

## Properties

### address

`BillingAddress? address`

*(read / write)*

### dateOfBirth

`String? dateOfBirth`

*(read / write)*

### email

`String? email`

*(read / write)*

### firstName

`String? firstName`

*(read / write)*

### hashCode

`int get hashCode`

The hash code for this object.

*(no setter)* *(inherited)*

### lastName

`String? lastName`

*(read / write)*

### phoneNumber

`String? phoneNumber`

*(read / write)*

### runtimeType

`Type get runtimeType`

A representation of the runtime type of the object.

*(no setter)* *(inherited)*

### shippingMethod

`String? shippingMethod`

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
Map<String, dynamic> toJson() => _$BillingToJson(this);
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