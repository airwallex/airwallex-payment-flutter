import 'package:json_annotation/json_annotation.dart';
import 'shipping.dart';
import 'apple_pay_options.dart';
import 'google_pay_options.dart';
import 'next_triggered_by.dart';
import 'merchant_trigger_reason.dart';

part 'payment_session.g.dart';

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
  });

  Map<String, dynamic> toJson();
}

@JsonSerializable(explicitToJson: true)
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

@JsonSerializable(explicitToJson: true)
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

@JsonSerializable(explicitToJson: true)
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
