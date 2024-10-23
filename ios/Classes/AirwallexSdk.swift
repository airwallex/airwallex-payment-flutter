import Airwallex
import Flutter

class AirwallexSdk: NSObject, AWXPaymentResultDelegate {
    private var result: FlutterResult?
    private var paymentConsentID: String?
    
    func initialize(environment: String) {
        if let mode = AirwallexSDKMode.from(environment) {
            Airwallex.setMode(mode)
        }
    }
    
    func presentEntirePaymentFlow(clientSecret: String, session: NSDictionary, result: @escaping FlutterResult) {
        self.result = result
        
        AWXAPIClientConfiguration.shared().clientSecret = clientSecret
        
        let session = buildAirwallexSession(from: session)
        
        let context = AWXUIContext.shared()
        context.delegate = self
        context.session = session
        
        DispatchQueue.main.async {
            context.presentEntirePaymentFlow(from: UIApplication.shared.delegate?.window??.rootViewController ?? UIViewController())
        }
    }
    
    func paymentViewController(_ controller: UIViewController, didCompleteWith status: AirwallexPaymentStatus, error: Error?) {
        controller.dismiss(animated: true) {
            switch status {
            case .success:
                var successDict = ["status": "success"]
                if let consentID = self.paymentConsentID {
                    successDict["paymentConsentId"] = consentID
                }
                self.result?(successDict)
            case .inProgress:
                self.result?(["status": "inProgress"])
            case .failure:
                self.result?(FlutterError(code: String((error as? NSError)?.code ?? -1), message: error?.localizedDescription, details: error))
            case .cancel:
                self.result?(["status": "cancelled"])
            }
            self.result = nil
        }
    }
    
    func paymentViewController(_ controller: UIViewController, didCompleteWithPaymentConsentId paymentConsentId: String) {
        self.paymentConsentID = paymentConsentId
    }
}

private extension AirwallexSDKMode {
    static func from(_ stringValue: String) -> Self? {
        switch stringValue {
        case "staging":
            .stagingMode
        case "demo":
            .demoMode
        case "production":
            .productionMode
        default:
            nil
        }
    }
}
