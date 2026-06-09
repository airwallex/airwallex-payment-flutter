# ShippingAddressParameters

```dart
class ShippingAddressParameters
```

**Annotations:** `@JsonSerializable()`

## Constructors

### ShippingAddressParameters()

```dart
ShippingAddressParameters({
 List<String>? allowedCountryCodes,
 bool? phoneNumberRequired = false,
})
```

<details>
<summary>Implementation</summary>

```dart
ShippingAddressParameters({
  this.allowedCountryCodes,
  this.phoneNumberRequired = false,
});
```

</details>

### ShippingAddressParameters.fromJson()  *(factory)*

```dart
factory ShippingAddressParameters.fromJson(Map<String, dynamic> json)
```

<details>
<summary>Implementation</summary>

```dart
factory ShippingAddressParameters.fromJson(Map<String, dynamic> json) => _$ShippingAddressParametersFromJson(json);
```

</details>

## Properties

### allowedCountryCodes

`List<String>? allowedCountryCodes`

*(read / write)*

### hashCode

`int get hashCode`

The hash code for this object.

*(no setter)* *(inherited)*

### phoneNumberRequired

`bool? phoneNumberRequired`

*(read / write)*

### runtimeType

`Type get runtimeType`

A representation of the runtime type of the object.

*(no setter)* *(inherited)*

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
Map<String, dynamic> toJson() => _$ShippingAddressParametersToJson(this);
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