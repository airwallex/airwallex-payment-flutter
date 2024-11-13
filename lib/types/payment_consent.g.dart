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
      requiresCvc: json['requires_cvc'] as bool? ?? false,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      clientSecret: json['client_secret'] as String?,
    );

Map<String, dynamic> _$PaymentConsentToJson(PaymentConsent instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('request_id', instance.requestId);
  writeNotNull('customer_id', instance.customerId);
  writeNotNull('payment_method', instance.paymentMethod?.toJson());
  writeNotNull('status', instance.status);
  writeNotNull(
      'next_triggered_by', _$NextTriggeredByEnumMap[instance.nextTriggeredBy]);
  writeNotNull('merchant_trigger_reason',
      _$MerchantTriggerReasonEnumMap[instance.merchantTriggerReason]);
  val['requires_cvc'] = instance.requiresCvc;
  writeNotNull('created_at', instance.createdAt);
  writeNotNull('updated_at', instance.updatedAt);
  writeNotNull('client_secret', instance.clientSecret);
  return val;
}

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
      customerId: json['customer_id'] as String?,
    );

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('type', instance.type);
  writeNotNull('card', instance.card?.toJson());
  writeNotNull('billing', instance.billing?.toJson());
  writeNotNull('customer_id', instance.customerId);
  return val;
}
