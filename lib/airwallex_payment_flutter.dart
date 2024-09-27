
import 'airwallex_payment_flutter_platform_interface.dart';

class AirwallexPaymentFlutter {
  Future<String?> getPlatformVersion() {
    return AirwallexPaymentFlutterPlatform.instance.getPlatformVersion();
  }
}
