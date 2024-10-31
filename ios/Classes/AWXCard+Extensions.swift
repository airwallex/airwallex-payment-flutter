//
//  AWXCard+Extensions.swift
//  airwallex-payment-flutter
//
//  Created by Hector.Huang on 2024/10/31.
//

import Airwallex

extension AWXCard {
    convenience init(params: NSDictionary) {
        self.init()
        cvc = params["cvc"] as? String
        if let expiryMonth = params["expiryMonth"] as? String {
            self.expiryMonth = expiryMonth
        }
        if let expiryYear = params["expiryYear"] as? String {
            self.expiryYear = expiryYear
        }
        if let number = params["number"] as? String {
            self.number = number
        }
        name = params["name"] as? String
        bin = params["bin"] as? String
        last4 = params["last4"] as? String
        brand = params["brand"] as? String
        country = params["country"] as? String
        funding = params["funding"] as? String
        fingerprint = params["fingerprint"] as? String
        cvcCheck = params["cvcCheck"] as? String
        avsCheck = params["avsCheck"] as? String
        country = params["issuerCountryCode"] as? String
        numberType = params["cardType"] as? String
    }
}
