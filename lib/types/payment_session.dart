import 'shipping.dart';
import 'apple_pay_options.dart';
import 'google_pay_options.dart';
import 'next_triggered_by.dart';
import 'merchant_trigger_reason.dart';

class BaseSession {
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
    this.customerId,
    required this.clientSecret,
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

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'clientSecret': clientSecret,
      'shipping': shipping?.toMap(),
      'isBillingRequired': isBillingRequired,
      'isEmailRequired': isEmailRequired,
      'currency': currency,
      'countryCode': countryCode,
      'amount': amount,
      'returnUrl': returnUrl,
      'googlePayOptions': googlePayOptions?.toMap(),
      'applePayOptions': applePayOptions?.toMap(),
      'paymentMethods': paymentMethods,
    };
  }
}

class OneOffSession extends BaseSession {
  final String type = 'OneOff';
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
  });

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'type': type,
      'paymentIntentId': paymentIntentId,
      'autoCapture': autoCapture,
      'hidePaymentConsents': hidePaymentConsents,
    });
    return map;
  }
}

class RecurringSession extends BaseSession {
  final String type = 'Recurring';
  NextTriggeredBy nextTriggeredBy;
  MerchantTriggerReason merchantTriggerReason;

  RecurringSession({
    required super.customerId,
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
  });

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'type': type,
      'nextTriggeredBy': nextTriggeredBy.toMap(),
      'merchantTriggerReason': merchantTriggerReason.toMap(),
    });
    return map;
  }
}

class RecurringWithIntentSession extends BaseSession {
  final String type = 'RecurringWithIntent';
  String paymentIntentId;
  bool? autoCapture;
  NextTriggeredBy nextTriggeredBy;
  MerchantTriggerReason merchantTriggerReason;

  RecurringWithIntentSession({
    required super.customerId,
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
  });

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'type': type,
      'paymentIntentId': paymentIntentId,
      'autoCapture': autoCapture,
      'nextTriggeredBy': nextTriggeredBy.toMap(),
      'merchantTriggerReason': merchantTriggerReason.toMap(),
    });
    return map;
  }
}