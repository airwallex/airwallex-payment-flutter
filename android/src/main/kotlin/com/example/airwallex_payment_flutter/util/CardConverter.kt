package com.example.airwallex_payment_flutter.util

import com.airwallex.android.core.model.PaymentMethod
import io.flutter.plugin.common.MethodCall

object CardConverter {

    fun fromMethodCall(call: MethodCall): PaymentMethod.Card {
        val arguments = call.arguments as? Map<*, *>

        val cardMap = arguments?.get("card") as? Map<*, *>
        val builder = PaymentMethod.Card.Builder()

        cardMap?.let {
            builder.setCvc(it["cvc"] as? String)
                .setExpiryMonth(it["expiryMonth"] as? String)
                .setExpiryYear(it["expiryYear"] as? String)
                .setName(it["name"] as? String)
                .setNumber(it["number"] as? String)
                .setBin(it["bin"] as? String)
                .setLast4(it["last4"] as? String)
                .setBrand(it["brand"] as? String)
                .setCountry(it["country"] as? String)
                .setFunding(it["funding"] as? String)
                .setFingerprint(it["fingerprint"] as? String)
                .setCvcCheck(it["cvcCheck"] as? String)
                .setAvsCheck(it["avsCheck"] as? String)
                .setIssuerCountryCode(it["issuerCountryCode"] as? String)
                .setCardType(it["cardType"] as? String)

//            val numberTypeStr = it["numberType"] as? String
//            val numberType = mapStringToNumberType(numberTypeStr)
//            builder.setNumberType(numberType)
        }

        return builder.build()
    }

    private fun mapStringToNumberType(value: String?): PaymentMethod.Card.NumberType? {
        return when (value?.uppercase()) {
            "PAN" -> PaymentMethod.Card.NumberType.PAN
            "EXTERNAL_NETWORK_TOKEN" -> PaymentMethod.Card.NumberType.EXTERNAL_NETWORK_TOKEN
            "AIRWALLEX_NETWORK_TOKEN" -> PaymentMethod.Card.NumberType.AIRWALLEX_NETWORK_TOKEN
            else -> null
        }
    }
}

