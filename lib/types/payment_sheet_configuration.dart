/// How payment methods are arranged on the payment sheet.
///
/// - `tab` — payment methods shown as horizontally-scrollable tabs.
/// - `accordion` — payment methods stacked vertically, expanding on tap.
enum PaymentLayout { tab, accordion }

/// Optional UI configuration for the payment sheet shown by `presentEntirePaymentFlow`.
class PaymentSheetConfiguration {
  final PaymentLayout layout;

  const PaymentSheetConfiguration({this.layout = PaymentLayout.tab});

  Map<String, dynamic> toJson() => {'layout': layout.name};
}
