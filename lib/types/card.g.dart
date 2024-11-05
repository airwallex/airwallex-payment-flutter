// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Card _$CardFromJson(Map<String, dynamic> json) => Card(
      cvc: json['cvc'] as String?,
      expiryMonth: json['expiryMonth'] as String?,
      expiryYear: json['expiryYear'] as String?,
      name: json['name'] as String?,
      number: json['number'] as String?,
      bin: json['bin'] as String?,
      last4: json['last4'] as String?,
      brand: json['brand'] as String?,
      country: json['country'] as String?,
      funding: json['funding'] as String?,
      fingerprint: json['fingerprint'] as String?,
      cvcCheck: json['cvcCheck'] as String?,
      avsCheck: json['avsCheck'] as String?,
      issuerCountryCode: json['issuerCountryCode'] as String?,
      cardType: json['cardType'] as String?,
    );

Map<String, dynamic> _$CardToJson(Card instance) => <String, dynamic>{
      'cvc': instance.cvc,
      'expiryMonth': instance.expiryMonth,
      'expiryYear': instance.expiryYear,
      'name': instance.name,
      'number': instance.number,
      'bin': instance.bin,
      'last4': instance.last4,
      'brand': instance.brand,
      'country': instance.country,
      'funding': instance.funding,
      'fingerprint': instance.fingerprint,
      'cvcCheck': instance.cvcCheck,
      'avsCheck': instance.avsCheck,
      'issuerCountryCode': instance.issuerCountryCode,
      'cardType': instance.cardType,
    };
