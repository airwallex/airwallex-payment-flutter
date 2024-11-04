// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apple_pay_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplePayOptions _$ApplePayOptionsFromJson(Map<String, dynamic> json) =>
    ApplePayOptions(
      merchantIdentifier: json['merchantIdentifier'] as String,
      supportedNetworks: (json['supportedNetworks'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$ApplePaySupportedNetworkEnumMap, e))
          .toList(),
      additionalPaymentSummaryItems:
          (json['additionalPaymentSummaryItems'] as List<dynamic>?)
              ?.map((e) => CartSummaryItem.fromJson(e as Map<String, dynamic>))
              .toList(),
      merchantCapabilities: (json['merchantCapabilities'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$ApplePayMerchantCapabilityEnumMap, e))
          .toList(),
      requiredBillingContactFields:
          (json['requiredBillingContactFields'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$ContactFieldEnumMap, e))
              .toList(),
      supportedCountries: (json['supportedCountries'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      totalPriceLabel: json['totalPriceLabel'] as String?,
    );

Map<String, dynamic> _$ApplePayOptionsToJson(ApplePayOptions instance) =>
    <String, dynamic>{
      'merchantIdentifier': instance.merchantIdentifier,
      'supportedNetworks': instance.supportedNetworks
          ?.map((e) => _$ApplePaySupportedNetworkEnumMap[e]!)
          .toList(),
      'additionalPaymentSummaryItems': instance.additionalPaymentSummaryItems
          ?.map((e) => e.toJson())
          .toList(),
      'merchantCapabilities': instance.merchantCapabilities
          ?.map((e) => _$ApplePayMerchantCapabilityEnumMap[e]!)
          .toList(),
      'requiredBillingContactFields': instance.requiredBillingContactFields
          ?.map((e) => _$ContactFieldEnumMap[e]!)
          .toList(),
      'supportedCountries': instance.supportedCountries,
      'totalPriceLabel': instance.totalPriceLabel,
    };

const _$ApplePaySupportedNetworkEnumMap = {
  ApplePaySupportedNetwork.visa: 'visa',
  ApplePaySupportedNetwork.masterCard: 'masterCard',
  ApplePaySupportedNetwork.unionPay: 'unionPay',
  ApplePaySupportedNetwork.amex: 'amex',
  ApplePaySupportedNetwork.discover: 'discover',
  ApplePaySupportedNetwork.jcb: 'jcb',
  ApplePaySupportedNetwork.maestro: 'maestro',
};

const _$ApplePayMerchantCapabilityEnumMap = {
  ApplePayMerchantCapability.supports3DS: 'supports3DS',
  ApplePayMerchantCapability.supportsCredit: 'supportsCredit',
  ApplePayMerchantCapability.supportsDebit: 'supportsDebit',
  ApplePayMerchantCapability.supportsEMV: 'supportsEMV',
};

const _$ContactFieldEnumMap = {
  ContactField.emailAddress: 'emailAddress',
  ContactField.name: 'name',
  ContactField.phoneNumber: 'phoneNumber',
  ContactField.phoneticName: 'phoneticName',
  ContactField.postalAddress: 'postalAddress',
};

CartSummaryItem _$CartSummaryItemFromJson(Map<String, dynamic> json) =>
    CartSummaryItem(
      label: json['label'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: $enumDecodeNullable(_$CartSummaryItemTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$CartSummaryItemToJson(CartSummaryItem instance) =>
    <String, dynamic>{
      'label': instance.label,
      'amount': instance.amount,
      'type': _$CartSummaryItemTypeEnumMap[instance.type],
    };

const _$CartSummaryItemTypeEnumMap = {
  CartSummaryItemType.finalType: 'finalType',
  CartSummaryItemType.pendingType: 'pendingType',
};
