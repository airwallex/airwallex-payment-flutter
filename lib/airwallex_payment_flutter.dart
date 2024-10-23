import '/types/card.dart';
import '/types/payment_result.dart';
import '/types/payment_session.dart';

import 'airwallex_payment_flutter_platform_interface.dart';

class AirwallexPaymentFlutter {
  Future<bool> initialize(
      String environment, bool enableLogging, bool saveLogToLocal) {
    return AirwallexPaymentFlutterPlatform.instance
        .initialize(environment, enableLogging, saveLogToLocal);
  }

  Future<PaymentResult> presentEntirePaymentFlow(BaseSession session) {
    return AirwallexPaymentFlutterPlatform.instance
        .presentEntirePaymentFlow(session);
  }

  Future<PaymentResult> presentCardPaymentFlow(BaseSession session) {
    return AirwallexPaymentFlutterPlatform.instance
        .presentCardPaymentFlow(session);
  }

  Future<PaymentResult> startPayWithCardDetails(BaseSession session, Card card) {
    return AirwallexPaymentFlutterPlatform.instance
        .startPayWithCardDetails(session, card);
  }

  Future<PaymentResult> startGooglePay(BaseSession session) {
    return AirwallexPaymentFlutterPlatform.instance.startGooglePay(session);
  }
}
