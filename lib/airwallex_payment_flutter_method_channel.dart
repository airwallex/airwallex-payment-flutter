import 'package:airwallex_payment_flutter/types/payment_consent.dart';
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
      const MethodChannel('samples.flutter.dev/airwallex_payment', JSONMethodCodec());

  @override
  Future<void> initialize(
      String environment, bool enableLogging, bool saveLogToLocal) async {
    await methodChannel.invokeMethod('initialize', {
      'environment': environment,
      'enableLogging': enableLogging,
      'saveLogToLocal': saveLogToLocal,
    });
  }

  @override
  Future<PaymentResult> presentEntirePaymentFlow(BaseSession session) async {
    final result = await methodChannel
        .invokeMethod('presentEntirePaymentFlow', {'session': session.toJson()});
    return parsePaymentResult(result);
  }

  @override
  Future<PaymentResult> presentCardPaymentFlow(BaseSession session) async {
    final result = await methodChannel
        .invokeMethod('presentCardPaymentFlow', {'session': session.toJson()});
    return parsePaymentResult(result);
  }

  @override
  Future<PaymentResult> payWithCardDetails(
      BaseSession session, Card card, bool saveCard) async {
    final result = await methodChannel.invokeMethod('payWithCardDetails', {
      'session': session.toJson(),
      'card': card.toMap(),
      'saveCard': saveCard,
    });
    return parsePaymentResult(result);
  }

  @override
  Future<PaymentResult> payWithConsent(
      BaseSession session, PaymentConsent consent) {
    // TODO: implement payWithConsent
    return super.payWithConsent(session, consent);
  }

  @override
  Future<PaymentResult> startGooglePay(BaseSession session) async {
    final result = await methodChannel
        .invokeMethod('startGooglePay', {'session': session.toJson()});
    return parsePaymentResult(result);
  }

  @override
  Future<PaymentResult> startApplePay(BaseSession session) async {
    final result = await methodChannel
        .invokeMethod('startApplePay', {'session': session.toJson()});
    return parsePaymentResult(result);
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
