import 'dart:io';

import 'package:airwallex_payment_flutter/airwallex.dart';
import 'package:airwallex_payment_flutter/types/environment.dart';
import 'package:airwallex_payment_flutter/types/payment_result.dart';
import 'package:airwallex_payment_flutter/types/payment_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/api_client.dart';
import 'api/payment_repository.dart';
import 'ui/credentials_dialog.dart';
import 'util/card_creator.dart';
import 'util/session_creator.dart';

const _environmentPreferenceKey = 'environment';
const _apiKeyPreferenceKey = 'apiKey';
const _clientIdPreferenceKey = 'clientId';
const _appLanguagePreferenceKey = 'app_lang';

void main() {
  runApp(const MyApp());
}

enum ExampleLanguage {
  english(preferenceValue: 'en', airwallexLanguageTag: 'en', label: 'English'),
  chinese(preferenceValue: 'zh', airwallexLanguageTag: 'zh-Hans', label: '中文');

  const ExampleLanguage({
    required this.preferenceValue,
    required this.airwallexLanguageTag,
    required this.label,
  });

  final String preferenceValue;
  final String airwallexLanguageTag;
  final String label;

  static ExampleLanguage fromPreference(String? preferenceValue) {
    return ExampleLanguage.values.firstWhere(
      (language) => language.preferenceValue == preferenceValue,
      orElse: () => ExampleLanguage.english,
    );
  }
}

enum ExamplePaymentOption { oneOff, recurring, recurringAndPayment }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airwallex Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final airwallex = Airwallex();
  final List<String> environmentOptions = (() {
    var options = <String>['demo', 'staging', 'production'];
    assert(() {
      options = <String>['demo', 'staging'];
      return true;
    }());
    return options;
  })();

  PaymentRepository? paymentRepository;
  Environment environment = Environment.demo;
  ExampleLanguage appLanguage = ExampleLanguage.english;
  ExamplePaymentOption selectedOption = ExamplePaymentOption.oneOff;
  bool saveCard = false;
  bool isLoading = false;
  String apiKey = '';
  String clientId = '';
  String? customerId;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() {
      isLoading = true;
    });

    try {
      final settings = await _loadSettings();
      environment = settings.environment;
      apiKey = settings.apiKey;
      clientId = settings.clientId;
      appLanguage = settings.language;

      Airwallex.initialize(environment: environment);
      await _syncAirwallexLocale();

      final apiClient = ApiClient(
        environment: environment,
        apiKey: apiKey,
        clientId: clientId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        paymentRepository = PaymentRepository(apiClient: apiClient);
      });
    } on PlatformException catch (error) {
      if (!mounted) {
        return;
      }
      _showDialog(
        _text(en: 'Error', zh: '错误'),
        _text(
          en: 'Unable to initialize: ${error.message}',
          zh: '初始化失败：${error.message}',
        ),
      );
    } on Exception catch (error) {
      if (!mounted) {
        return;
      }
      _showDialog(_text(en: 'Error', zh: '错误'), error.toString());
    } finally {
      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleSubmit(
    Future<PaymentResult> Function() paymentFunction,
  ) async {
    setState(() {
      isLoading = true;
    });

    try {
      await _syncAirwallexLocale();
      final paymentResult = await paymentFunction();
      _showDialog(
        _text(en: 'Payment Result', zh: '支付结果'),
        paymentResult.status,
      );
    } catch (error) {
      _showDialog(
        _text(en: 'Failed to get response', zh: '请求失败'),
        error.toString(),
      );
    } finally {
      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<BaseSession> _createSession({String? customerId}) async {
    final repository = paymentRepository;
    if (repository == null) {
      throw StateError(
        _text(en: 'Payment repository is not ready yet.', zh: '支付仓库尚未初始化完成。'),
      );
    }

    switch (selectedOption) {
      case ExamplePaymentOption.oneOff:
        final paymentIntent = await repository.getPaymentIntentFromServer(
          false,
          customerId,
        );
        return SessionCreator.createOneOffSession(paymentIntent);
      case ExamplePaymentOption.recurring:
        final currentCustomerId = await repository.getCustomerId();
        this.customerId = currentCustomerId;
        final clientSecret = await repository.getClientSecret(
          currentCustomerId,
        );
        return SessionCreator.createRecurringSession(
          clientSecret,
          currentCustomerId,
        );
      case ExamplePaymentOption.recurringAndPayment:
        final currentCustomerId = await repository.getCustomerId();
        this.customerId = currentCustomerId;
        final paymentIntent = await repository.getPaymentIntentFromServer(
          false,
          currentCustomerId,
        );
        return SessionCreator.createRecurringWithIntentSession(
          paymentIntent,
          currentCustomerId,
        );
    }
  }

  Future<PaymentResult> _payWithConsent() async {
    final repository = paymentRepository;
    final currentCustomerId = customerId;
    if (repository == null || currentCustomerId == null) {
      throw StateError(
        _text(
          en: 'A saved payment consent is not available yet.',
          zh: '当前还没有可用的已保存支付协议。',
        ),
      );
    }

    return airwallex.payWithConsent(
      await _createSession(customerId: currentCustomerId),
      await repository
          .getPaymentConsents(currentCustomerId)
          .then((consents) => consents.first),
    );
  }

  Future<PaymentResult> _payWithCardDetails() async {
    final repository = paymentRepository;
    if (repository == null) {
      throw StateError(
        _text(en: 'Payment repository is not ready yet.', zh: '支付仓库尚未初始化完成。'),
      );
    }

    if (saveCard && customerId == null) {
      customerId = await repository.getCustomerId();
    }

    return airwallex.payWithCardDetails(
      await _createSession(customerId: customerId),
      CardCreator.createDemoCard(environment),
      saveCard,
    );
  }

  Future<void> _changeLanguage(ExampleLanguage language) async {
    if (language == appLanguage) {
      return;
    }

    setState(() {
      appLanguage = language;
    });

    await _saveLanguage(language);

    try {
      await _syncAirwallexLocale();
    } on PlatformException catch (error) {
      if (!mounted) {
        return;
      }
      _showDialog(
        _text(en: 'Error', zh: '错误'),
        _text(
          en: 'Failed to sync locale: ${error.message}',
          zh: '同步 locale 失败：${error.message}',
        ),
      );
    }
  }

  Future<void> _changeEnvironment(String environmentName) async {
    final selectedEnvironment = Environment.values.firstWhere(
      (item) => item.name == environmentName,
    );

    setState(() {
      environment = selectedEnvironment;
      paymentRepository = null;
    });

    await _saveEnvironment(selectedEnvironment);

    if (!mounted) {
      return;
    }

    if (environmentName == Environment.production.name) {
      await showCredentialsDialog(
        context,
        title: _text(
          en: 'Enter API Key and Client ID',
          zh: '请输入 API Key 和 Client ID',
        ),
        apiKeyLabel: 'API Key',
        clientIdLabel: 'Client ID',
        submitLabel: _text(en: 'Submit', zh: '提交'),
        onSubmit: (apiKeyValue, clientIdValue) async {
          await _saveKeys(apiKeyValue, clientIdValue);
          apiKey = apiKeyValue;
          clientId = clientIdValue;
          await _initialize();
        },
      );
      return;
    }

    await _initialize();
  }

  Future<void> _syncAirwallexLocale() {
    return Airwallex.setLocale(appLanguage.airwallexLanguageTag);
  }

  Future<
    ({
      Environment environment,
      String apiKey,
      String clientId,
      ExampleLanguage language,
    })
  >
  _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final envString = prefs.getString(_environmentPreferenceKey);
    final savedApiKey = prefs.getString(_apiKeyPreferenceKey) ?? '';
    final savedClientId = prefs.getString(_clientIdPreferenceKey) ?? '';
    final savedLanguage = ExampleLanguage.fromPreference(
      prefs.getString(_appLanguagePreferenceKey),
    );

    return (
      environment: Environment.values.firstWhere(
        (item) => item.name == envString,
        orElse: () => Environment.demo,
      ),
      apiKey: savedApiKey,
      clientId: savedClientId,
      language: savedLanguage,
    );
  }

  Future<void> _saveEnvironment(Environment nextEnvironment) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_environmentPreferenceKey, nextEnvironment.name);
  }

  Future<void> _saveKeys(String nextApiKey, String nextClientId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyPreferenceKey, nextApiKey);
    await prefs.setString(_clientIdPreferenceKey, nextClientId);
  }

  Future<void> _saveLanguage(ExampleLanguage language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_appLanguagePreferenceKey, language.preferenceValue);
  }

  String _text({required String en, required String zh}) {
    return appLanguage == ExampleLanguage.english ? en : zh;
  }

  String _paymentOptionLabel(ExamplePaymentOption option) {
    return switch (option) {
      ExamplePaymentOption.oneOff => _text(en: 'One-off payment', zh: '单次支付'),
      ExamplePaymentOption.recurring => _text(en: 'Recurring', zh: '周期扣款'),
      ExamplePaymentOption.recurringAndPayment => _text(
        en: 'Recurring with payment',
        zh: '周期扣款并支付',
      ),
    };
  }

  void _showDialog(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message, style: const TextStyle(fontSize: 18)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(_text(en: 'OK', zh: '确定')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRepositoryReady = paymentRepository != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(_text(en: 'Airwallex Example', zh: 'Airwallex 示例')),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: environment.name,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  _changeEnvironment(value);
                },
                items: environmentOptions
                    .map(
                      (value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _text(en: 'Locale Demo', zh: '语言演示'),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<ExampleLanguage>(
                                value: appLanguage,
                                decoration: InputDecoration(
                                  labelText: _text(
                                    en: 'App language',
                                    zh: 'App 语言',
                                  ),
                                  border: const OutlineInputBorder(),
                                ),
                                items: ExampleLanguage.values
                                    .map(
                                      (language) =>
                                          DropdownMenuItem<ExampleLanguage>(
                                            value: language,
                                            child: Text(language.label),
                                          ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value == null) {
                                    return;
                                  }
                                  _changeLanguage(value);
                                },
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _text(
                                  en: 'Current Airwallex locale tag: ${appLanguage.airwallexLanguageTag}',
                                  zh: '当前同步给 Airwallex 的 locale：${appLanguage.airwallexLanguageTag}',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _text(
                                  en: 'The example syncs locale after initialize, after language changes, and again right before payment.',
                                  zh: '示例会在初始化后、语言切换后，以及支付前再次同步 locale。',
                                ),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<ExamplePaymentOption>(
                        value: selectedOption,
                        decoration: InputDecoration(
                          labelText: _text(en: 'Payment scenario', zh: '支付场景'),
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            selectedOption = value;
                          });
                        },
                        items: ExamplePaymentOption.values
                            .map(
                              (option) =>
                                  DropdownMenuItem<ExamplePaymentOption>(
                                    value: option,
                                    child: Text(_paymentOptionLabel(option)),
                                  ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isRepositoryReady
                            ? () => _handleSubmit(
                                () async => airwallex.presentEntirePaymentFlow(
                                  await _createSession(customerId: customerId),
                                ),
                              )
                            : null,
                        child: Text(
                          _text(en: 'presentEntirePaymentFlow', zh: '拉起完整支付流程'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: isRepositoryReady
                            ? () => _handleSubmit(
                                () async => airwallex.presentCardPaymentFlow(
                                  await _createSession(customerId: customerId),
                                ),
                              )
                            : null,
                        child: Text(
                          _text(en: 'presentCardPaymentFlow', zh: '拉起卡支付流程'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ElevatedButton(
                            onPressed: isRepositoryReady
                                ? () => _handleSubmit(_payWithCardDetails)
                                : null,
                            child: Text(
                              _text(en: 'payWithCardDetails', zh: '直接支付卡信息'),
                            ),
                          ),
                          if (selectedOption ==
                              ExamplePaymentOption.oneOff) ...[
                            Checkbox(
                              value: saveCard,
                              onChanged: (value) {
                                if (value == null) {
                                  return;
                                }
                                setState(() {
                                  saveCard = value;
                                });
                              },
                            ),
                            Text(_text(en: 'Save card', zh: '保存卡')),
                          ],
                        ],
                      ),
                      if (selectedOption == ExamplePaymentOption.oneOff &&
                          Platform.isAndroid) ...[
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: isRepositoryReady
                              ? () => _handleSubmit(
                                  () async => airwallex.startGooglePay(
                                    await _createSession(),
                                  ),
                                )
                              : null,
                          child: Text(
                            _text(en: 'startGooglePay', zh: '发起 Google Pay'),
                          ),
                        ),
                      ],
                      if (selectedOption == ExamplePaymentOption.oneOff &&
                          Platform.isIOS) ...[
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: isRepositoryReady
                              ? () => _handleSubmit(
                                  () async => airwallex.startApplePay(
                                    await _createSession(),
                                  ),
                                )
                              : null,
                          child: Text(
                            _text(en: 'startApplePay', zh: '发起 Apple Pay'),
                          ),
                        ),
                      ],
                      if (selectedOption == ExamplePaymentOption.oneOff &&
                          customerId != null) ...[
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: isRepositoryReady
                              ? () => _handleSubmit(_payWithConsent)
                              : null,
                          child: Text(
                            _text(en: 'payWithConsent', zh: '用已保存协议支付'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
