// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OneOffSession _$OneOffSessionFromJson(Map<String, dynamic> json) =>
    OneOffSession(
      customerId: json['customerId'] as String?,
      clientSecret: json['clientSecret'] as String,
      shipping: json['shipping'] == null
          ? null
          : Shipping.fromJson(json['shipping'] as Map<String, dynamic>),
      isBillingRequired: json['isBillingRequired'] as bool?,
      isEmailRequired: json['isEmailRequired'] as bool?,
      currency: json['currency'] as String,
      countryCode: json['countryCode'] as String,
      amount: (json['amount'] as num).toDouble(),
      returnUrl: json['returnUrl'] as String?,
      googlePayOptions: json['googlePayOptions'] == null
          ? null
          : GooglePayOptions.fromJson(
              json['googlePayOptions'] as Map<String, dynamic>),
      applePayOptions: json['applePayOptions'] == null
          ? null
          : ApplePayOptions.fromJson(
              json['applePayOptions'] as Map<String, dynamic>),
      paymentMethods: (json['paymentMethods'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      paymentIntentId: json['paymentIntentId'] as String,
      autoCapture: json['autoCapture'] as bool?,
      hidePaymentConsents: json['hidePaymentConsents'] as bool?,
    )..type = json['type'] as String;

Map<String, dynamic> _$OneOffSessionToJson(OneOffSession instance) =>
    <String, dynamic>{
      'type': instance.type,
      'customerId': instance.customerId,
      'clientSecret': instance.clientSecret,
      'shipping': instance.shipping?.toJson(),
      'isBillingRequired': instance.isBillingRequired,
      'isEmailRequired': instance.isEmailRequired,
      'currency': instance.currency,
      'countryCode': instance.countryCode,
      'amount': instance.amount,
      'returnUrl': instance.returnUrl,
      'googlePayOptions': instance.googlePayOptions?.toJson(),
      'applePayOptions': instance.applePayOptions?.toJson(),
      'paymentMethods': instance.paymentMethods,
      'paymentIntentId': instance.paymentIntentId,
      'autoCapture': instance.autoCapture,
      'hidePaymentConsents': instance.hidePaymentConsents,
    };

RecurringSession _$RecurringSessionFromJson(Map<String, dynamic> json) =>
    RecurringSession(
      customerId: json['customerId'] as String?,
      clientSecret: json['clientSecret'] as String,
      shipping: json['shipping'] == null
          ? null
          : Shipping.fromJson(json['shipping'] as Map<String, dynamic>),
      isBillingRequired: json['isBillingRequired'] as bool?,
      isEmailRequired: json['isEmailRequired'] as bool?,
      currency: json['currency'] as String,
      countryCode: json['countryCode'] as String,
      amount: (json['amount'] as num).toDouble(),
      returnUrl: json['returnUrl'] as String?,
      googlePayOptions: json['googlePayOptions'] == null
          ? null
          : GooglePayOptions.fromJson(
              json['googlePayOptions'] as Map<String, dynamic>),
      applePayOptions: json['applePayOptions'] == null
          ? null
          : ApplePayOptions.fromJson(
              json['applePayOptions'] as Map<String, dynamic>),
      paymentMethods: (json['paymentMethods'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      nextTriggeredBy:
          $enumDecode(_$NextTriggeredByEnumMap, json['nextTriggeredBy']),
      merchantTriggerReason: $enumDecode(
          _$MerchantTriggerReasonEnumMap, json['merchantTriggerReason']),
    )..type = json['type'] as String;

Map<String, dynamic> _$RecurringSessionToJson(RecurringSession instance) =>
    <String, dynamic>{
      'type': instance.type,
      'customerId': instance.customerId,
      'clientSecret': instance.clientSecret,
      'shipping': instance.shipping?.toJson(),
      'isBillingRequired': instance.isBillingRequired,
      'isEmailRequired': instance.isEmailRequired,
      'currency': instance.currency,
      'countryCode': instance.countryCode,
      'amount': instance.amount,
      'returnUrl': instance.returnUrl,
      'googlePayOptions': instance.googlePayOptions?.toJson(),
      'applePayOptions': instance.applePayOptions?.toJson(),
      'paymentMethods': instance.paymentMethods,
      'nextTriggeredBy': _$NextTriggeredByEnumMap[instance.nextTriggeredBy]!,
      'merchantTriggerReason':
          _$MerchantTriggerReasonEnumMap[instance.merchantTriggerReason]!,
    };

const _$NextTriggeredByEnumMap = {
  NextTriggeredBy.merchant: 'merchant',
  NextTriggeredBy.customer: 'customer',
};

const _$MerchantTriggerReasonEnumMap = {
  MerchantTriggerReason.unscheduled: 'unscheduled',
  MerchantTriggerReason.scheduled: 'scheduled',
};

RecurringWithIntentSession _$RecurringWithIntentSessionFromJson(
        Map<String, dynamic> json) =>
    RecurringWithIntentSession(
      customerId: json['customerId'] as String?,
      clientSecret: json['clientSecret'] as String,
      shipping: json['shipping'] == null
          ? null
          : Shipping.fromJson(json['shipping'] as Map<String, dynamic>),
      isBillingRequired: json['isBillingRequired'] as bool?,
      isEmailRequired: json['isEmailRequired'] as bool?,
      currency: json['currency'] as String,
      countryCode: json['countryCode'] as String,
      amount: (json['amount'] as num).toDouble(),
      returnUrl: json['returnUrl'] as String?,
      googlePayOptions: json['googlePayOptions'] == null
          ? null
          : GooglePayOptions.fromJson(
              json['googlePayOptions'] as Map<String, dynamic>),
      applePayOptions: json['applePayOptions'] == null
          ? null
          : ApplePayOptions.fromJson(
              json['applePayOptions'] as Map<String, dynamic>),
      paymentMethods: (json['paymentMethods'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      paymentIntentId: json['paymentIntentId'] as String,
      autoCapture: json['autoCapture'] as bool?,
      nextTriggeredBy:
          $enumDecode(_$NextTriggeredByEnumMap, json['nextTriggeredBy']),
      merchantTriggerReason: $enumDecode(
          _$MerchantTriggerReasonEnumMap, json['merchantTriggerReason']),
    )..type = json['type'] as String;

Map<String, dynamic> _$RecurringWithIntentSessionToJson(
        RecurringWithIntentSession instance) =>
    <String, dynamic>{
      'type': instance.type,
      'customerId': instance.customerId,
      'clientSecret': instance.clientSecret,
      'shipping': instance.shipping?.toJson(),
      'isBillingRequired': instance.isBillingRequired,
      'isEmailRequired': instance.isEmailRequired,
      'currency': instance.currency,
      'countryCode': instance.countryCode,
      'amount': instance.amount,
      'returnUrl': instance.returnUrl,
      'googlePayOptions': instance.googlePayOptions?.toJson(),
      'applePayOptions': instance.applePayOptions?.toJson(),
      'paymentMethods': instance.paymentMethods,
      'paymentIntentId': instance.paymentIntentId,
      'autoCapture': instance.autoCapture,
      'nextTriggeredBy': _$NextTriggeredByEnumMap[instance.nextTriggeredBy]!,
      'merchantTriggerReason':
          _$MerchantTriggerReasonEnumMap[instance.merchantTriggerReason]!,
    };
