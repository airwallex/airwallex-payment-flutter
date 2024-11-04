import 'package:json_annotation/json_annotation.dart';

part 'google_pay_options.g.dart';

@JsonSerializable(explicitToJson: true)
class GooglePayOptions {
  List<String>? allowedCardAuthMethods;
  String? merchantName;
  bool? allowPrepaidCards;
  bool? allowCreditCards;
  bool? assuranceDetailsRequired;
  bool? billingAddressRequired;
  BillingAddressParameters? billingAddressParameters;
  String? transactionId;
  String? totalPriceLabel;
  String? checkoutOption;
  bool? emailRequired;
  bool? shippingAddressRequired;
  ShippingAddressParameters? shippingAddressParameters;
  List<String> allowedCardNetworks;
  bool? skipReadinessCheck;

  GooglePayOptions({
    this.allowedCardAuthMethods,
    this.merchantName,
    this.allowPrepaidCards,
    this.allowCreditCards,
    this.assuranceDetailsRequired,
    this.billingAddressRequired,
    this.billingAddressParameters,
    this.transactionId,
    this.totalPriceLabel,
    this.checkoutOption,
    this.emailRequired,
    this.shippingAddressRequired,
    this.shippingAddressParameters,
    List<String>? allowedCardNetworks,
    this.skipReadinessCheck,
  }) : allowedCardNetworks =
            allowedCardNetworks ?? googlePaySupportedNetworks();

  factory GooglePayOptions.fromJson(Map<String, dynamic> json) => _$GooglePayOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$GooglePayOptionsToJson(this);
}

@JsonSerializable()
class BillingAddressParameters {
  Format? format;
  bool? phoneNumberRequired;

  BillingAddressParameters({
    this.format = Format.min,
    this.phoneNumberRequired = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'format': format?.toMap(),
      'phoneNumberRequired': phoneNumberRequired,
    };
  }

  factory BillingAddressParameters.fromJson(Map<String, dynamic> json) => _$BillingAddressParametersFromJson(json);

  Map<String, dynamic> toJson() => _$BillingAddressParametersToJson(this);
}

enum Format {
  min,
  full,
}

extension FormatExtension on Format {
  String toMap() {
    switch (this) {
      case Format.min:
        return 'min';
      case Format.full:
        return 'full';
    }
  }
}

@JsonSerializable()
class ShippingAddressParameters {
  List<String>? allowedCountryCodes;
  bool? phoneNumberRequired;

  ShippingAddressParameters({
    this.allowedCountryCodes,
    this.phoneNumberRequired = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'allowedCountryCodes': allowedCountryCodes,
      'phoneNumberRequired': phoneNumberRequired,
    };
  }

  factory ShippingAddressParameters.fromJson(Map<String, dynamic> json) => _$ShippingAddressParametersFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressParametersToJson(this);
}

List<String> googlePaySupportedNetworks() {
  return [
    "AMEX",
    "DISCOVER",
    "JCB",
    "MASTERCARD",
    "VISA",
    // "MAESTRO"
  ];
}
