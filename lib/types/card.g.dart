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

Map<String, dynamic> _$CardToJson(Card instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('cvc', instance.cvc);
  writeNotNull('expiry_month', instance.expiryMonth);
  writeNotNull('expiry_year', instance.expiryYear);
  writeNotNull('name', instance.name);
  writeNotNull('number', instance.number);
  writeNotNull('bin', instance.bin);
  writeNotNull('last4', instance.last4);
  writeNotNull('brand', instance.brand);
  writeNotNull('country', instance.country);
  writeNotNull('funding', instance.funding);
  writeNotNull('fingerprint', instance.fingerprint);
  writeNotNull('cvc_check', instance.cvcCheck);
  writeNotNull('avs_check', instance.avsCheck);
  writeNotNull('issuer_country_code', instance.issuerCountryCode);
  writeNotNull('number_type', instance.numberType);
  return val;
}
