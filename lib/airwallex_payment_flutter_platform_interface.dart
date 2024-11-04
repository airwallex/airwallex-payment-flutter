import 'package:airwallex_payment_flutter/types/payment_consent.dart';

import '/types/card.dart';
import '/types/payment_result.dart';
import '/types/payment_session.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'airwallex_payment_flutter_method_channel.dart';

abstract class AirwallexPaymentFlutterPlatform extends PlatformInterface {
  /// Constructs a AirwallexPaymentFlutterPlatform.
  AirwallexPaymentFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static AirwallexPaymentFlutterPlatform _instance = MethodChannelAirwallexPaymentFlutter();

  /// The default instance of [AirwallexPaymentFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelAirwallexPaymentFlutter].
  static AirwallexPaymentFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AirwallexPaymentFlutterPlatform] when
  /// they register themselves.
  static set instance(AirwallexPaymentFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initialize(
      String environment, bool enableLogging, bool saveLogToLocal) {
    throw UnimplementedError(
        'presentEntirePaymentFlow() has not been implemented.');
  }

  Future<PaymentResult> presentEntirePaymentFlow(BaseSession session) {
    throw UnimplementedError('presentEntirePaymentFlow() has not been implemented.');
  }

  Future<PaymentResult> presentCardPaymentFlow(BaseSession session) {
    throw UnimplementedError('presentCardPaymentFlow() has not been implemented.');
  }

  Future<PaymentResult> payWithCardDetails(BaseSession session, Card card, bool saveCard) {
    throw UnimplementedError('payWithCardDetails() has not been implemented.');
  }

  Future<PaymentResult> payWithConsent(BaseSession session, PaymentConsent consent) {
    throw UnimplementedError('payWithConsent() has not been implemented.');
  }

  Future<PaymentResult> startGooglePay(BaseSession session) {
    throw UnimplementedError('startGooglePay() has not been implemented.');
  }

  Future<PaymentResult> startApplePay(BaseSession session) {
    throw UnimplementedError('startApplePay() has not been implemented.');
  }
}
