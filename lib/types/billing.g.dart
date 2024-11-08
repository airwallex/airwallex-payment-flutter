// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Billing _$BillingFromJson(Map<String, dynamic> json) => Billing(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      shippingMethod: json['shipping_method'] as String?,
      email: json['email'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      address: json['address'] == null
          ? null
          : BillingAddress.fromJson(json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BillingToJson(Billing instance) => <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone_number': instance.phoneNumber,
      'shipping_method': instance.shippingMethod,
      'email': instance.email,
      'date_of_birth': instance.dateOfBirth,
      'address': instance.address?.toJson(),
    };

BillingAddress _$BillingAddressFromJson(Map<String, dynamic> json) =>
    BillingAddress(
      city: json['city'] as String?,
      countryCode: json['country_code'] as String?,
      street: json['street'] as String?,
      postcode: json['postcode'] as String?,
      state: json['state'] as String?,
    );

Map<String, dynamic> _$BillingAddressToJson(BillingAddress instance) =>
    <String, dynamic>{
      'city': instance.city,
      'country_code': instance.countryCode,
      'street': instance.street,
      'postcode': instance.postcode,
      'state': instance.state,
    };
