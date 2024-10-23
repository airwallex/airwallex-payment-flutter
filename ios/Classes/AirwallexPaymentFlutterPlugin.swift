import Flutter
import UIKit

public class AirwallexPaymentFlutterPlugin: NSObject, FlutterPlugin {
    private var sdk: AirwallexSdk?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "samples.flutter.dev/airwallex_payment", binaryMessenger: registrar.messenger())
        let plugin = AirwallexPaymentFlutterPlugin()
        channel.setMethodCallHandler{ (call, result) in
            plugin.handle(call, result: result)
        }
        registrar.addMethodCallDelegate(plugin, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            sdk = AirwallexSdk()
            sdk?.initialize(environment: "demo")
        case "presentEntirePaymentFlow":
            if let arguments = call.arguments as? NSDictionary {
                sdk?.presentEntirePaymentFlow(clientSecret: arguments["clientSecret"] as! String, session: arguments, result: result)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
