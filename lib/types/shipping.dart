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

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'shippingMethod': shippingMethod,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'address': address?.toMap(),
    };
  }
}

class Address {
  String? city;
  String? countryCode;
  String? street;
  String? postcode;
  String? state;

  Address({this.city, this.countryCode, this.street, this.postcode, this.state});

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'countryCode': countryCode,
      'street': street,
      'postcode': postcode,
      'state': state,
    };
  }
}