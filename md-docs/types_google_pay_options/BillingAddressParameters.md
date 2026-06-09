# BillingAddressParameters

```dart
class BillingAddressParameters
```

**Annotations:** `@JsonSerializable()`

## Constructors

### BillingAddressParameters()

```dart
BillingAddressParameters({
 Format? format = Format.min,
 bool? phoneNumberRequired = false,
})
```

<details>
<summary>Implementation</summary>

```dart
BillingAddressParameters({
  this.format = Format.min,
  this.phoneNumberRequired = false,
});
```

</details>

### BillingAddressParameters.fromJson()  *(factory)*

```dart
factory BillingAddressParameters.fromJson(Map<String, dynamic> json)
```

<details>
<summary>Implementation</summary>

```dart
factory BillingAddressParameters.fromJson(Map<String, dynamic> json) => _$BillingAddressParametersFromJson(json);
```

</details>

## Properties

### format

`Format? format`

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
Map<String, dynamic> toJson() => _$BillingAddressParametersToJson(this);
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