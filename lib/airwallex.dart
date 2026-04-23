import 'dart:ui';

import 'package:airwallex_payment_flutter/types/environment.dart';
import 'package:airwallex_payment_flutter/types/payment_consent.dart';
import 'package:flutter/foundation.dart';

import '/types/card.dart';
import '/types/payment_result.dart';
import '/types/payment_session.dart';

import 'airwallex_payment_flutter_platform_interface.dart';

class Airwallex {
  static void initialize({
      Environment environment = Environment.production, bool enableLogging = true, bool saveLogToLocal = false}) {
    if (enableLogging && kDebugMode) {
      debugPrint('[AirwallexSdk] Current connected environment: ${environment.name}');
    }
    AirwallexPaymentFlutterPlatform.instance.initialize(environment, enableLogging, saveLogToLocal);
  }

  Future<PaymentResult> presentEntirePaymentFlow(BaseSession session) {
    return AirwallexPaymentFlutterPlatform.instance
        .presentEntirePaymentFlow(session);
  }

  Future<PaymentResult> presentCardPaymentFlow(BaseSession session) {
    return AirwallexPaymentFlutterPlatform.instance
        .presentCardPaymentFlow(session);
  }

  Future<PaymentResult> payWithCardDetails(BaseSession session, Card card, bool saveCard) {
    return AirwallexPaymentFlutterPlatform.instance
        .payWithCardDetails(session, card, saveCard);
  }

  Future<PaymentResult> payWithConsent(BaseSession session, PaymentConsent consent) {
    return AirwallexPaymentFlutterPlatform.instance
        .payWithConsent(session, consent);
  }

  Future<PaymentResult> startGooglePay(BaseSession session) {
    return AirwallexPaymentFlutterPlatform.instance.startGooglePay(session);
  }

  Future<PaymentResult> startApplePay(BaseSession session) {
    return AirwallexPaymentFlutterPlatform.instance.startApplePay(session);
  }

  static void setTintColor(Color color) {
    AirwallexPaymentFlutterPlatform.instance.setTintColor(color);
  }
}
