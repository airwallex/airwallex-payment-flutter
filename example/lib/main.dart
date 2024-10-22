import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'api/payment_repository.dart';
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

  late final PaymentRepository paymentIntentRepository;
  bool _isLoading = false;
  String _selectedOption = 'one off';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      const environment = 'demo';
      platform.invokeMethod('initialize', {
        'environment': environment,
        'enableLogging': true,
        'saveLogToLocal': false,
      });
      final apiClient =
          ApiClient(environment: environment, apiKey: '', clientId: '');
      setState(() {
        paymentIntentRepository = PaymentRepository(apiClient: apiClient);
      });
    } on PlatformException catch (e) {
      _showDialog('Error', 'Unable to initialize: ${e.message}');
    } on Exception catch (e) {
      _showDialog('Error', e.toString());
    }
  }

  Future<void> _handleSubmit<T>(
    String methodName, [
    Map<String, dynamic> param = const {},
  ]) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final sessionParams = await _createParam();
      final mergedParams = {
        ...sessionParams,
        ...param,
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

  Future<Map<String, dynamic>> _createParam() async {
    switch (_selectedOption) {
      case 'one off':
        final paymentIntent = await paymentIntentRepository
            .getPaymentIntentFromServer(false, null);
        return SessionCreator.createOneOffSession(paymentIntent);
      case 'recurring':
        final customerId = await paymentIntentRepository.getCustomerId();
        final clientSecret =
            await paymentIntentRepository.getClientSecret(customerId);
        return SessionCreator.createRecurringSession(clientSecret, customerId);
      case 'recurring and payment':
        return {};
      default:
        return {};
    }
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
                DropdownButton<String>(
                  value: _selectedOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedOption = newValue!;
                    });
                  },
                  items: <String>[
                    'one off',
                    'recurring',
                    'recurring and payment'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _handleSubmit('presentEntirePaymentFlow'),
                  child: const Text('presentEntirePaymentFlow'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _handleSubmit('presentCardPaymentFlow'),
                  child: const Text('presentCardPaymentFlow'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _handleSubmit(
                      'startPayWithCardDetails', CardCreator.createDemoCard()),
                  child: const Text('startPayWithCardDetails'),
                ),
                const SizedBox(height: 40),
                if (_selectedOption == 'one off') ...[
                  const Text(
                    'Android Specific Features',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () =>
                        _handleSubmit('startGooglePay'),
                    child: const Text('startGooglePay'),
                  ),
                ],
              ],
            ),
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
