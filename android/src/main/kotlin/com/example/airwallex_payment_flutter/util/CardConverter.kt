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
            builder.setCvc(it.getNullableString("cvc"))
                .setExpiryMonth(it.getNullableString("expiryMonth"))
                .setExpiryYear(it.getNullableString("expiryYear"))
                .setName(it.getNullableString("name"))
                .setNumber(it.getNullableString("number"))
                .setBin(it.getNullableString("bin"))
                .setLast4(it.getNullableString("last4"))
                .setBrand(it.getNullableString("brand"))
                .setCountry(it.getNullableString("country"))
                .setFunding(it.getNullableString("funding"))
                .setFingerprint(it.getNullableString("fingerprint"))
                .setCvcCheck(it.getNullableString("cvcCheck"))
                .setAvsCheck(it.getNullableString("avsCheck"))
                .setIssuerCountryCode(it.getNullableString("issuerCountryCode"))
                .setCardType(it.getNullableString("cardType"))

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

