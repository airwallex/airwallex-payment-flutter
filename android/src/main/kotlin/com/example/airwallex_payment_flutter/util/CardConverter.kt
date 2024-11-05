package com.example.airwallex_payment_flutter.util

import com.airwallex.android.core.model.PaymentMethod
import io.flutter.plugin.common.MethodCall
import org.json.JSONObject

object CardConverter {

    fun fromMethodCall(call: MethodCall): PaymentMethod.Card {
        val argumentsObject = call.arguments<JSONObject>()
        val cardJson = argumentsObject?.optJSONObject("card") ?: throw IllegalArgumentException("card is required")
        val builder = PaymentMethod.Card.Builder()
        cardJson.let {
            builder.setCvc(it.optNullableString("cvc"))
                .setExpiryMonth(it.optNullableString("expiryMonth"))
                .setExpiryYear(it.optNullableString("expiryYear"))
                .setName(it.optNullableString("name"))
                .setNumber(it.optNullableString("number"))
                .setBin(it.optNullableString("bin"))
                .setLast4(it.optNullableString("last4"))
                .setBrand(it.optNullableString("brand"))
                .setCountry(it.optNullableString("country"))
                .setFunding(it.optNullableString("funding"))
                .setFingerprint(it.optNullableString("fingerprint"))
                .setCvcCheck(it.optNullableString("cvcCheck"))
                .setAvsCheck(it.optNullableString("avsCheck"))
                .setIssuerCountryCode(it.optNullableString("issuerCountryCode"))
                .setCardType(it.optNullableString("cardType"))

            // val numberTypeStr = it.optNullableString("numberType")
            // val numberType = mapStringToNumberType(numberTypeStr)
            // builder.setNumberType(numberType)
        }

        return builder.build()
    }

    private fun mapStringToNumberType(value: String?): PaymentMethod.Card.NumberType? {
        return when (value?.lowercase()) {
            "pan" -> PaymentMethod.Card.NumberType.PAN
            "external_network_token" -> PaymentMethod.Card.NumberType.EXTERNAL_NETWORK_TOKEN
            "airwallex_network_token" -> PaymentMethod.Card.NumberType.AIRWALLEX_NETWORK_TOKEN
            else -> null
        }
    }
}

