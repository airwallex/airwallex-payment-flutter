/// The outcome of a payment flow. Discriminated by `status`:
/// `'success'`, `'inProgress'`, or `'cancelled'`.
///
/// Errors are not represented here — they are surfaced by the returned `Future` failing.
abstract class PaymentResult {
  final String status;
  PaymentResult(this.status);
}

/// The payment completed successfully. If a payment consent was created during the
/// flow, its id is returned in `paymentConsentId`.
class PaymentSuccessResult extends PaymentResult {
  final String? paymentConsentId;

  PaymentSuccessResult({this.paymentConsentId})
      : super('success');
}

/// The payment has been submitted but its final outcome is not yet known.
/// The merchant should poll the payment intent or wait for a webhook to confirm the result.
class PaymentInProgressResult extends PaymentResult {
  PaymentInProgressResult() : super('inProgress');
}

/// The customer cancelled the payment flow before it completed.
class PaymentCancelledResult extends PaymentResult {
  PaymentCancelledResult() : super('cancelled');
}