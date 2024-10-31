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
      final result = await methodChannel.invokeMethod(
          'presentEntirePaymentFlow', {'session': session.toMap()});
      return parsePaymentResult(result);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaymentResult> presentCardPaymentFlow(BaseSession session) async {
    try {
      final result = await methodChannel
          .invokeMethod('presentCardPaymentFlow', {'session': session.toMap()});
      return parsePaymentResult(result);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaymentResult> payWithCardDetails(
      BaseSession session, Card card, bool saveCard) async {
    try {
      final result =
          await methodChannel.invokeMethod('payWithCardDetails', {
        'session': session.toMap(),
        'card': card.toMap(),
        'saveCard': saveCard,
      });
      return parsePaymentResult(result);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaymentResult> startGooglePay(BaseSession session) async {
    try {
      final result = await methodChannel
          .invokeMethod('startGooglePay', {'session': session.toMap()});
      return parsePaymentResult(result);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaymentResult> startApplePay(BaseSession session) async {
    try {
      final result = await methodChannel
          .invokeMethod('startApplePay', {'session': session.toMap()});
      return parsePaymentResult(result);
    } catch (e) {
      rethrow;
    }
  }

  PaymentResult parsePaymentResult(result) {
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
