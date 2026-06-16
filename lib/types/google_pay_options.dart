import 'package:json_annotation/json_annotation.dart';

part 'google_pay_options.g.dart';

/// Google Pay configuration. Required on a `PaymentSession` when invoking
/// `startGooglePay`, or when offering Google Pay through `presentEntirePaymentFlow` on Android.
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

/// Controls how the customer's billing address is collected via Google Pay.
@JsonSerializable()
class BillingAddressParameters {
  Format? format;
  bool? phoneNumberRequired;

  BillingAddressParameters({
    this.format = Format.min,
    this.phoneNumberRequired = false,
  });

  factory BillingAddressParameters.fromJson(Map<String, dynamic> json) => _$BillingAddressParametersFromJson(json);

  Map<String, dynamic> toJson() => _$BillingAddressParametersToJson(this);
}

/// How much of the billing address Google Pay should return.
///
/// - `min` — postal code and country only (sufficient for most card validation).
/// - `full` — full address.
enum Format {
  min,
  full,
}

/// Controls how the customer's shipping address is collected via Google Pay.
@JsonSerializable()
class ShippingAddressParameters {
  List<String>? allowedCountryCodes;
  bool? phoneNumberRequired;

  ShippingAddressParameters({
    this.allowedCountryCodes,
    this.phoneNumberRequired = false,
  });

  factory ShippingAddressParameters.fromJson(Map<String, dynamic> json) => _$ShippingAddressParametersFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressParametersToJson(this);
}

/// The set of card networks Airwallex supports through Google Pay. Useful as a default value
/// for `GooglePayOptions.allowedCardNetworks` when the merchant has no preference.
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
