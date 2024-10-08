import 'package:airwallex_payment_flutter/types/card.dart';

class CardCreator {
  static Map<String, dynamic> createDemoCard() {
    final card = Card(
      number: "4012000300001003",
      name: "John Citizen",
      expiryMonth: "12",
      expiryYear: "2029",
      cvc: "737"
    );

    return card.toMap();
  }

  static Map<String, dynamic> createStagingCard() {
    final card = Card(
        number: "4012000300000005",
        name: "John Citizen",
        expiryMonth: "12",
        expiryYear: "2029",
        cvc: "737"
    );

    return card.toMap();
  }
}