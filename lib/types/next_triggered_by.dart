enum NextTriggeredBy {
  merchant,
  customer,
}
extension NextTriggeredByExtension on NextTriggeredBy {
  String toMap() {
    switch (this) {
      case NextTriggeredBy.merchant:
        return 'merchant';
      case NextTriggeredBy.customer:
        return 'customer';
    }
  }
}