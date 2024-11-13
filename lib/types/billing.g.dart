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

Map<String, dynamic> _$BillingToJson(Billing instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('first_name', instance.firstName);
  writeNotNull('last_name', instance.lastName);
  writeNotNull('phone_number', instance.phoneNumber);
  writeNotNull('shipping_method', instance.shippingMethod);
  writeNotNull('email', instance.email);
  writeNotNull('date_of_birth', instance.dateOfBirth);
  writeNotNull('address', instance.address?.toJson());
  return val;
}

BillingAddress _$BillingAddressFromJson(Map<String, dynamic> json) =>
    BillingAddress(
      city: json['city'] as String?,
      countryCode: json['country_code'] as String?,
      street: json['street'] as String?,
      postcode: json['postcode'] as String?,
      state: json['state'] as String?,
    );

Map<String, dynamic> _$BillingAddressToJson(BillingAddress instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('city', instance.city);
  writeNotNull('country_code', instance.countryCode);
  writeNotNull('street', instance.street);
  writeNotNull('postcode', instance.postcode);
  writeNotNull('state', instance.state);
  return val;
}
