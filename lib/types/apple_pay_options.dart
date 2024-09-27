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
  Visa,
  MasterCard,
  UnionPay,
  Amex,
  Discover,
  JCB,
}

extension ApplePaySupportedNetworkExtension on ApplePaySupportedNetwork {
  String toMap() {
    switch (this) {
      case ApplePaySupportedNetwork.Visa:
        return 'visa';
      case ApplePaySupportedNetwork.MasterCard:
        return 'masterCard';
      case ApplePaySupportedNetwork.UnionPay:
        return 'unionPay';
      case ApplePaySupportedNetwork.Amex:
        return 'amex';
      case ApplePaySupportedNetwork.Discover:
        return 'discover';
      case ApplePaySupportedNetwork.JCB:
        return 'jcb';
    }
  }
}

enum ApplePayMerchantCapability {
  Supports3DS,
  SupportsCredit,
  SupportsDebit,
  SupportsEMV,
}

extension ApplePayMerchantCapabilityExtension on ApplePayMerchantCapability {
  String toMap() {
    switch (this) {
      case ApplePayMerchantCapability.Supports3DS:
        return 'supports3DS';
      case ApplePayMerchantCapability.SupportsCredit:
        return 'supportsCredit';
      case ApplePayMerchantCapability.SupportsDebit:
        return 'supportsDebit';
      case ApplePayMerchantCapability.SupportsEMV:
        return 'supportsEMV';
    }
  }
}

enum ContactField {
  EmailAddress,
  Name,
  PhoneNumber,
  PhoneticName,
  PostalAddress,
}

extension ContactFieldExtension on ContactField {
  String toMap() {
    switch (this) {
      case ContactField.EmailAddress:
        return 'emailAddress';
      case ContactField.Name:
        return 'name';
      case ContactField.PhoneNumber:
        return 'phoneNumber';
      case ContactField.PhoneticName:
        return 'phoneticName';
      case ContactField.PostalAddress:
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
  Final,
  Pending,
}

extension CartSummaryItemTypeExtension on CartSummaryItemType {
  String toMap() {
    switch (this) {
      case CartSummaryItemType.Final:
        return 'final';
      case CartSummaryItemType.Pending:
        return 'pending';
    }
  }
}