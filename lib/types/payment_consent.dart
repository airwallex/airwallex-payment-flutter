import 'package:json_annotation/json_annotation.dart';
import 'package:airwallex_payment_flutter/types/card.dart';
import 'package:airwallex_payment_flutter/types/merchant_trigger_reason.dart';
import 'package:airwallex_payment_flutter/types/next_triggered_by.dart';
import 'package:airwallex_payment_flutter/types/shipping.dart';

part 'payment_consent.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class PaymentConsent {
  String? id;
  String? requestId;
  String? customerId;
  PaymentMethod? paymentMethod;
  String? status;
  NextTriggeredBy? nextTriggeredBy;
  MerchantTriggerReason? merchantTriggerReason;
  bool requiresCvc;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? clientSecret;

  PaymentConsent({
    this.id,
    this.requestId,
    this.customerId,
    this.paymentMethod,
    this.status,
    this.nextTriggeredBy,
    this.merchantTriggerReason,
    this.requiresCvc = false,
    this.createdAt,
    this.updatedAt,
    this.clientSecret,
  });
  
  factory PaymentConsent.fromJson(Map<String, dynamic> json) => _$PaymentConsentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentConsentToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class PaymentMethod {
  String? id;
  String? type;
  Card? card;
  Shipping? billing;
  String? customerId;

  PaymentMethod({
    this.id,
    this.type,
    this.card,
    this.billing,
    this.customerId,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => _$PaymentMethodFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
}