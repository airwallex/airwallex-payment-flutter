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

  Future<bool> initialize(
      String environment, bool enableLogging, bool saveLogToLocal) {
    throw UnimplementedError(
        'presentEntirePaymentFlow() has not been implemented.');
  }

  Future<PaymentResult> presentEntirePaymentFlow(BaseSession session) {
    throw UnimplementedError('presentEntirePaymentFlow() has not been implemented.');
  }

  Future<PaymentResult> presentCardPaymentFlow(BaseSession session) {
    throw UnimplementedError('presentEntirePaymentFlow() has not been implemented.');
  }

  Future<PaymentResult> startPayWithCardDetails(BaseSession session, Card card) {
    throw UnimplementedError('presentEntirePaymentFlow() has not been implemented.');
  }

  Future<PaymentResult> startGooglePay(BaseSession session) {
    throw UnimplementedError('presentEntirePaymentFlow() has not been implemented.');
  }
}
