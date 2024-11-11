package com.example.airwallex_payment_flutter.util

import com.airwallex.android.core.AirwallexRecurringSession
import com.airwallex.android.core.model.PaymentConsent
import com.example.airwallex_payment_flutter.util.AirwallexPaymentSessionConverter.toShipping
import org.json.JSONObject
import java.math.BigDecimal

object AirwallexRecurringSessionConverter {

    fun fromJsonObject(
        sessionObject: JSONObject,
        clientSecret: String
    ): AirwallexRecurringSession {
        val nextTriggerBy = sessionObject.getNullableString("nextTriggeredBy")?.let {
            toNextTriggeredBy(it) ?: error("Invalid NextTriggeredBy value")
        } ?: error("nextTriggeredBy is required")

        val requiresCVC = sessionObject.optBoolean("requiresCVC", false)

        val merchantTriggerReason = sessionObject.getNullableString("merchantTriggerReason")?.let {
            toMerchantTriggerReason(it)
                ?: error("Invalid MerchantTriggerReason value")
        } ?: PaymentConsent.MerchantTriggerReason.UNSCHEDULED

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

        return AirwallexRecurringSession.Builder(
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
            .setMerchantTriggerReason(merchantTriggerReason)
            .setReturnUrl(returnUrl)
            .setRequireEmail(isEmailRequired)
            .setPaymentMethods(paymentMethods)
            .build()
    }

    private fun toNextTriggeredBy(value: String): PaymentConsent.NextTriggeredBy? {
        return when (value.lowercase()) {
            "merchant" -> PaymentConsent.NextTriggeredBy.MERCHANT
            "customer" -> PaymentConsent.NextTriggeredBy.CUSTOMER
            else -> null
        }
    }

    private fun toMerchantTriggerReason(value: String): PaymentConsent.MerchantTriggerReason? {
        return when (value.lowercase()) {
            "scheduled" -> PaymentConsent.MerchantTriggerReason.SCHEDULED
            "unscheduled" -> PaymentConsent.MerchantTriggerReason.UNSCHEDULED
            else -> null
        }
    }
}