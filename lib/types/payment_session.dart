import 'package:json_annotation/json_annotation.dart';
import 'shipping.dart';
import 'apple_pay_options.dart';
import 'google_pay_options.dart';
import 'next_triggered_by.dart';
import 'merchant_trigger_reason.dart';

part 'payment_session.g.dart';

/// Base class for every payment session. A session bundles the authentication
/// (`clientSecret`), amount and currency, customer details, and optional wallet
/// configuration into the single value passed to every payment flow method.
///
/// Pick a concrete subclass based on what the merchant wants to do:
/// - `OneOffSession` — charge the customer once.
/// - `RecurringSession` — save a payment method for future recurring charges, without charging now.
/// - `RecurringWithIntentSession` — charge now AND save the payment method for future recurring charges.
abstract class BaseSession {
  String type;
  String? customerId;
  String clientSecret;
  Shipping? shipping;
  bool? isBillingRequired;
  bool? isEmailRequired;
  String currency;
  String countryCode;
  double amount;
  String? returnUrl;
  GooglePayOptions? googlePayOptions;
  ApplePayOptions? applePayOptions;
  List<String>? paymentMethods;

  BaseSession({
    required this.type,
    required this.clientSecret,
    this.customerId,
    this.shipping,
    this.isBillingRequired,
    this.isEmailRequired,
    required this.currency,
    required this.countryCode,
    required this.amount,
    this.returnUrl,
    this.googlePayOptions,
    this.applePayOptions,
    this.paymentMethods,
  }) : assert(customerId == null || customerId.isNotEmpty,
            'customerId must not be an empty string');

  Map<String, dynamic> toJson();
}

/// A one-off payment against a payment intent.
@JsonSerializable(explicitToJson: true, createFactory: false)
class OneOffSession extends BaseSession {
  String paymentIntentId;
  bool? autoCapture;
  bool? hidePaymentConsents;

  OneOffSession({
    super.customerId,
    required super.clientSecret,
    super.shipping,
    super.isBillingRequired,
    super.isEmailRequired,
    required super.currency,
    required super.countryCode,
    required super.amount,
    super.returnUrl,
    super.googlePayOptions,
    super.applePayOptions,
    super.paymentMethods,
    required this.paymentIntentId,
    this.autoCapture,
    this.hidePaymentConsents,
  }) : super(type: 'OneOff');

  @override
  Map<String, dynamic> toJson() => _$OneOffSessionToJson(this);
}

/// A session that sets up a payment consent for future recurring charges
/// without charging the customer right now.
@JsonSerializable(explicitToJson: true, createFactory: false)
class RecurringSession extends BaseSession {
  NextTriggeredBy nextTriggeredBy;
  MerchantTriggerReason merchantTriggerReason;

  RecurringSession({
    super.customerId,
    required super.clientSecret,
    super.shipping,
    super.isBillingRequired,
    super.isEmailRequired,
    required super.currency,
    required super.countryCode,
    required super.amount,
    super.returnUrl,
    super.googlePayOptions,
    super.applePayOptions,
    super.paymentMethods,
    required this.nextTriggeredBy,
    required this.merchantTriggerReason,
  }) : super(type: 'Recurring');

  @override
  Map<String, dynamic> toJson() => _$RecurringSessionToJson(this);
}

/// A session that charges a payment intent now and sets up a payment consent
/// for future recurring charges in a single step.
@JsonSerializable(explicitToJson: true, createFactory: false)
class RecurringWithIntentSession extends BaseSession {
  String paymentIntentId;
  bool? autoCapture;
  NextTriggeredBy nextTriggeredBy;
  MerchantTriggerReason merchantTriggerReason;

  RecurringWithIntentSession({
    super.customerId,
    required super.clientSecret,
    super.shipping,
    super.isBillingRequired,
    super.isEmailRequired,
    required super.currency,
    required super.countryCode,
    required super.amount,
    super.returnUrl,
    super.googlePayOptions,
    super.applePayOptions,
    super.paymentMethods,
    required this.paymentIntentId,
    this.autoCapture,
    required this.nextTriggeredBy,
    required this.merchantTriggerReason,
  }) : super(type: 'RecurringWithIntent');

  @override
  Map<String, dynamic> toJson() => _$RecurringWithIntentSessionToJson(this);
}
