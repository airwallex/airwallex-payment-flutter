import 'package:json_annotation/json_annotation.dart';

part 'card.g.dart';

/// Card details. When used as input to `payWithCardDetails`, the merchant
/// supplies `number`, `expiryMonth`, `expiryYear`, `cvc`, and optionally `name`.
///
/// The remaining fields (`bin`, `last4`, `brand`, `fingerprint`, `cvcCheck`,
/// `avsCheck`, etc.) are populated by Airwallex when a Card is returned as part of
/// a saved payment method on a `PaymentConsent`.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
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
