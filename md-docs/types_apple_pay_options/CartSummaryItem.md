# CartSummaryItem

```dart
class CartSummaryItem
```

**Annotations:** `@JsonSerializable()`

## Constructors

### CartSummaryItem()

```dart
CartSummaryItem({
 required String label,
 required double amount,
 CartSummaryItemType? type,
})
```

<details>
<summary>Implementation</summary>

```dart
CartSummaryItem({
  required this.label,
  required this.amount,
  this.type,
});
```

</details>

### CartSummaryItem.fromJson()  *(factory)*

```dart
factory CartSummaryItem.fromJson(Map<String, dynamic> json)
```

<details>
<summary>Implementation</summary>

```dart
factory CartSummaryItem.fromJson(Map<String, dynamic> json) => _$CartSummaryItemFromJson(json);
```

</details>

## Properties

### amount

`double amount`

*(read / write)*

### hashCode

`int get hashCode`

The hash code for this object.

*(no setter)* *(inherited)*

### label

`String label`

*(read / write)*

### runtimeType

`Type get runtimeType`

A representation of the runtime type of the object.

*(no setter)* *(inherited)*

### type

`CartSummaryItemType? type`

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
Map<String, dynamic> toJson() => _$CartSummaryItemToJson(this);
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