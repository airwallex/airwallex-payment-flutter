import 'package:json_annotation/json_annotation.dart';

part 'card.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Card {
  String? cvc;
  String? expiryMonth;
  String? expiryYear;
  String? name;
  String? number;
  String? bin;
  String? last4;
  String? brand;
  String? country;
  String? funding;
  String? fingerprint;
  String? cvcCheck;
  String? avsCheck;
  String? issuerCountryCode;
  String? numberType;

  Card({
    this.cvc,
    this.expiryMonth,
    this.expiryYear,
    this.name,
    this.number,
    this.bin,
    this.last4,
    this.brand,
    this.country,
    this.funding,
    this.fingerprint,
    this.cvcCheck,
    this.avsCheck,
    this.issuerCountryCode,
    this.numberType,
  });

  factory Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);

  Map<String, dynamic> toJson() => _$CardToJson(this);
}
