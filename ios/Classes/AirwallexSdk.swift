import Airwallex
import Flutter

class AirwallexSdk: NSObject {
    private var result: FlutterResult?
    private var paymentConsentID: String?
    private var applePayProvider: AWXApplePayProvider?
    
    func initialize(environment: String) {
        if let mode = AirwallexSDKMode.from(environment) {
            Airwallex.setMode(mode)
            AWXAPIClientConfiguration.shared()
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
            context.presentEntirePaymentFlow(from: self.getViewController())
        }
    }
    
    func presentCardPaymentFlow(clientSecret: String, session: NSDictionary, result: @escaping FlutterResult) {
        self.result = result
        
        AWXAPIClientConfiguration.shared().clientSecret = clientSecret
        
        let session = buildAirwallexSession(from: session)
        
        let context = AWXUIContext.shared()
        context.delegate = self
        context.session = session
        
        DispatchQueue.main.async {
            context.presentCardPaymentFlow(from: self.getViewController())
        }
    }
    
    func startApplePay(clientSecret: String, session: NSDictionary, result: @escaping FlutterResult) {
        self.result = result
        
        AWXAPIClientConfiguration.shared().clientSecret = clientSecret
        
        let session = buildAirwallexSession(from: session)
        
        let applePayProvider = AWXApplePayProvider(delegate: self, session: session)
        DispatchQueue.main.async {
            applePayProvider.startPayment()
        }
        self.applePayProvider = applePayProvider
    }
}

extension AirwallexSdk: AWXPaymentResultDelegate {
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
    
    private func getViewController() -> UIViewController {
        var presentingViewController = UIApplication.shared.delegate?.window??.rootViewController
        
        while let presented = presentingViewController?.presentedViewController {
            presentingViewController = presented
        }

        return presentingViewController ?? UIViewController()
    }
}

extension AirwallexSdk: AWXProviderDelegate {
    func providerDidStartRequest(_ provider: AWXDefaultProvider) {
    }
    
    func providerDidEndRequest(_ provider: AWXDefaultProvider) {
    }
    
    func provider(_ provider: AWXDefaultProvider, didInitializePaymentIntentId paymentIntentId: String) {
    }
    
    func provider(_ provider: AWXDefaultProvider, didCompleteWith status: AirwallexPaymentStatus, error: (any Error)?) {
        switch status {
        case .success:
            result?(["status": "success"])
        case .inProgress:
            result?(["status": "inProgress"])
        case .failure:
            result?(FlutterError(code: String((error as? NSError)?.code ?? -1), message: error?.localizedDescription, details: error))
        case .cancel:
            result?(["status": "cancelled"])
        }
        result = nil
        applePayProvider = nil
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
