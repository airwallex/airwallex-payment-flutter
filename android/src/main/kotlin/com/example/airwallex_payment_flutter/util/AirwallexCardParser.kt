package com.example.airwallex_payment_flutter.util

import com.airwallex.android.core.model.PaymentMethod
import com.airwallex.android.core.model.parser.ModelJsonParser
import com.airwallex.android.core.model.parser.PaymentMethodParser
import org.json.JSONObject

object AirwallexCardParser : ModelJsonParser<PaymentMethod.Card> {

    override fun parse(json: JSONObject): PaymentMethod.Card {
        return PaymentMethodParser.CardParser().parse(json)
    }
}



