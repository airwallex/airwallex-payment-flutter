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

extension ApplePaySupportedNetworkExtension on ApplePaySupportedNetwork {
  String toMap() {
    switch (this) {
      case ApplePaySupportedNetwork.visa:
        return 'visa';
      case ApplePaySupportedNetwork.masterCard:
        return 'masterCard';
      case ApplePaySupportedNetwork.unionPay:
        return 'unionPay';
      case ApplePaySupportedNetwork.amex:
        return 'amex';
      case ApplePaySupportedNetwork.discover:
        return 'discover';
      case ApplePaySupportedNetwork.jcb:
        return 'jcb';
      case ApplePaySupportedNetwork.maestro:
        return 'maestro';
    }
  }
}

enum ApplePayMerchantCapability {
  supports3DS,
  supportsCredit,
  supportsDebit,
  supportsEMV,
}

extension ApplePayMerchantCapabilityExtension on ApplePayMerchantCapability {
  String toMap() {
    switch (this) {
      case ApplePayMerchantCapability.supports3DS:
        return 'supports3DS';
      case ApplePayMerchantCapability.supportsCredit:
        return 'supportsCredit';
      case ApplePayMerchantCapability.supportsDebit:
        return 'supportsDebit';
      case ApplePayMerchantCapability.supportsEMV:
        return 'supportsEMV';
    }
  }
}

enum ContactField {
  emailAddress,
  name,
  phoneNumber,
  phoneticName,
  postalAddress,
}

extension ContactFieldExtension on ContactField {
  String toMap() {
    switch (this) {
      case ContactField.emailAddress:
        return 'emailAddress';
      case ContactField.name:
        return 'name';
      case ContactField.phoneNumber:
        return 'phoneNumber';
      case ContactField.phoneticName:
        return 'phoneticName';
      case ContactField.postalAddress:
        return 'postalAddress';
    }
  }
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