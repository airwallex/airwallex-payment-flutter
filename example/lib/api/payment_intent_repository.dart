import 'package:flutter/cupertino.dart';

import 'api_client.dart';

class PaymentIntentRepository {
  final ApiClient apiClient;

  PaymentIntentRepository({required this.apiClient});

  Future<Map<String, dynamic>> getPaymentIntentFromServer(
      bool? force3DS, String? customerId) async {
    final body = {
      'apiKey': '',
      'clientId': '',
      'request_id': UniqueKey().toString(),
      'amount': '1.00',
      'currency': 'HKD',
      'merchant_order_id': UniqueKey().toString(),
      'order': {
        'type': 'physical_goods',
      },
      'referrer_data': {'type': 'android_sdk_sample'},
      'descriptor': 'Airwallex - T-shirt',
      'metadata': {'id': 1},
      'email': 'yimadangxian@airwallex.com',
      'return_url': 'airwallexcheckout://com.airwallex.paymentacceptance',
    };

    if (force3DS == true) {
      body['payment_method_options'] = {
        'card': {'three_ds_action': 'FORCE_3DS'}
      };
    }

    if (customerId != null) {
      body['customer_id'] = customerId;
    }

    final paymentIntentResponse = await apiClient.createPaymentIntent(body);
    return paymentIntentResponse;
  }
}