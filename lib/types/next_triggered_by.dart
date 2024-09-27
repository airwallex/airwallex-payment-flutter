enum NextTriggeredBy {
  Merchant,
  Customer,
}
extension NextTriggeredByExtension on NextTriggeredBy {
  String toMap() {
    switch (this) {
      case NextTriggeredBy.Merchant:
        return 'merchant';
      case NextTriggeredBy.Customer:
        return 'customer';
    }
  }
}