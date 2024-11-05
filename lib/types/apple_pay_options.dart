import 'package:json_annotation/json_annotation.dart';

part 'apple_pay_options.g.dart';

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

enum ApplePaySupportedNetwork {
  visa,
  masterCard,
  unionPay,
  amex,
  discover,
  jcb,
  maestro
}

enum ApplePayMerchantCapability {
  supports3DS,
  supportsCredit,
  supportsDebit,
  supportsEMV,
}

enum ContactField {
  emailAddress,
  name,
  phoneNumber,
  phoneticName,
  postalAddress,
}

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

enum CartSummaryItemType {
  finalType,
  pendingType,
}