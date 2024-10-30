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

  Map<String, dynamic> toMap() {
    return {
      'merchantIdentifier': merchantIdentifier,
      'supportedNetworks': supportedNetworks?.map((e) => e.toMap()).toList(),
      'additionalPaymentSummaryItems': additionalPaymentSummaryItems?.map((e) => e.toMap()).toList(),
      'merchantCapabilities': merchantCapabilities?.map((e) => e.toMap()).toList(),
      'requiredBillingContactFields': requiredBillingContactFields?.map((e) => e.toMap()).toList(),
      'supportedCountries': supportedCountries,
      'totalPriceLabel': totalPriceLabel,
    };
  }
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

class CartSummaryItem {
  String label;
  double amount;
  CartSummaryItemType? type;

  CartSummaryItem({
    required this.label,
    required this.amount,
    this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'amount': amount,
      'type': type?.toMap(),
    };
  }
}

enum CartSummaryItemType {
  finalType,
  pendingType,
}

extension CartSummaryItemTypeExtension on CartSummaryItemType {
  String toMap() {
    switch (this) {
      case CartSummaryItemType.finalType:
        return 'final';
      case CartSummaryItemType.pendingType:
        return 'pending';
    }
  }
}