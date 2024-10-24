import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:airwallex_payment_flutter/airwallex_payment_flutter_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelAirwallexPaymentFlutter platform = MethodChannelAirwallexPaymentFlutter();
  const MethodChannel channel = MethodChannel('airwallex_payment_flutter');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });


}
