// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Card _$CardFromJson(Map<String, dynamic> json) => Card(
      cvc: json['cvc'] as String?,
      expiryMonth: json['expiry_month'] as String?,
      expiryYear: json['expiry_year'] as String?,
      name: json['name'] as String?,
      number: json['number'] as String?,
      bin: json['bin'] as String?,
      last4: json['last4'] as String?,
      brand: json['brand'] as String?,
      country: json['country'] as String?,
      funding: json['funding'] as String?,
      fingerprint: json['fingerprint'] as String?,
      cvcCheck: json['cvc_check'] as String?,
      avsCheck: json['avs_check'] as String?,
      issuerCountryCode: json['issuer_country_code'] as String?,
      numberType: json['number_type'] as String?,
    );

Map<String, dynamic> _$CardToJson(Card instance) => <String, dynamic>{
      'cvc': instance.cvc,
      'expiry_month': instance.expiryMonth,
      'expiry_year': instance.expiryYear,
      'name': instance.name,
      'number': instance.number,
      'bin': instance.bin,
      'last4': instance.last4,
      'brand': instance.brand,
      'country': instance.country,
      'funding': instance.funding,
      'fingerprint': instance.fingerprint,
      'cvc_check': instance.cvcCheck,
      'avs_check': instance.avsCheck,
      'issuer_country_code': instance.issuerCountryCode,
      'number_type': instance.numberType,
    };
