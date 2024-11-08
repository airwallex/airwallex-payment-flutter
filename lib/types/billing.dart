import 'package:json_annotation/json_annotation.dart';

part 'billing.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Billing {
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? shippingMethod;
  String? email;
  String? dateOfBirth;
  BillingAddress? address;

  Billing({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.shippingMethod,
    this.email,
    this.dateOfBirth,
    this.address,
  });

  factory Billing.fromJson(Map<String, dynamic> json) => _$BillingFromJson(json);

  Map<String, dynamic> toJson() => _$BillingToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class BillingAddress {
  String? city;
  String? countryCode;
  String? street;
  String? postcode;
  String? state;

  BillingAddress({this.city, this.countryCode, this.street, this.postcode, this.state});
  
  factory BillingAddress.fromJson(Map<String, dynamic> json) => _$BillingAddressFromJson(json);

  Map<String, dynamic> toJson() => _$BillingAddressToJson(this);
}