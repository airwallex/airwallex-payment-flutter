import Airwallex
import Flutter

class AirwallexSdk: NSObject {
    private var result: FlutterResult?
    private var paymentConsentID: String?
    private var paymentSessionHandler: PaymentSessionHandler?
    private let localeManager: AirwallexLocaleManager

    override init() {
        localeManager = AirwallexLocaleManager()
        super.init()
    }

    init(localeManager: AirwallexLocaleManager) {
        self.localeManager = localeManager
        super.init()
    }
    
    func initialize(environment: String) {
        localeManager.applyLocale()
        let mode = AirwallexSDKMode.from(environment)
        Airwallex.setMode(mode)
        AWXAPIClientConfiguration.shared()
    }

    func setLocale(languageTag: String?) {
        localeManager.setLocale(languageTag)
    }

    func prepareSession(from params: NSDictionary) -> AWXSession {
        localeManager.applyLocale()
        let session = buildAirwallexSession(from: params)
        applyConfiguredLocale(to: session)
        return session
    }

    func applyConfiguredLocale(to session: AWXSession) {
        guard let languageTag = localeManager.currentLanguageTag else {
            return
        }
        session.lang = languageTag
    }
    
    func presentEntirePaymentFlow(clientSecret: String, session: NSDictionary, result: @escaping FlutterResult) {
        self.result = result
        
        AWXAPIClientConfiguration.shared().clientSecret = clientSecret
        
        let session = prepareSession(from: session)
        
        DispatchQueue.main.async {
            self.localeManager.applyLocale()
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
        
        let session = prepareSession(from: session)
        
        DispatchQueue.main.async {
            self.localeManager.applyLocale()
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

        let session = prepareSession(from: session)

        DispatchQueue.main.async {
            self.localeManager.applyLocale()
            let handler = PaymentSessionHandler(
                session: session,
                viewController: self.getViewController(),
                paymentResultDelegate: self
            )
            handler.showIndicator = false
            handler.startApplePay()
            self.paymentSessionHandler = handler
        }
    }
    
    func payWithCardDetails(clientSecret: String, session: NSDictionary, card: NSDictionary, saveCard: Bool, result: @escaping FlutterResult) {
        self.result = result

        AWXAPIClientConfiguration.shared().clientSecret = clientSecret

        let session = prepareSession(from: session)
        let card = AWXCard.decode(fromJSON: card as? [AnyHashable : Any]) as! AWXCard

        DispatchQueue.main.async {
            self.localeManager.applyLocale()
            let handler = PaymentSessionHandler(
                session: session,
                viewController: self.getViewController(),
                paymentResultDelegate: self
            )
            handler.showIndicator = false
            handler.startCardPayment(with: card, billing: session.billing, saveCard: saveCard)
            self.paymentSessionHandler = handler
        }
    }
    
    func payWithConsent(clientSecret: String, session: NSDictionary, consent: NSDictionary, result: @escaping FlutterResult) {
        self.result = result

        AWXAPIClientConfiguration.shared().clientSecret = clientSecret

        let session = prepareSession(from: session)
        let consent = AWXPaymentConsent.decode(fromJSON: consent as? [AnyHashable : Any]) as! AWXPaymentConsent

        DispatchQueue.main.async {
            self.localeManager.applyLocale()
            let handler = PaymentSessionHandler(
                session: session,
                viewController: self.getViewController(),
                paymentResultDelegate: self
            )
            handler.showIndicator = false
            handler.startConsentPayment(with: consent)
            self.paymentSessionHandler = handler
        }
    }
    
    private func getViewController() -> UIViewController {
        let window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }

        var vc = window?.rootViewController
        while let presented = vc?.presentedViewController {
            vc = presented
        }
        return vc ?? UIViewController()
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
    static func from(_ stringValue: String) -> Self {
        switch stringValue {
        case "staging":
            return .stagingMode
        case "demo":
            return .demoMode
        case "production":
            return .productionMode
        default:
            #if DEBUG
            let defaultMode = AirwallexSDKMode.demoMode
            #else
            let defaultMode = AirwallexSDKMode.productionMode
            #endif
            print("[AirwallexSdk] Invalid environment '\(stringValue)', defaulting to \(defaultMode)")
            return defaultMode
        }
    }
}
