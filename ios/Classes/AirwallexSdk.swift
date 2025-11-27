import Airwallex
import Flutter

class AirwallexSdk: NSObject {
    private var result: FlutterResult?
    private var paymentConsentID: String?
    private var paymentSessionHandler: PaymentSessionHandler?
    
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

        let handler = PaymentSessionHandler(
            session: session,
            viewController: getViewController(),
            paymentResultDelegate: self
        )
        DispatchQueue.main.async {
            handler.startApplePay()
        }
        self.paymentSessionHandler = handler
    }
    
    func payWithCardDetails(clientSecret: String, session: NSDictionary, card: NSDictionary, saveCard: Bool, result: @escaping FlutterResult) {
        self.result = result

        AWXAPIClientConfiguration.shared().clientSecret = clientSecret

        let session = buildAirwallexSession(from: session)
        let card = AWXCard.decode(fromJSON: card as? [AnyHashable : Any]) as! AWXCard

        let handler = PaymentSessionHandler(
            session: session,
            viewController: getViewController(),
            paymentResultDelegate: self
        )
        DispatchQueue.main.async {
            handler.startCardPayment(with: card, billing: session.billing, saveCard: saveCard)
        }
        self.paymentSessionHandler = handler
    }
    
    func payWithConsent(clientSecret: String, session: NSDictionary, consent: NSDictionary, result: @escaping FlutterResult) {
        self.result = result

        AWXAPIClientConfiguration.shared().clientSecret = clientSecret

        let session = buildAirwallexSession(from: session)
        let consent = AWXPaymentConsent.decode(fromJSON: consent as? [AnyHashable : Any]) as! AWXPaymentConsent

        let handler = PaymentSessionHandler(
            session: session,
            viewController: getViewController(),
            paymentResultDelegate: self
        )
        DispatchQueue.main.async {
            handler.startConsentPayment(with: consent)
        }
        self.paymentSessionHandler = handler
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
        self.paymentSessionHandler = nil
    }

    func paymentViewController(_ controller: UIViewController?, didCompleteWithPaymentConsentId paymentConsentId: String) {
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
