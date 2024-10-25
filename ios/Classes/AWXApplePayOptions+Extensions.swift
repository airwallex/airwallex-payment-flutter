//
//  AWXApplePayOptions+Extensions.swift
//  airwallex-payment-flutter
//
//  Created by Hector.Huang on 2024/10/25.
//

import Airwallex

extension AWXApplePayOptions {
    convenience init(params: NSDictionary) {
        self.init(merchantIdentifier: params["merchantIdentifier"] as! String)
        if let networks = params["supportedNetworks"] as? [String] {
            supportedNetworks = networks.map { PKPaymentNetwork.from($0) }
        }
        if let contacts = params["requiredBillingContactFields"] as? [String] {
            requiredBillingContactFields = Set(contacts.map { PKContactField(rawValue: $0) })
        }
        if let countries = params["supportedCountries"] as? [String] {
            supportedCountries = Set(countries)
        }
        totalPriceLabel = params["totalPriceLabel"] as? String
    }
}

private extension PKPaymentNetwork {
    static func from(_ stringValue: String) -> Self {
        switch stringValue {
        case "unionPay":
            .chinaUnionPay
        default:
            PKPaymentNetwork(rawValue: stringValue)
        }
    }
}
