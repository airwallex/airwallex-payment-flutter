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
            if let arguments = call.arguments as? NSDictionary, let session = arguments["session"] as? NSDictionary {
                sdk?.presentEntirePaymentFlow(clientSecret: session["clientSecret"] as! String, session: session, result: result)
            }
        case "presentCardPaymentFlow":
            if let arguments = call.arguments as? NSDictionary, let session = arguments["session"] as? NSDictionary {
                sdk?.presentCardPaymentFlow(clientSecret: session["clientSecret"] as! String, session: session, result: result)
            }
        case "startApplePay":
            if let arguments = call.arguments as? NSDictionary, let session = arguments["session"] as? NSDictionary {
                sdk?.startApplePay(clientSecret: session["clientSecret"] as! String, session: session, result: result)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
