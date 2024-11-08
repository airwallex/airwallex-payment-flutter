import 'package:json_annotation/json_annotation.dart';

part 'shipping.g.dart';

@JsonSerializable(explicitToJson: true)
class Shipping {
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? shippingMethod;
  String? email;
  String? dateOfBirth;
  ShippingAddress? address;

  Shipping({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.shippingMethod,
    this.email,
    this.dateOfBirth,
    this.address,
  });

  factory Shipping.fromJson(Map<String, dynamic> json) => _$ShippingFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingToJson(this);
}

@JsonSerializable()
class ShippingAddress {
  String? city;
  String? countryCode;
  String? street;
  String? postcode;
  String? state;

  ShippingAddress({this.city, this.countryCode, this.street, this.postcode, this.state});
  
  factory ShippingAddress.fromJson(Map<String, dynamic> json) => _$ShippingAddressFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressToJson(this);
}