enum MerchantTriggerReason {
  unscheduled,
  scheduled,
}
extension MerchantTriggerReasonExtension on MerchantTriggerReason {
  String toMap() {
    switch (this) {
      case MerchantTriggerReason.unscheduled:
        return 'unscheduled';
      case MerchantTriggerReason.scheduled:
        return 'scheduled';
    }
  }
}