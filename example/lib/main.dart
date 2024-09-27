import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'api/payment_intent_repository.dart';
import 'util/payment_result_parser.dart';
import 'util/session_creator.dart';
import 'api/api_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airwallex Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static const platform =
  MethodChannel('samples.flutter.dev/airwallex_payment');

  final apiClient = ApiClient(
      baseUrl: 'https://demo-pacheckoutdemo.airwallex.com',
      // baseUrl: 'https://staging-pacheckoutdemo.airwallex.com/',
      apiKey: '',
      clientId: '');

  late final paymentIntentRepository =
  PaymentIntentRepository(apiClient: apiClient);

  bool _isLoading = false;

  Future<void> _handleSubmit<T>(Future<T> Function() fetchData,
      String methodName, Map<String, dynamic> Function(T) transformData) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await fetchData();
      final Map<String, dynamic> sessionParams = transformData(data);

      final result = await platform.invokeMethod(methodName, sessionParams);
      final paymentResult = PaymentResultParser.parsePaymentResult(
          Map<String, dynamic>.from(result));

      _showDialog('Payment Result', paymentResult.status);
    } catch (e) {
      _showDialog('Failed to get response', e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _transformPaymentIntent(
      Map<String, dynamic> paymentIntent) {
    return SessionCreator.createOneOffSession(paymentIntent);
  }

  Map<String, dynamic> _transformOtherDataType(dynamic data) {
    // Implement the logic to transform other data types here
    return <String, dynamic>{};
  }

  Future<void> _launchUI(String methodName) async {
    await _handleSubmit(
            () => paymentIntentRepository.getPaymentIntentFromServer(false, null),
        methodName,
        _transformPaymentIntent);
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message, style: const TextStyle(fontSize: 20)),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Airwallex Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _launchUI('presentEntirePaymentFlow'),
              child: const Text('presentEntirePaymentFlow'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _launchUI('presentCardPaymentFlow'),
              child: const Text('presentCardPaymentFlow'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
