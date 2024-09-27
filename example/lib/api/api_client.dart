import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  final String baseUrl;
  final String apiKey;
  final String clientId;

  ApiClient({required this.baseUrl, required this.apiKey, required this.clientId});

  Future<Map<String, dynamic>> createPaymentIntent(Map<String, dynamic> params) async {
    print('Creating payment intent with params: $params');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/pa/payment_intents/create'),
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

  Future<Map<String, dynamic>> createCustomer(Map<String, dynamic> params) async {
    print('Creating customer with params: $params');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/pa/customers/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(params),
      );
      print('HTTP Response Status Code: ${response.statusCode}');
      print('HTTP Response Body: ${response.body}');

      if (response.statusCode == 200) {
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
      String customerId, String apiKey, String clientId) async {
    print('Generating client secret for customer: $customerId');
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/api/v1/pa/customers/$customerId/generate_client_secret?apiKey=$apiKey&clientId=$clientId'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );
      print('HTTP Response Status Code: ${response.statusCode}');
      print('HTTP Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create client secret: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while generating client secret: $e');
      rethrow;
    }
  }
}