import 'package:flutter_test/flutter_test.dart';
import 'package:airwallex_payment_flutter/airwallex_payment_flutter.dart';
import 'package:airwallex_payment_flutter/airwallex_payment_flutter_platform_interface.dart';
import 'package:airwallex_payment_flutter/airwallex_payment_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAirwallexPaymentFlutterPlatform
    with MockPlatformInterfaceMixin
    implements AirwallexPaymentFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AirwallexPaymentFlutterPlatform initialPlatform = AirwallexPaymentFlutterPlatform.instance;

  test('$MethodChannelAirwallexPaymentFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAirwallexPaymentFlutter>());
  });

  test('getPlatformVersion', () async {
    AirwallexPaymentFlutter airwallexPaymentFlutterPlugin = AirwallexPaymentFlutter();
    MockAirwallexPaymentFlutterPlatform fakePlatform = MockAirwallexPaymentFlutterPlatform();
    AirwallexPaymentFlutterPlatform.instance = fakePlatform;

    expect(await airwallexPaymentFlutterPlugin.getPlatformVersion(), '42');
  });
}
