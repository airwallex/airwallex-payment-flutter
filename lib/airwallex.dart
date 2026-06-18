/// Public API for the Airwallex Flutter payment plugin.
///
/// Import this library to initialize the SDK and present payment flows
/// (full checkout sheet, card-only flow, Google Pay, Apple Pay) from your
/// Flutter app. See [Airwallex] for the entry-point class.
library;

import 'dart:ui';

import 'package:airwallex_payment_flutter/types/environment.dart';
import 'package:airwallex_payment_flutter/types/payment_consent.dart';
import 'package:flutter/foundation.dart';

import '/types/card.dart';
import '/types/card_brand.dart';
import '/types/payment_result.dart';
import '/types/payment_session.dart';
import '/types/payment_sheet_configuration.dart';

import 'airwallex_payment_flutter_platform_interface.dart';

/// Entry point for the Airwallex payment SDK.
///
/// Call [Airwallex.initialize] once at app startup, then use instance
/// methods such as [presentEntirePaymentFlow], [presentCardPaymentFlow],
/// [payWithCardDetails], [startGooglePay], or [startApplePay] to drive
/// individual payments.
class Airwallex {
  /// Initializes the Airwallex SDK. Call this once at app startup before invoking any other payment method.
  ///
  /// @param environment - The Airwallex environment to connect to. Defaults to `Environment.production`.
  /// @param enableLogging - When `true`, the SDK emits logs to the console. Android only. Defaults to `true`.
  /// @param saveLogToLocal - When `true`, logs are also persisted to a local file for debugging. Defaults to `false`.
  static void initialize(
      {Environment environment = Environment.production,
      bool enableLogging = true,
      bool saveLogToLocal = false}) {
    if (enableLogging && kDebugMode) {
      debugPrint(
          '[AirwallexSdk] Current connected environment: ${environment.name}');
    }
    AirwallexPaymentFlutterPlatform.instance
        .initialize(environment, enableLogging, saveLogToLocal);
  }

  /// Presents the full Airwallex payment sheet, letting the customer pick any supported payment method
  /// (cards, wallets, redirect methods) and complete the payment.
  ///
  /// @param session - The payment session describing the intent, amount, currency, and customer.
  /// @param configuration - Optional UI configuration for the payment sheet (e.g. layout).
  /// @returns The result of the payment attempt.
  Future<PaymentResult> presentEntirePaymentFlow(
    BaseSession session, {
    PaymentSheetConfiguration? configuration,
  }) {
    return AirwallexPaymentFlutterPlatform.instance
        .presentEntirePaymentFlow(session, configuration: configuration);
  }

  /// Presents the card-only payment sheet. Use this when the merchant wants to restrict checkout
  /// to card payments and skip the payment-method selection screen.
  ///
  /// @param session - The payment session describing the intent, amount, currency, and customer.
  /// @param supportedBrands - Optional list of card brands to accept. When `null`, all supported brands are accepted.
  /// @returns The result of the payment attempt.
  Future<PaymentResult> presentCardPaymentFlow(
    BaseSession session, {
    List<CardBrand>? supportedBrands,
  }) {
    return AirwallexPaymentFlutterPlatform.instance
        .presentCardPaymentFlow(session, supportedBrands: supportedBrands);
  }

  /// Pays with raw card details collected by the merchant's own UI. The merchant is responsible
  /// for PCI compliance when using this method.
  ///
  /// @param session - The payment session describing the intent, amount, currency, and customer.
  /// @param card - The card details to charge.
  /// @param saveCard - When `true`, the card is saved as a payment consent for future use.
  /// @returns The result of the payment attempt.
  Future<PaymentResult> payWithCardDetails(
      BaseSession session, Card card, bool saveCard) {
    return AirwallexPaymentFlutterPlatform.instance
        .payWithCardDetails(session, card, saveCard);
  }

  /// Pays using an existing payment consent (a previously saved card).
  ///
  /// @param session - The payment session describing the intent, amount, currency, and customer.
  /// @param consent - The payment consent to charge.
  /// @returns The result of the payment attempt.
  Future<PaymentResult> payWithConsent(
      BaseSession session, PaymentConsent consent) {
    return AirwallexPaymentFlutterPlatform.instance
        .payWithConsent(session, consent);
  }

  /// Starts a Google Pay payment flow. Android only.
  ///
  /// @param session - The payment session. Must include `googlePayOptions` for the merchant configuration.
  /// @returns The result of the payment attempt.
  Future<PaymentResult> startGooglePay(BaseSession session) {
    return AirwallexPaymentFlutterPlatform.instance.startGooglePay(session);
  }

  /// Starts an Apple Pay payment flow. iOS only.
  ///
  /// @param session - The payment session. Must include `applePayOptions` for the merchant configuration.
  /// @returns The result of the payment attempt.
  Future<PaymentResult> startApplePay(BaseSession session) {
    return AirwallexPaymentFlutterPlatform.instance.startApplePay(session);
  }

  /// Sets the tint color used by the native payment UI on iOS.
  /// On Android, override the `airwallex_tint_color` resource instead.
  ///
  /// @param color - The tint color to apply.
  static void setTintColor(Color color) {
    AirwallexPaymentFlutterPlatform.instance.setTintColor(color);
  }
}
