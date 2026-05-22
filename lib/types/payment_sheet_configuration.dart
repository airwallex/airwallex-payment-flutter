enum PaymentLayout { tab, accordion }

class PaymentSheetConfiguration {
  final PaymentLayout layout;

  const PaymentSheetConfiguration({this.layout = PaymentLayout.tab});

  Map<String, dynamic> toJson() => {'layout': layout.name};
}
