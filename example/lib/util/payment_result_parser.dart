import 'package:airwallex_payment_flutter/types/payment_result.dart';

class PaymentResultParser {
  static PaymentResult parsePaymentResult(Map<String, dynamic> result) {

    switch (result['status']) {
      case 'success':
        return PaymentSuccessResult(
          paymentConsentId: result['consentId'],
        );
      case 'inProgress':
        return PaymentInProgressResult();
      case 'cancelled':
        return PaymentCancelledResult();
      default:
        throw Exception('Unknown status: ${result['status']}');
    }
  }
}
