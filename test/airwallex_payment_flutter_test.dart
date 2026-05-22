import 'package:airwallex_payment_flutter/airwallex_payment_flutter_method_channel.dart';
import 'package:airwallex_payment_flutter/airwallex_payment_flutter_platform_interface.dart';
import 'package:airwallex_payment_flutter/types/card.dart';
import 'package:airwallex_payment_flutter/types/card_brand.dart';
import 'package:airwallex_payment_flutter/types/environment.dart';
import 'package:airwallex_payment_flutter/types/payment_consent.dart';
import 'package:airwallex_payment_flutter/types/payment_result.dart';
import 'package:airwallex_payment_flutter/types/payment_session.dart';
import 'package:airwallex_payment_flutter/types/payment_sheet_configuration.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAirwallexPaymentFlutterPlatform
    with MockPlatformInterfaceMixin
    implements AirwallexPaymentFlutterPlatform {
  @override
  void initialize(
      Environment environment, bool enableLogging, bool saveLogToLocal) {
    throw UnimplementedError();
  }

  @override
  Future<PaymentResult> presentCardPaymentFlow(
    BaseSession session, {
    List<CardBrand>? supportedBrands,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<PaymentResult> presentEntirePaymentFlow(
    BaseSession session, {
    PaymentSheetConfiguration? configuration,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<PaymentResult> startGooglePay(BaseSession session) {
    throw UnimplementedError();
  }

  @override
  Future<PaymentResult> startApplePay(BaseSession session) {
    throw UnimplementedError();
  }

  @override
  Future<PaymentResult> payWithCardDetails(
      BaseSession session, Card card, bool saveCard) {
    throw UnimplementedError();
  }

  @override
  Future<PaymentResult> payWithConsent(
      BaseSession session, PaymentConsent consent) {
    throw UnimplementedError();
  }

  @override
  void setTintColor(Color color) {
    throw UnimplementedError();
  }
}

void main() {
  final AirwallexPaymentFlutterPlatform initialPlatform =
      AirwallexPaymentFlutterPlatform.instance;

  test('$MethodChannelAirwallexPaymentFlutter is the default instance', () {
    expect(
        initialPlatform, isInstanceOf<MethodChannelAirwallexPaymentFlutter>());
  });

  group('PaymentSheetConfiguration.toJson', () {
    test('default layout serializes to tab', () {
      const config = PaymentSheetConfiguration();
      expect(config.toJson(), {'layout': 'tab'});
    });

    test('explicit tab layout serializes to tab', () {
      const config = PaymentSheetConfiguration(layout: PaymentLayout.tab);
      expect(config.toJson(), {'layout': 'tab'});
    });

    test('accordion layout serializes to accordion', () {
      const config = PaymentSheetConfiguration(layout: PaymentLayout.accordion);
      expect(config.toJson(), {'layout': 'accordion'});
    });
  });

  group('MethodChannelAirwallexPaymentFlutter.presentEntirePaymentFlow', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    final plugin = MethodChannelAirwallexPaymentFlutter();
    final channel = plugin.methodChannel;
    Map<dynamic, dynamic>? capturedArgs;

    OneOffSession buildSession() => OneOffSession(
          clientSecret: 'secret',
          currency: 'USD',
          countryCode: 'US',
          amount: 10.0,
          paymentIntentId: 'intent_123',
        );

    setUp(() {
      capturedArgs = null;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(channel.name, (message) async {
        final call = const JSONMethodCodec().decodeMethodCall(message);
        capturedArgs = call.arguments as Map<dynamic, dynamic>;
        return const JSONMethodCodec()
            .encodeSuccessEnvelope({'status': 'success'});
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(channel.name, null);
    });

    test('omits configuration key when no configuration is passed', () async {
      final result = await plugin.presentEntirePaymentFlow(buildSession());

      expect(result, isA<PaymentSuccessResult>());
      expect(capturedArgs, isNotNull);
      expect(capturedArgs!.containsKey('session'), isTrue);
      expect(capturedArgs!.containsKey('configuration'), isFalse);
    });

    test('includes configuration json when accordion configuration is passed',
        () async {
      final result = await plugin.presentEntirePaymentFlow(
        buildSession(),
        configuration: const PaymentSheetConfiguration(
            layout: PaymentLayout.accordion),
      );

      expect(result, isA<PaymentSuccessResult>());
      expect(capturedArgs, isNotNull);
      expect(capturedArgs!['configuration'], {'layout': 'accordion'});
    });
  });
}
