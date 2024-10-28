import 'dart:async';
import 'dart:io';

import 'package:airwallex_payment_flutter/airwallex_payment_flutter.dart';
import 'package:airwallex_payment_flutter/types/payment_result.dart';
import 'package:airwallex_payment_flutter/types/payment_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'api/api_client.dart';
import 'api/payment_repository.dart';
import 'ui/credentials_dialog.dart';
import 'util/card_creator.dart';
import 'util/session_creator.dart';

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
  final airwallexPaymentFlutter = AirwallexPaymentFlutter();
  late PaymentRepository paymentIntentRepository;
  late List<String> environmentOptions;

  String _environment = 'demo';
  bool _isLoading = false;
  String _selectedOption = 'one off';
  //for demo or staging environment, you can set your own api key and client id,
  // if you don't, We will use the default value
  String apiKey = '';
  String clientId = '';

  @override
  void initState() {
    super.initState();
    environmentOptions = ['demo', 'staging', 'production'];
    assert(() {
      environmentOptions = ['demo', 'staging'];
      return true;
    }());
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      airwallexPaymentFlutter.initialize(_environment, true, false);
      final apiClient =
          ApiClient(environment: _environment, apiKey: apiKey, clientId: clientId);
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
      Future<PaymentResult> Function() paymentFunction) async {
    setState(() {
      _isLoading = true;
    });
    try {
      PaymentResult paymentResult = await paymentFunction();
      _showDialog('Payment Result', paymentResult.status);
    } catch (e) {
      _showDialog('Failed to get response', e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<BaseSession> _createSession() async {
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
      default: //'recurring and payment':
        final customerId = await paymentIntentRepository.getCustomerId();
        final paymentIntent = await paymentIntentRepository
            .getPaymentIntentFromServer(false, customerId);
        return SessionCreator.createRecurringWithIntentSession(
            paymentIntent, customerId);
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
        actions: [
          DropdownButton<String>(
            value: _environment,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _environment = newValue;
                });
                if (_environment == 'production') {
                  showCredentialsDialog(context,
                      (String apiKeyValue, String clientIdValue) {
                    setState(() {
                      apiKey = apiKeyValue;
                      clientId = clientIdValue;
                    });
                    _initialize();
                  });
                } else {
                  _initialize();
                }
              }
            },
            items: environmentOptions
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
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
                  onPressed: () => _handleSubmit(() async =>
                      airwallexPaymentFlutter
                          .presentEntirePaymentFlow(await _createSession())),
                  child: const Text('presentEntirePaymentFlow'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _handleSubmit(() async =>
                      airwallexPaymentFlutter
                          .presentCardPaymentFlow(await _createSession())),
                  child: const Text('presentCardPaymentFlow'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _handleSubmit(() async =>
                      airwallexPaymentFlutter.startPayWithCardDetails(
                          await _createSession(),
                          CardCreator.createDemoCard(_environment))),
                  child: const Text('startPayWithCardDetails'),
                ),
                const SizedBox(height: 20),
                if (_selectedOption == 'one off' && Platform.isAndroid) ...[
                  ElevatedButton(
                    onPressed: () => _handleSubmit(() async =>
                        airwallexPaymentFlutter
                            .startGooglePay(await _createSession())),
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
