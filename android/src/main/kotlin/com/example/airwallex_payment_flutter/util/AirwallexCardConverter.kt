package com.example.airwallex_payment_flutter.util

import com.airwallex.android.core.model.PaymentMethod
import org.json.JSONObject

object AirwallexCardConverter {

    fun fromJsonObject(cardJson: JSONObject): PaymentMethod.Card {
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
                .setNumberType(it.toNumberType())
        }
        return builder.build()
    }
}

