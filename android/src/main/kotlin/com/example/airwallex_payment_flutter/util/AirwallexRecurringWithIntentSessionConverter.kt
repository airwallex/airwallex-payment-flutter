package com.example.airwallex_payment_flutter.util

import com.airwallex.android.core.AirwallexRecurringWithIntentSession
import com.airwallex.android.core.model.PaymentConsent
import com.airwallex.android.core.model.PaymentIntent
import com.airwallex.android.core.model.PurchaseOrder
import com.example.airwallex_payment_flutter.util.AirwallexPaymentSessionConverter.toShipping
import org.json.JSONObject
import java.math.BigDecimal

object AirwallexRecurringWithIntentSessionConverter {

    fun fromJsonObject(
        sessionObject: JSONObject,
        clientSecret: String
    ): AirwallexRecurringWithIntentSession {
        val paymentIntentId = sessionObject.getStringOrThrow("paymentIntentId")

        val nextTriggerBy = sessionObject.getNullableString("nextTriggeredBy")?.let {
            toNextTriggeredBy(it) ?: error("Invalid NextTriggeredBy value")
        } ?: error("nextTriggeredBy is required")

        val currency = sessionObject.getStringOrThrow("currency")
        val countryCode = sessionObject.getStringOrThrow("countryCode")

        val amount = BigDecimal(sessionObject.optDouble("amount", -1.0).takeIf { it != -1.0 }
            ?.toString() ?: error("amount is required"))

        val customerId = sessionObject.getStringOrThrow("customerId")

        val returnUrl = sessionObject.getNullableString("returnUrl")
        val requiresCVC = sessionObject.optBoolean("requiresCVC", false)
        val merchantTriggerReason = sessionObject.getNullableString("merchantTriggerReason")?.let {
            toMerchantTriggerReason(it) ?: error("Invalid MerchantTriggerReason value")
        } ?: PaymentConsent.MerchantTriggerReason.UNSCHEDULED

        val paymentMethods = sessionObject.optJSONArray("paymentMethods")?.let { jsonArray ->
            List(jsonArray.length()) { i -> jsonArray.optString(i, null) }
        }
        val shipping = sessionObject.optJSONObject("shipping")?.toShipping()
        val isBillingRequired = sessionObject.optBoolean("isBillingRequired", true)
        val isEmailRequired = sessionObject.optBoolean("isEmailRequired", false)
        val autoCapture = sessionObject.optBoolean("autoCapture", true)

        val order = shipping?.let {
            PurchaseOrder(
                shipping = it
            )
        }

        val paymentIntent = PaymentIntent(
            id = paymentIntentId,
            amount = amount,
            currency = currency,
            customerId = customerId,
            order = order,
            clientSecret = clientSecret
        )

        return AirwallexRecurringWithIntentSession.Builder(
            paymentIntent = paymentIntent,
            nextTriggerBy = nextTriggerBy,
            customerId = customerId,
            countryCode = countryCode
        )
            .setRequireCvc(requiresCVC)
            .setMerchantTriggerReason(merchantTriggerReason)
            .setPaymentMethods(paymentMethods)
            .setRequireBillingInformation(isBillingRequired)
            .setRequireEmail(isEmailRequired)
            .setReturnUrl(returnUrl)
            .setAutoCapture(autoCapture)
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