package com.example.airwallex_payment_flutter.util

import com.airwallex.android.core.model.PaymentMethod
import com.airwallex.android.core.model.parser.ModelJsonParser
import com.airwallex.android.core.util.AirwallexJsonUtils
import org.json.JSONObject

object AirwallexCardParser : ModelJsonParser<PaymentMethod.Card> {

    private const val FIELD_CVC = "cvc"
    private const val FIELD_EXPIRY_MONTH = "expiry_month"
    private const val FIELD_EXPIRY_YEAR = "expiry_year"
    private const val FIELD_NAME = "name"
    private const val FIELD_NUMBER = "number"
    private const val FIELD_BIN = "bin"
    private const val FIELD_LAST4 = "last4"
    private const val FIELD_BRAND = "brand"
    private const val FIELD_COUNTRY = "country"
    private const val FIELD_FUNDING = "funding"
    private const val FIELD_FINGERPRINT = "fingerprint"
    private const val FIELD_CVC_CHECK = "cvc_check"
    private const val FIELD_AVS_CHECK = "avs_check"
    private const val FIELD_ISSUER_COUNTRY_CODE = "issuer_country_code"
    private const val FIELD_CARD_TYPE = "card_type"
    private const val FIELD_NUMBER_TYPE = "number_type"

    override fun parse(json: JSONObject): PaymentMethod.Card {
        return PaymentMethod.Card.Builder()
            .setCvc(AirwallexJsonUtils.optString(json, FIELD_CVC))
            .setExpiryMonth(AirwallexJsonUtils.optString(json, FIELD_EXPIRY_MONTH))
            .setExpiryYear(AirwallexJsonUtils.optString(json, FIELD_EXPIRY_YEAR))
            .setName(AirwallexJsonUtils.optString(json, FIELD_NAME))
            .setNumber(AirwallexJsonUtils.optString(json, FIELD_NUMBER))
            .setBin(AirwallexJsonUtils.optString(json, FIELD_BIN))
            .setLast4(AirwallexJsonUtils.optString(json, FIELD_LAST4))
            .setBrand(AirwallexJsonUtils.optString(json, FIELD_BRAND))
            .setCountry(AirwallexJsonUtils.optString(json, FIELD_COUNTRY))
            .setFunding(AirwallexJsonUtils.optString(json, FIELD_FUNDING))
            .setFingerprint(AirwallexJsonUtils.optString(json, FIELD_FINGERPRINT))
            .setCvcCheck(AirwallexJsonUtils.optString(json, FIELD_CVC_CHECK))
            .setAvsCheck(AirwallexJsonUtils.optString(json, FIELD_AVS_CHECK))
            .setIssuerCountryCode(AirwallexJsonUtils.optString(json, FIELD_ISSUER_COUNTRY_CODE))
            .setCardType(AirwallexJsonUtils.optString(json, FIELD_CARD_TYPE))
            .setNumberType(toNumberType(json.getNullableString(FIELD_NUMBER_TYPE)))
            .build()
    }

    private fun toNumberType(numberTypeString: String?): PaymentMethod.Card.NumberType? {
        return when (numberTypeString?.lowercase()) {
            "pan" -> PaymentMethod.Card.NumberType.PAN
            "external_network_token" -> PaymentMethod.Card.NumberType.EXTERNAL_NETWORK_TOKEN
            "airwallex_network_token" -> PaymentMethod.Card.NumberType.AIRWALLEX_NETWORK_TOKEN
            else -> null
        }
    }
}



