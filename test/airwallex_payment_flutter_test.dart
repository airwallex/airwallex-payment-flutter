import 'package:airwallex_payment_flutter/airwallex_payment_flutter_method_channel.dart';
import 'package:airwallex_payment_flutter/airwallex_payment_flutter_platform_interface.dart';
import 'package:airwallex_payment_flutter/types/card.dart';
import 'package:airwallex_payment_flutter/types/environment.dart';
import 'package:airwallex_payment_flutter/types/payment_consent.dart';
import 'package:airwallex_payment_flutter/types/payment_result.dart';
import 'package:airwallex_payment_flutter/types/payment_session.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAirwallexPaymentFlutterPlatform
    with MockPlatformInterfaceMixin
    implements AirwallexPaymentFlutterPlatform {
  @override
  void initialize(
      Environment environment, bool enableLogging, bool saveLogToLocal) {
    throw UnimplementedError();
  }

  @override
  Future<PaymentResult> presentCardPaymentFlow(BaseSession session) {
    throw UnimplementedError();
  }

  @override
  Future<PaymentResult> presentEntirePaymentFlow(BaseSession session) {
    throw UnimplementedError();
  }

  @override
  Future<PaymentResult> startGooglePay(BaseSession session) {
    throw UnimplementedError();
  }

  @override
  Future<PaymentResult> startApplePay(BaseSession session) {
    throw UnimplementedError();
  }

  @override
  Future<PaymentResult> payWithCardDetails(
      BaseSession session, Card card, bool saveCard) {
    throw UnimplementedError();
  }

  @override
  Future<PaymentResult> payWithConsent(
      BaseSession session, PaymentConsent consent) {
    throw UnimplementedError();
  }

  @override
  void setTintColor(Color color) {
    throw UnimplementedError();
  }
}

void main() {
  final AirwallexPaymentFlutterPlatform initialPlatform =
      AirwallexPaymentFlutterPlatform.instance;

  test('$MethodChannelAirwallexPaymentFlutter is the default instance', () {
    expect(
        initialPlatform, isInstanceOf<MethodChannelAirwallexPaymentFlutter>());
  });
}
