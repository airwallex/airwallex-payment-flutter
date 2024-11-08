//
//  AWXPaymentConsent+Extensions.swift
//  airwallex-payment-flutter
//
//  Created by Hector.Huang on 2024/11/6.
//

import Airwallex

extension AWXPaymentConsent {
    convenience init(params: NSDictionary) {
        self.init()
        if let id = params["id"] as? String {
            self.id = id
        }
        if let requestId = params["requestId"] as? String {
            self.requestId = requestId
        }
        if let customerId = params["customerId"] as? String {
            self.customerId = customerId
        }
        if let paymentMethodDict = params["paymentMethod"] as? NSDictionary {
            self.paymentMethod = AWXPaymentMethod(params: paymentMethodDict)
        }
        if let status = params["status"] as? String {
            self.status = status
        }
        if let nextTriggeredBy = params["nextTriggeredBy"] as? String {
            self.nextTriggeredBy = nextTriggeredBy
        }
        if let merchantTriggerReason = params["merchantTriggerReason"] as? String {
            self.merchantTriggerReason = merchantTriggerReason
        }
        self.requiresCVC = params["requiresCvc"] as! Bool
        if let createdAt = params["createdAt"] as? String {
            self.createdAt = createdAt
        }
        if let updatedAt = params["updatedAt"] as? String {
            self.updatedAt = updatedAt
        }
        if let clientSecret = params["clientSecret"] as? String {
            self.clientSecret = clientSecret
        }
    }
}

private extension AWXPaymentMethod {
    convenience init(params: NSDictionary) {
        self.init()
        if let type = params["type"] as? String {
            self.type = type
        }
        self.id = params["id"] as? String
        if let billingDict = params["billing"] as? NSDictionary {
            billing = AWXPlaceDetails(params: billingDict)
        }
        if let cardDict = params["card"] as? NSDictionary {
            card = AWXCard(params: cardDict)
        }
        customerId = params["customerId"] as? String
    }
}
