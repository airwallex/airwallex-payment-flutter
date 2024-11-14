import 'dart:async';
import 'dart:io';

import 'package:airwallex_payment_flutter/airwallex.dart';
import 'package:airwallex_payment_flutter/types/environment.dart';
import 'package:airwallex_payment_flutter/types/payment_result.dart';
import 'package:airwallex_payment_flutter/types/payment_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

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
  final airwallex = Airwallex();
  late PaymentRepository paymentRepository;
  late List<String> environmentOptions;

  Environment environment = Environment.demo;
  bool saveCard = false;
  bool isLoading = false;
  String selectedOption = 'one off';
  //for demo or staging environment, you can set your own api key and client id,
  // if you don't, We will use the default value
  String apiKey = '';
  String clientId = '';
  String? customerId;

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
      final values = await loadEnvironmentAndKeys();
      environment = values.item1;
      apiKey = values.item2;
      clientId = values.item3;
      Airwallex.initialize(environment: environment);
      final apiClient = ApiClient(
          environment: environment, apiKey: apiKey, clientId: clientId);
      setState(() {
        paymentRepository = PaymentRepository(apiClient: apiClient);
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
      isLoading = true;
    });
    try {
      PaymentResult paymentResult = await paymentFunction();
      _showDialog('Payment Result', paymentResult.status);
    } catch (e) {
      _showDialog('Failed to get response', e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<BaseSession> _createSession({String? customerId}) async {
    switch (selectedOption) {
      case 'one off':
        final paymentIntent = await paymentRepository
            .getPaymentIntentFromServer(false, customerId);
        return SessionCreator.createOneOffSession(paymentIntent);
      case 'recurring':
        final customerId = await paymentRepository.getCustomerId();
        this.customerId = customerId;
        final clientSecret =
            await paymentRepository.getClientSecret(customerId);
        return SessionCreator.createRecurringSession(clientSecret, customerId);
      default: //'recurring and payment':
        final customerId = await paymentRepository.getCustomerId();
        this.customerId = customerId;
        final paymentIntent = await paymentRepository
            .getPaymentIntentFromServer(false, customerId);
        return SessionCreator.createRecurringWithIntentSession(
            paymentIntent, customerId);
    }
  }

  Future<PaymentResult> _payWithConsent() async {
    return airwallex.payWithConsent(
        await _createSession(customerId: customerId),
        await paymentRepository
            .getPaymentConsents(customerId!)
            .then((consents) => consents.first));
  }

  Future<PaymentResult> _payWithCardDetails() async {
    if (saveCard && customerId == null) {
      customerId = await paymentRepository.getCustomerId();
    }
    return airwallex.payWithCardDetails(
        await _createSession(customerId: customerId),
        CardCreator.createDemoCard(environment),
        saveCard);
  }

  Future<Tuple3<Environment, String, String>> loadEnvironmentAndKeys() async {
    final prefs = await SharedPreferences.getInstance();
    final envString = prefs.getString('environment');
    final apiKey = prefs.getString('apiKey');
    final clientId = prefs.getString('clientId');
    return Tuple3(Environment.values.firstWhere((e) => e.name == envString, orElse: () => Environment.demo), apiKey ?? '', clientId ?? '');
  }

  void saveEnvironment(Environment environment) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('environment', environment.name);
  }

  void saveKeys(String apiKey, String clientId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('apiKey', apiKey);
    prefs.setString('clientId', clientId);
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
            value: environment.name,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  saveEnvironment(Environment.values
                      .firstWhere((element) => element.name == newValue));
                });
                if (newValue == "production") {
                  showCredentialsDialog(context,
                      (String apiKeyValue, String clientIdValue) {
                    setState(() {
                      saveKeys(apiKeyValue, clientIdValue);
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
                  value: selectedOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOption = newValue!;
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
                      airwallex.presentEntirePaymentFlow(
                          await _createSession(customerId: customerId))),
                  child: const Text('presentEntirePaymentFlow'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _handleSubmit(() async =>
                      airwallex.presentCardPaymentFlow(
                          await _createSession(customerId: customerId))),
                  child: const Text('presentCardPaymentFlow'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          _handleSubmit(() async => _payWithCardDetails()),
                      child: const Text('payWithCardDetails'),
                    ),
                    if (selectedOption == 'one off') ...[
                      const SizedBox(width: 5),
                      SizedBox(
                          height: 24.0,
                          width: 24.0,
                          child: Checkbox(
                            value: saveCard,
                            onChanged: (value) {
                              setState(() {
                                saveCard = value!;
                              });
                            },
                          )),
                      const Text('save'),
                    ]
                  ],
                ),
                const SizedBox(height: 20),
                if (selectedOption == 'one off' && Platform.isAndroid) ...[
                  ElevatedButton(
                    onPressed: () => _handleSubmit(() async =>
                        airwallex.startGooglePay(await _createSession())),
                    child: const Text('startGooglePay'),
                  )
                ],
                if (selectedOption == 'one off' && Platform.isIOS) ...[
                  ElevatedButton(
                    onPressed: () => _handleSubmit(() async =>
                        airwallex.startApplePay(await _createSession())),
                    child: const Text('startApplePay'),
                  )
                ],
                if (selectedOption == 'one off' && customerId != null) ...[
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () =>
                        _handleSubmit(() async => _payWithConsent()),
                    child: const Text('payWithConsent'),
                  ),
                ],
              ],
            ),
          ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
