# PaymentResult

```dart
abstract class PaymentResult
```

**Implementers**

- [PaymentCancelledResult](PaymentCancelledResult.md)
- [PaymentInProgressResult](PaymentInProgressResult.md)
- [PaymentSuccessResult](PaymentSuccessResult.md)

*(abstract)*

## Constructors

### PaymentResult()

```dart
PaymentResult(String status)
```

<details>
<summary>Implementation</summary>

```dart
PaymentResult(this.status);
```

</details>

## Properties

### hashCode

`int get hashCode`

The hash code for this object.

*(no setter)* *(inherited)*

### runtimeType

`Type get runtimeType`

A representation of the runtime type of the object.

*(no setter)* *(inherited)*

### status

`final String status`

*(final)*

## Methods

### noSuchMethod()

`dynamic noSuchMethod(Invocation invocation)`

Invoked when a nonexistent method or property is accessed.

*(inherited)*

### toString()

`String toString()`

A string representation of this object.

*(inherited)*

## Operators

### operator ==()

`bool operator ==(Object other)`

The equality operator.

*(inherited)*