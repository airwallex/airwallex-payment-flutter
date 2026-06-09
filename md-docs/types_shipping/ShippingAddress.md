# ShippingAddress

```dart
class ShippingAddress
```

**Annotations:** `@JsonSerializable()`

## Constructors

### ShippingAddress()

```dart
ShippingAddress({
 String? city,
 String? countryCode,
 String? street,
 String? postcode,
 String? state,
})
```

<details>
<summary>Implementation</summary>

```dart
ShippingAddress({this.city, this.countryCode, this.street, this.postcode, this.state});
```

</details>

### ShippingAddress.fromJson()  *(factory)*

```dart
factory ShippingAddress.fromJson(Map<String, dynamic> json)
```

<details>
<summary>Implementation</summary>

```dart
factory ShippingAddress.fromJson(Map<String, dynamic> json) => _$ShippingAddressFromJson(json);
```

</details>

## Properties

### city

`String? city`

*(read / write)*

### countryCode

`String? countryCode`

*(read / write)*

### hashCode

`int get hashCode`

The hash code for this object.

*(no setter)* *(inherited)*

### postcode

`String? postcode`

*(read / write)*

### runtimeType

`Type get runtimeType`

A representation of the runtime type of the object.

*(no setter)* *(inherited)*

### state

`String? state`

*(read / write)*

### street

`String? street`

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
Map<String, dynamic> toJson() => _$ShippingAddressToJson(this);
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