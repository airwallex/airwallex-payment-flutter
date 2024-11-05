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
  Address? address;

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
class Address {
  String? city;
  String? countryCode;
  String? street;
  String? postcode;
  String? state;

  Address({this.city, this.countryCode, this.street, this.postcode, this.state});
  
  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}