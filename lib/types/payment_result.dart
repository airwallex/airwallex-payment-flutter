abstract class PaymentResult {
  final String status;
  PaymentResult(this.status);
}

class PaymentSuccessResult extends PaymentResult {
  final String? paymentConsentId;

  PaymentSuccessResult({this.paymentConsentId})
      : super('success');
}

class PaymentInProgressResult extends PaymentResult {
  PaymentInProgressResult() : super('inProgress');
}

class PaymentCancelledResult extends PaymentResult {
  PaymentCancelledResult() : super('cancelled');
}