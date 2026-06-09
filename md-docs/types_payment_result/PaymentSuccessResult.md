# PaymentSuccessResult

```dart
class PaymentSuccessResult extends PaymentResult
```

**Inheritance**

Object → [PaymentResult](PaymentResult.md) → **PaymentSuccessResult**

## Constructors

### PaymentSuccessResult()

```dart
PaymentSuccessResult({String? paymentConsentId})
```

<details>
<summary>Implementation</summary>

```dart
PaymentSuccessResult({this.paymentConsentId})
    : super('success');
```

</details>

## Properties

### hashCode

`int get hashCode`

The hash code for this object.

*(no setter)* *(inherited)*

### paymentConsentId

`final String? paymentConsentId`

*(final)*

### runtimeType

`Type get runtimeType`

A representation of the runtime type of the object.

*(no setter)* *(inherited)*

### status

`final String status`

*Inherited from PaymentResult.*

*(final)* *(inherited)*

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