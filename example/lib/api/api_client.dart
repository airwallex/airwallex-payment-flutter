import 'package:airwallex_payment_flutter/types/environment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  late String checkoutDemoBaseUrl;
  final String apiKey;
  final String clientId;
  final Environment environment;

  ApiClient(
      {required this.environment,
      required this.apiKey,
      required this.clientId}) {
    checkoutDemoBaseUrl = _getCheckoutDemoBaseUrlForEnvironment(environment);
  }

  String _getCheckoutDemoBaseUrlForEnvironment(Environment environment) {
    switch (environment) {
      case Environment.demo:
        return 'https://demo-pacheckoutdemo.airwallex.com';
      case Environment.staging:
        return 'https://staging-pacheckoutdemo.airwallex.com';
      default:
        return '';
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      Map<String, dynamic> params) async {
    print('Creating payment intent with params: $params');
    try {
      final response = await http.post(
        Uri.parse('$checkoutDemoBaseUrl/api/v1/pa/payment_intents/create'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(params),
      );
      print('HTTP Response Status Code: ${response.statusCode}');
      print('HTTP Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create payment intent: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while creating payment intent: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createCustomer(
      Map<String, dynamic> params) async {
    print('Creating customer with params: $params');
    try {
      final response = await http.post(
        Uri.parse('$checkoutDemoBaseUrl/api/v1/pa/customers/create'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(params),
      );
      print('HTTP Response Status Code: ${response.statusCode}');
      print('HTTP Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create customer: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while creating customer: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createClientSecretWithQuery(
      String customerId) async {
    print('Generating client secret for customer: $customerId');
    try {
      final response = await http.get(
        Uri.parse(
            '$checkoutDemoBaseUrl/api/v1/pa/customers/$customerId/generate_client_secret?apiKey=$apiKey&clientId=$clientId'),
      );
      print('HTTP Response Status Code: ${response.statusCode}');
      print('HTTP Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create client secret: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while generating client secret: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getPaymentConsents(String customerId) async {
    print('Fetching payment consents');
    try {
      final response = await http.get(
        Uri.parse('$checkoutDemoBaseUrl/api/v1/pa/payment_consents?customer_id=$customerId')
      );
      print('HTTP Response Status Code: ${response.statusCode}');
      print('HTTP Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch payment consents: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while fetching payment consents: $e');
      rethrow;
    }
  }
}
