// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_pay_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GooglePayOptions _$GooglePayOptionsFromJson(Map<String, dynamic> json) =>
    GooglePayOptions(
      allowedCardAuthMethods: (json['allowedCardAuthMethods'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      merchantName: json['merchantName'] as String?,
      allowPrepaidCards: json['allowPrepaidCards'] as bool?,
      allowCreditCards: json['allowCreditCards'] as bool?,
      assuranceDetailsRequired: json['assuranceDetailsRequired'] as bool?,
      billingAddressRequired: json['billingAddressRequired'] as bool?,
      billingAddressParameters: json['billingAddressParameters'] == null
          ? null
          : BillingAddressParameters.fromJson(
              json['billingAddressParameters'] as Map<String, dynamic>),
      transactionId: json['transactionId'] as String?,
      totalPriceLabel: json['totalPriceLabel'] as String?,
      checkoutOption: json['checkoutOption'] as String?,
      emailRequired: json['emailRequired'] as bool?,
      shippingAddressRequired: json['shippingAddressRequired'] as bool?,
      shippingAddressParameters: json['shippingAddressParameters'] == null
          ? null
          : ShippingAddressParameters.fromJson(
              json['shippingAddressParameters'] as Map<String, dynamic>),
      allowedCardNetworks: (json['allowedCardNetworks'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      skipReadinessCheck: json['skipReadinessCheck'] as bool?,
    );

Map<String, dynamic> _$GooglePayOptionsToJson(GooglePayOptions instance) =>
    <String, dynamic>{
      'allowedCardAuthMethods': instance.allowedCardAuthMethods,
      'merchantName': instance.merchantName,
      'allowPrepaidCards': instance.allowPrepaidCards,
      'allowCreditCards': instance.allowCreditCards,
      'assuranceDetailsRequired': instance.assuranceDetailsRequired,
      'billingAddressRequired': instance.billingAddressRequired,
      'billingAddressParameters': instance.billingAddressParameters?.toJson(),
      'transactionId': instance.transactionId,
      'totalPriceLabel': instance.totalPriceLabel,
      'checkoutOption': instance.checkoutOption,
      'emailRequired': instance.emailRequired,
      'shippingAddressRequired': instance.shippingAddressRequired,
      'shippingAddressParameters': instance.shippingAddressParameters?.toJson(),
      'allowedCardNetworks': instance.allowedCardNetworks,
      'skipReadinessCheck': instance.skipReadinessCheck,
    };

BillingAddressParameters _$BillingAddressParametersFromJson(
        Map<String, dynamic> json) =>
    BillingAddressParameters(
      format:
          $enumDecodeNullable(_$FormatEnumMap, json['format']) ?? Format.min,
      phoneNumberRequired: json['phoneNumberRequired'] as bool? ?? false,
    );

Map<String, dynamic> _$BillingAddressParametersToJson(
        BillingAddressParameters instance) =>
    <String, dynamic>{
      'format': _$FormatEnumMap[instance.format],
      'phoneNumberRequired': instance.phoneNumberRequired,
    };

const _$FormatEnumMap = {
  Format.min: 'min',
  Format.full: 'full',
};

ShippingAddressParameters _$ShippingAddressParametersFromJson(
        Map<String, dynamic> json) =>
    ShippingAddressParameters(
      allowedCountryCodes: (json['allowedCountryCodes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      phoneNumberRequired: json['phoneNumberRequired'] as bool? ?? false,
    );

Map<String, dynamic> _$ShippingAddressParametersToJson(
        ShippingAddressParameters instance) =>
    <String, dynamic>{
      'allowedCountryCodes': instance.allowedCountryCodes,
      'phoneNumberRequired': instance.phoneNumberRequired,
    };
