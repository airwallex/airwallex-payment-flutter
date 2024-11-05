// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shipping _$ShippingFromJson(Map<String, dynamic> json) => Shipping(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      shippingMethod: json['shippingMethod'] as String?,
      email: json['email'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShippingToJson(Shipping instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'shippingMethod': instance.shippingMethod,
      'email': instance.email,
      'dateOfBirth': instance.dateOfBirth,
      'address': instance.address?.toJson(),
    };

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      city: json['city'] as String?,
      countryCode: json['countryCode'] as String?,
      street: json['street'] as String?,
      postcode: json['postcode'] as String?,
      state: json['state'] as String?,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'city': instance.city,
      'countryCode': instance.countryCode,
      'street': instance.street,
      'postcode': instance.postcode,
      'state': instance.state,
    };
