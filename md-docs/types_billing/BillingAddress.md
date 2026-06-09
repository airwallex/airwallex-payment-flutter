# BillingAddress

```dart
class BillingAddress
```

**Annotations:** `@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)`

## Constructors

### BillingAddress()

```dart
BillingAddress({
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
BillingAddress({this.city, this.countryCode, this.street, this.postcode, this.state});
```

</details>

### BillingAddress.fromJson()  *(factory)*

```dart
factory BillingAddress.fromJson(Map<String, dynamic> json)
```

<details>
<summary>Implementation</summary>

```dart
factory BillingAddress.fromJson(Map<String, dynamic> json) => _$BillingAddressFromJson(json);
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
Map<String, dynamic> toJson() => _$BillingAddressToJson(this);
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