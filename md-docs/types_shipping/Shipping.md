# Shipping

```dart
class Shipping
```

**Annotations:** `@JsonSerializable(explicitToJson: true)`

## Constructors

### Shipping()

```dart
Shipping({
 String? firstName,
 String? lastName,
 String? phoneNumber,
 String? shippingMethod,
 String? email,
 String? dateOfBirth,
 ShippingAddress? address,
})
```

<details>
<summary>Implementation</summary>

```dart
Shipping({
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

### Shipping.fromJson()  *(factory)*

```dart
factory Shipping.fromJson(Map<String, dynamic> json)
```

<details>
<summary>Implementation</summary>

```dart
factory Shipping.fromJson(Map<String, dynamic> json) => _$ShippingFromJson(json);
```

</details>

## Properties

### address

`ShippingAddress? address`

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
Map<String, dynamic> toJson() => _$ShippingToJson(this);
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