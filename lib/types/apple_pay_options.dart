import 'package:json_annotation/json_annotation.dart';

part 'apple_pay_options.g.dart';

/// Apple Pay configuration. Required on a `PaymentSession` when invoking
/// `startApplePay`, or when offering Apple Pay through `presentEntirePaymentFlow` on iOS.
///
/// `merchantIdentifier` must match the Apple Pay merchant ID configured in the app's entitlements.
@JsonSerializable(explicitToJson: true)
class ApplePayOptions {
  String merchantIdentifier;
  List<ApplePaySupportedNetwork>? supportedNetworks;
  List<CartSummaryItem>? additionalPaymentSummaryItems;
  List<ApplePayMerchantCapability>? merchantCapabilities;
  List<ContactField>? requiredBillingContactFields;
  List<String>? supportedCountries;
  String? totalPriceLabel;

  ApplePayOptions({
    required this.merchantIdentifier,
    this.supportedNetworks,
    this.additionalPaymentSummaryItems,
    this.merchantCapabilities,
    this.requiredBillingContactFields,
    this.supportedCountries,
    this.totalPriceLabel,
  });

  factory ApplePayOptions.fromJson(Map<String, dynamic> json) => _$ApplePayOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$ApplePayOptionsToJson(this);
}

/// Card networks the merchant is willing to accept through Apple Pay.
enum ApplePaySupportedNetwork {
  visa,
  masterCard,
  unionPay,
  amex,
  discover,
  jcb,
  maestro
}

/// Payment-processing capabilities the merchant supports. `supports3DS` is required by Apple Pay.
enum ApplePayMerchantCapability {
  supports3DS,
  supportsCredit,
  supportsDebit,
  supportsEMV,
}

/// Contact fields the merchant requires from the customer during Apple Pay checkout.
enum ContactField {
  emailAddress,
  name,
  phoneNumber,
  phoneticName,
  postalAddress,
}

/// An additional line item displayed in the Apple Pay summary
/// (e.g. tax, shipping, discount) on top of the session amount.
@JsonSerializable()
class CartSummaryItem {
  String label;
  double amount;
  CartSummaryItemType? type;

  CartSummaryItem({
    required this.label,
    required this.amount,
    this.type,
  });

  factory CartSummaryItem.fromJson(Map<String, dynamic> json) => _$CartSummaryItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartSummaryItemToJson(this);
}

/// Whether a `CartSummaryItem` amount is final or still pending
/// (e.g. shipping not yet calculated).
enum CartSummaryItemType {
  finalType,
  pendingType,
}