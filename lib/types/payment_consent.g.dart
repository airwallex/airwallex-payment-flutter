// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_consent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentConsent _$PaymentConsentFromJson(Map<String, dynamic> json) =>
    PaymentConsent(
      id: json['id'] as String?,
      requestId: json['request_id'] as String?,
      customerId: json['customer_id'] as String?,
      paymentMethod: json['payment_method'] == null
          ? null
          : PaymentMethod.fromJson(
              json['payment_method'] as Map<String, dynamic>),
      status: json['status'] as String?,
      nextTriggeredBy: $enumDecodeNullable(
          _$NextTriggeredByEnumMap, json['next_triggered_by']),
      merchantTriggerReason: $enumDecodeNullable(
          _$MerchantTriggerReasonEnumMap, json['merchant_trigger_reason']),
      requiresCvc: json['requiresCvc'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      clientSecret: json['client_secret'] as String?,
    );

Map<String, dynamic> _$PaymentConsentToJson(PaymentConsent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requestId': instance.requestId,
      'customerId': instance.customerId,
      'paymentMethod': instance.paymentMethod?.toJson(),
      'status': instance.status,
      'nextTriggeredBy': _$NextTriggeredByEnumMap[instance.nextTriggeredBy],
      'merchantTriggerReason':
          _$MerchantTriggerReasonEnumMap[instance.merchantTriggerReason],
      'requiresCvc': instance.requiresCvc,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'clientSecret': instance.clientSecret,
    };

const _$NextTriggeredByEnumMap = {
  NextTriggeredBy.merchant: 'merchant',
  NextTriggeredBy.customer: 'customer',
};

const _$MerchantTriggerReasonEnumMap = {
  MerchantTriggerReason.unscheduled: 'unscheduled',
  MerchantTriggerReason.scheduled: 'scheduled',
};

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    PaymentMethod(
      id: json['id'] as String?,
      type: json['type'] as String?,
      card: json['card'] == null
          ? null
          : Card.fromJson(json['card'] as Map<String, dynamic>),
      billing: json['billing'] == null
          ? null
          : Shipping.fromJson(json['billing'] as Map<String, dynamic>),
      customerId: json['customerId'] as String?,
    );

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'card': instance.card?.toJson(),
      'billing': instance.billing?.toJson(),
      'customerId': instance.customerId,
    };
