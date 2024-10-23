import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'airwallex_payment_flutter_platform_interface.dart';
import 'types/card.dart';
import 'types/payment_result.dart';
import 'types/payment_session.dart';

/// An implementation of [AirwallexPaymentFlutterPlatform] that uses method channels.
class MethodChannelAirwallexPaymentFlutter
    extends AirwallexPaymentFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('samples.flutter.dev/airwallex_payment');

  @override
  Future<bool> initialize(
      String environment, bool enableLogging, bool saveLogToLocal) async {
    try {
      await methodChannel.invokeMethod<String>('initialize', {
        'environment': environment,
        'enableLogging': enableLogging,
        'saveLogToLocal': saveLogToLocal,
      });
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaymentResult> presentEntirePaymentFlow(BaseSession session) async {
    try {
      final result = await methodChannel.invokeMethod<Map<Object?, Object?>>(
          'presentEntirePaymentFlow', session.toMap());
      return parsePaymentResult(result?.cast<String, dynamic>());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaymentResult> presentCardPaymentFlow(BaseSession session) async {
    try {
      final result = await methodChannel.invokeMethod<Map<Object?, Object?>>(
          'presentCardPaymentFlow', session.toMap());
      return parsePaymentResult(result?.cast<String, dynamic>());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaymentResult> startPayWithCardDetails(
      BaseSession session, Card card) async {
    try {
      final result = await methodChannel
          .invokeMethod<Map<Object?, Object?>>('startPayWithCardDetails', {
        ...session.toMap(),
        ...card.toMap(),
      });
      return parsePaymentResult(result?.cast<String, dynamic>());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaymentResult> startGooglePay(BaseSession session) async {
    try {
      final result = await methodChannel.invokeMethod<Map<Object?, Object?>>(
          'startGooglePay', session.toMap());
      return parsePaymentResult(result?.cast<String, dynamic>());
    } catch (e) {
      rethrow;
    }
  }

  PaymentResult parsePaymentResult(Map<String, dynamic>? result) {
    if (result == null) {
      throw Exception('Result is null');
    }
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
