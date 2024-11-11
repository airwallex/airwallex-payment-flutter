package com.example.airwallex_payment_flutter.util

import com.airwallex.android.core.model.PaymentConsent
import com.airwallex.android.core.model.parser.PaymentConsentParser
import org.json.JSONObject

object AirwallexPaymentConsentParser {

    fun parse(consentObject: JSONObject): PaymentConsent {
        return PaymentConsentParser().parse(consentObject)
    }
}

