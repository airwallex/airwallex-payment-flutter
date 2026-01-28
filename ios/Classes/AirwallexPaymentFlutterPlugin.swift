import Airwallex
import Flutter
import UIKit

public class AirwallexPaymentFlutterPlugin: NSObject, FlutterPlugin {
    private var sdk: AirwallexSdk?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "airwallex_payment_flutter", binaryMessenger: registrar.messenger(), codec: FlutterJSONMethodCodec())
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
            let arguments = call.arguments as! NSDictionary
            sdk?.initialize(environment: arguments["environment"] as! String)
            result(nil)
        case "presentEntirePaymentFlow":
            let arguments = call.arguments as! NSDictionary
            let session = arguments["session"] as! NSDictionary
            sdk?.presentEntirePaymentFlow(clientSecret: session["clientSecret"] as! String, session: session, result: result)
        case "presentCardPaymentFlow":
            let arguments = call.arguments as! NSDictionary
            let session = arguments["session"] as! NSDictionary
            sdk?.presentCardPaymentFlow(clientSecret: session["clientSecret"] as! String, session: session, result: result)
        case "startApplePay":
            let arguments = call.arguments as! NSDictionary
            let session = arguments["session"] as! NSDictionary
            sdk?.startApplePay(clientSecret: session["clientSecret"] as! String, session: session, result: result)
        case "payWithCardDetails":
            let arguments = call.arguments as! NSDictionary
            let session = arguments["session"] as! NSDictionary
            let card = arguments["card"] as! NSDictionary
            let saveCard = arguments["saveCard"] as! Bool
            sdk?.payWithCardDetails(clientSecret: session["clientSecret"] as! String, session: session, card: card, saveCard: saveCard, result: result)
        case "payWithConsent":
            let arguments = call.arguments as! NSDictionary
            let session = arguments["session"] as! NSDictionary
            let consent = arguments["consent"] as! NSDictionary
            sdk?.payWithConsent(clientSecret: session["clientSecret"] as! String, session: session, consent: consent, result: result)
        case "setTintColor":
            let arguments = call.arguments as! NSDictionary;
            let color = UIColor(red: (arguments["red"] as! CGFloat)/255, green: (arguments["green"] as! CGFloat)/255, blue: (arguments["blue"] as! CGFloat)/255, alpha: (arguments["alpha"] as! CGFloat)/255)
            AWXTheme.shared().tintColor = color
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
