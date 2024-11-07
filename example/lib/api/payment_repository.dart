import 'package:airwallex_payment_flutter/types/payment_consent.dart';
import 'package:flutter/cupertino.dart';

import 'api_client.dart';

class PaymentRepository {
  final ApiClient apiClient;

  PaymentRepository({required this.apiClient});

  Future<Map<String, dynamic>> getPaymentIntentFromServer(
      bool? force3DS, String? customerId) async {
    final body = {
      'apiKey': apiClient.apiKey,
      'clientId': apiClient.clientId,
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
      'return_url':
          'airwallexcheckout://com.example.airwallex_payment_flutter_example',
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

  Future<String> getCustomerId() async {
    final body = {
      'apiKey': apiClient.apiKey,
      'clientId': apiClient.clientId,
      'request_id': UniqueKey().toString(),
      'merchant_customer_id': UniqueKey().toString(),
      'first_name': 'John',
      'last_name': 'Doe',
      'email': 'john.doe@airwallex.com',
      'phone_number': '13800000000',
      'additional_info': {
        'registered_via_social_media': false,
        'registration_date': '2019-09-18',
        'first_successful_order_date': '2019-09-18'
      },
      'metadata': {'id': 1}
    };
    final response = await apiClient.createCustomer(body);
    return response['id'];
  }

  Future<String> getClientSecret(String customerId) async {
    final response = await apiClient.createClientSecretWithQuery(customerId);
    return response['client_secret'];
  }

  Future<List<PaymentConsent>> getPaymentConsents(String customerId) async {
    final response = await apiClient.getPaymentConsents(customerId);
    return response['items']
        .map<PaymentConsent>((item) => PaymentConsent.fromJson(item))
        .toList();
  }
}
