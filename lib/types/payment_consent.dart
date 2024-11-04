import 'package:airwallex_payment_flutter/types/card.dart';
import 'package:airwallex_payment_flutter/types/merchant_trigger_reason.dart';
import 'package:airwallex_payment_flutter/types/next_triggered_by.dart';
import 'package:airwallex_payment_flutter/types/shipping.dart';

class PaymentConsent {
  String? id;
  String? requestId;
  String? customerId;
  PaymentMethod? paymentMethod;
  String? status;
  NextTriggeredBy? nextTriggeredBy;
  MerchantTriggerReason? merchantTriggerReason;
  bool requiresCvc = false;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? clientSecret;
}

class PaymentMethod {
  String? id;
  String? type;
  Card? card;
  Shipping? billing;
  String? customerId;
}