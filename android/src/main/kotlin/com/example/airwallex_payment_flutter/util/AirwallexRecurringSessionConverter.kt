package com.example.airwallex_payment_flutter.util

import com.airwallex.android.core.AirwallexRecurringSession
import org.json.JSONObject
import java.math.BigDecimal

object AirwallexRecurringSessionConverter {

    fun fromJsonObject(
        sessionObject: JSONObject,
        clientSecret: String
    ): AirwallexRecurringSession {
        val nextTriggerBy =
            sessionObject.toNextTriggeredBy() ?: error("nextTriggeredBy is error")

        val requiresCVC = sessionObject.optBoolean("requiresCVC", false)

        val merchantTriggerReason = sessionObject.toMerchantTriggerReason()

        val currency = sessionObject.getStringOrThrow("currency")
        val countryCode = sessionObject.getStringOrThrow("countryCode")
        val amount = BigDecimal(sessionObject.optDouble("amount", -1.0).takeIf { it != -1.0 }
            ?.toString() ?: error("amount is required"))
        val customerId = sessionObject.getStringOrThrow("customerId")

        val returnUrl = sessionObject.getNullableString("returnUrl")
        val shipping = sessionObject.optJSONObject("shipping")?.toShipping()
        val isBillingRequired = sessionObject.optBoolean("isBillingRequired", true)
        val paymentMethods = sessionObject.optJSONArray("paymentMethods")?.let { jsonArray ->
            List(jsonArray.length()) { i -> jsonArray.optString(i, null) }
        }
        val isEmailRequired = sessionObject.optBoolean("isEmailRequired", false)

        val sessionBuilder = AirwallexRecurringSession.Builder(
            customerId = customerId,
            currency = currency,
            amount = amount,
            nextTriggerBy = nextTriggerBy,
            countryCode = countryCode,
            clientSecret = clientSecret
        )
            .setShipping(shipping)
            .setRequireBillingInformation(isBillingRequired)
            .setRequireCvc(requiresCVC)
            .setReturnUrl(returnUrl)
            .setRequireEmail(isEmailRequired)
            .setPaymentMethods(paymentMethods)
        merchantTriggerReason?.let {
            sessionBuilder.setMerchantTriggerReason(merchantTriggerReason)
        }
        return sessionBuilder.build()
    }
}