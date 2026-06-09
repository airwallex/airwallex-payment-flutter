# PaymentMethod

```dart
class PaymentMethod
```

**Annotations:** `@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake, includeIfNull: false)`

## Constructors

### PaymentMethod()

```dart
PaymentMethod({
 String? id,
 String? type,
 Card? card,
 Shipping? billing,
 String? customerId,
})
```

<details>
<summary>Implementation</summary>

```dart
PaymentMethod({
  this.id,
  this.type,
  this.card,
  this.billing,
  this.customerId,
});
```

</details>

### PaymentMethod.fromJson()  *(factory)*

```dart
factory PaymentMethod.fromJson(Map<String, dynamic> json)
```

<details>
<summary>Implementation</summary>

```dart
factory PaymentMethod.fromJson(Map<String, dynamic> json) => _$PaymentMethodFromJson(json);
```

</details>

## Properties

### billing

`Shipping? billing`

*(read / write)*

### card

`Card? card`

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

### runtimeType

`Type get runtimeType`

A representation of the runtime type of the object.

*(no setter)* *(inherited)*

### type

`String? type`

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
Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
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