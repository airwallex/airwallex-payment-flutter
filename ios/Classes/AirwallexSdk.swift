import Airwallex
import Flutter

class AirwallexSdk: NSObject {
    private var result: FlutterResult?
    private var paymentConsentID: String?
    private var applePayProvider: AWXApplePayProvider?
    private var cardProvider: AWXCardProvider?
    private var hostVC: UIViewController?
    
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
        
        DispatchQueue.main.async {
            AWXUIContext.launchPayment(
                from: self.getViewController(),
                session: session,
                paymentResultDelegate: self,
                launchStyle: .present
            )
        }
    }
    
    func presentCardPaymentFlow(clientSecret: String, session: NSDictionary, result: @escaping FlutterResult) {
        self.result = result
        
        AWXAPIClientConfiguration.shared().clientSecret = clientSecret
        
        let session = buildAirwallexSession(from: session)
        
        DispatchQueue.main.async {
            AWXUIContext.launchCardPayment(
                from: self.getViewController(),
                session: session,
                paymentResultDelegate: self,
                launchStyle: .present
            )
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
    
    func payWithCardDetails(clientSecret: String, session: NSDictionary, card: NSDictionary, saveCard: Bool, result: @escaping FlutterResult) {
        self.result = result
        
        AWXAPIClientConfiguration.shared().clientSecret = clientSecret
        
        let session = buildAirwallexSession(from: session)
        let card = AWXCard.decode(fromJSON: card as? [AnyHashable : Any]) as! AWXCard
        
        let cardProvider = AWXCardProvider(delegate: self, session: session)
        hostVC = getViewController()
        DispatchQueue.main.async {
            cardProvider.confirmPaymentIntent(with: card, billing: nil, saveCard: saveCard)
        }
        self.cardProvider = cardProvider
    }
    
    func payWithConsent(clientSecret: String, session: NSDictionary, consent: NSDictionary, result: @escaping FlutterResult) {
        self.result = result
        
        AWXAPIClientConfiguration.shared().clientSecret = clientSecret
        
        let session = buildAirwallexSession(from: session)
        let consent = AWXPaymentConsent.decode(fromJSON: consent as? [AnyHashable : Any]) as! AWXPaymentConsent
        
        let cardProvider = AWXCardProvider(delegate: self, session: session)
        hostVC = getViewController()
        DispatchQueue.main.async {
            cardProvider.confirmPaymentIntent(with: consent)
        }
        self.cardProvider = cardProvider
    }
    
    private func getViewController() -> UIViewController {
        var presentingViewController = UIApplication.shared.delegate?.window??.rootViewController
        
        while let presented = presentingViewController?.presentedViewController {
            presentingViewController = presented
        }

        return presentingViewController ?? UIViewController()
    }
}

extension AirwallexSdk: AWXPaymentResultDelegate {
    func paymentViewController(_ controller: UIViewController?, didCompleteWith status: AirwallexPaymentStatus, error: Error?) {
        controller?.dismiss(animated: true) {
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
                self.result?(FlutterError(code: String((error as? NSError)?.code ?? -1), message: error?.localizedDescription, details: nil))
            case .cancel:
                self.result?(["status": "cancelled"])
            }
            self.result = nil
            self.paymentConsentID = nil
        }
    }
    
    func paymentViewController(_ controller: UIViewController?, didCompleteWithPaymentConsentId paymentConsentId: String) {
        self.paymentConsentID = paymentConsentId
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
            var successDict = ["status": "success"]
            if let consentID = self.paymentConsentID {
                successDict["paymentConsentId"] = consentID
            }
            result?(successDict)
        case .inProgress:
            result?(["status": "inProgress"])
        case .failure:
            result?(FlutterError(code: String((error as? NSError)?.code ?? -1), message: error?.localizedDescription, details: nil))
        case .cancel:
            result?(["status": "cancelled"])
        }
        result = nil
        paymentConsentID = nil
        applePayProvider = nil
        cardProvider = nil
        hostVC = nil
    }
    
    func provider(_ provider: AWXDefaultProvider, didCompleteWithPaymentConsentId paymentConsentId: String) {
        self.paymentConsentID = paymentConsentId
    }
    
    func hostViewController() -> UIViewController {
        hostVC ?? getViewController()
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
