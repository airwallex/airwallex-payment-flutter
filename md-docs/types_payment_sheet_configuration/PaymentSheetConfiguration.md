# PaymentSheetConfiguration

```dart
class PaymentSheetConfiguration
```

## Constructors

### PaymentSheetConfiguration()  *(const)*

```dart
const PaymentSheetConfiguration({PaymentLayout layout = PaymentLayout.tab})
```

<details>
<summary>Implementation</summary>

```dart
const PaymentSheetConfiguration({this.layout = PaymentLayout.tab});
```

</details>

## Properties

### hashCode

`int get hashCode`

The hash code for this object.

*(no setter)* *(inherited)*

### layout

`final PaymentLayout layout`

*(final)*

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
Map<String, dynamic> toJson() => {'layout': layout.name};
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