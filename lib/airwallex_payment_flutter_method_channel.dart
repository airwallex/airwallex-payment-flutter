import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'airwallex_payment_flutter_platform_interface.dart';

/// An implementation of [AirwallexPaymentFlutterPlatform] that uses method channels.
class MethodChannelAirwallexPaymentFlutter extends AirwallexPaymentFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('airwallex_payment_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
