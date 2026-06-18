/// Why the merchant is triggering a charge against a saved payment consent.
/// Only meaningful when `NextTriggeredBy` is `merchant`.
///
/// - `scheduled` — fixed-interval billing the customer has agreed to (e.g. monthly subscription).
/// - `unscheduled` — merchant-initiated charge at an unpredictable time (e.g. account top-up, usage overage).
enum MerchantTriggerReason {
  unscheduled,
  scheduled,
}
