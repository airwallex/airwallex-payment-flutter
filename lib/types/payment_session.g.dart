// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
