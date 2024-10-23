import 'package:airwallex_payment_flutter/types/card.dart';

class CardCreator {
  static Card createDemoCard(String environment) {
    if (environment == 'demo') {
      return Card(
          number: "4012000300001003",
          name: "John Citizen",
          expiryMonth: "12",
          expiryYear: "2029",
          cvc: "737");
    } else {
      return Card(
          number: "4012000300000005",
          name: "John Citizen",
          expiryMonth: "12",
          expiryYear: "2029",
          cvc: "737");
    }
  }
}
