enum MerchantTriggerReason {
  Unscheduled,
  Scheduled,
}
extension MerchantTriggerReasonExtension on MerchantTriggerReason {
  String toMap() {
    switch (this) {
      case MerchantTriggerReason.Unscheduled:
        return 'unscheduled';
      case MerchantTriggerReason.Scheduled:
        return 'scheduled';
    }
  }
}