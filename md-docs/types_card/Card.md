# Card

```dart
class Card
```

**Annotations:** `@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)`

## Constructors

### Card()

```dart
Card({
 String? cvc,
 String? expiryMonth,
 String? expiryYear,
 String? name,
 String? number,
 String? bin,
 String? last4,
 String? brand,
 String? country,
 String? funding,
 String? fingerprint,
 String? cvcCheck,
 String? avsCheck,
 String? issuerCountryCode,
 String? numberType,
})
```

<details>
<summary>Implementation</summary>

```dart
Card({
  this.cvc,
  this.expiryMonth,
  this.expiryYear,
  this.name,
  this.number,
  this.bin,
  this.last4,
  this.brand,
  this.country,
  this.funding,
  this.fingerprint,
  this.cvcCheck,
  this.avsCheck,
  this.issuerCountryCode,
  this.numberType,
});
```

</details>

### Card.fromJson()  *(factory)*

```dart
factory Card.fromJson(Map<String, dynamic> json)
```

<details>
<summary>Implementation</summary>

```dart
factory Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);
```

</details>

## Properties

### avsCheck

`String? avsCheck`

*(read / write)*

### bin

`String? bin`

*(read / write)*

### brand

`String? brand`

*(read / write)*

### country

`String? country`

*(read / write)*

### cvc

`String? cvc`

*(read / write)*

### cvcCheck

`String? cvcCheck`

*(read / write)*

### expiryMonth

`String? expiryMonth`

*(read / write)*

### expiryYear

`String? expiryYear`

*(read / write)*

### fingerprint

`String? fingerprint`

*(read / write)*

### funding

`String? funding`

*(read / write)*

### hashCode

`int get hashCode`

The hash code for this object.

*(no setter)* *(inherited)*

### issuerCountryCode

`String? issuerCountryCode`

*(read / write)*

### last4

`String? last4`

*(read / write)*

### name

`String? name`

*(read / write)*

### number

`String? number`

*(read / write)*

### numberType

`String? numberType`

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
Map<String, dynamic> toJson() => _$CardToJson(this);
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