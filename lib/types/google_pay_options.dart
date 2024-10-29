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
  }) :allowedCardNetworks = allowedCardNetworks ?? googlePaySupportedNetworks();

  Map<String, dynamic> toMap() {
    return {
      'allowedCardAuthMethods': allowedCardAuthMethods,
      'merchantName': merchantName,
      'allowPrepaidCards': allowPrepaidCards,
      'allowCreditCards': allowCreditCards,
      'assuranceDetailsRequired': assuranceDetailsRequired,
      'billingAddressRequired': billingAddressRequired,
      'billingAddressParameters': billingAddressParameters?.toMap(),
      'transactionId': transactionId,
      'totalPriceLabel': totalPriceLabel,
      'checkoutOption': checkoutOption,
      'emailRequired': emailRequired,
      'shippingAddressRequired': shippingAddressRequired,
      'shippingAddressParameters': shippingAddressParameters?.toMap(),
      'allowedCardNetworks': allowedCardNetworks,
      'skipReadinessCheck': skipReadinessCheck,
    };
  }
}

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