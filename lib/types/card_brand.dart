enum CardBrand {
  visa('visa'),
  mastercard('mastercard'),
  amex('amex'),
  discover('discover'),
  jcb('jcb'),
  dinersClub('diners'),
  unionPay('unionpay');

  final String value;

  const CardBrand(this.value);
}
