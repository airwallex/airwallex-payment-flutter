import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'api/payment_intent_repository.dart';
import 'util/payment_result_parser.dart';
import 'util/session_creator.dart';
import 'util/card_creator.dart';
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

  late final PaymentIntentRepository paymentIntentRepository;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeEnvironment();
  }

  Future<void> _initializeEnvironment() async {
    try {
      final String environment = await platform.invokeMethod('getEnvironment');
      final apiClient =
          ApiClient(environment: environment, apiKey: '', clientId: '');
      setState(() {
        paymentIntentRepository = PaymentIntentRepository(apiClient: apiClient);
      });
    } on PlatformException catch (e) {
      _showDialog('Error', 'Unable to get environment: ${e.message}');
    } on Exception catch (e) {
      _showDialog('Error', e.toString());
    }
  }

  Future<void> _handleSubmit<T>(
      Future<T> Function() fetchData,
      String methodName,
      Map<String, dynamic>? param,
      Map<String, dynamic> Function(T) transformData) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await fetchData();
      final Map<String, dynamic> sessionParams = transformData(data);
      final mergedParams = {
        ...sessionParams,
        if (param != null) ...param,
      };
      final result = await platform.invokeMethod(methodName, mergedParams);
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

  Future<void> _launchUI(String methodName) async {
    await _handleSubmit(
        () => paymentIntentRepository.getPaymentIntentFromServer(false, null),
        methodName,
        null,
        _transformPaymentIntent);
  }

  Future<void> _startFlow(String methodName, Map<String, dynamic> param) async {
    await _handleSubmit(
        () => paymentIntentRepository.getPaymentIntentFromServer(false, null),
        methodName,
        param,
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
      body: Stack(
        children: [
          Center(
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
                ElevatedButton(
                  onPressed: () => _startFlow(
                      'startPayWithCardDetails', CardCreator.createDemoCard()),
                  child: const Text('startPayWithCardDetails'),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Android Specific Features',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () =>
                      _startFlow('startGooglePay', <String, dynamic>{}),
                  child: const Text('startGooglePay'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
