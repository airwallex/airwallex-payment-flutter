import Flutter
import UIKit

public class AirwallexPaymentFlutterPlugin: NSObject, FlutterPlugin {
    private var sdk: AirwallexSdk?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "airwallex_payment_flutter", binaryMessenger: registrar.messenger())
        channel.setMethodCallHandler(handle)
        let instance = AirwallexPaymentFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            sdk = AirwallexSdk()
            sdk?.initialize(environment: "demo")
        case "presentEntirePaymentFlow":
            if let arguments = call.arguments as? NSDictionary {
                sdk?.presentEntirePaymentFlow(clientSecret: arguments["clientSecret"] as! String, session: arguments["session"] as! NSDictionary, result: result)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
