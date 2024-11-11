package com.example.airwallex_payment_flutter.util

import com.airwallex.android.core.AirwallexRecurringWithIntentSession
import com.airwallex.android.core.model.PaymentIntent
import com.airwallex.android.core.model.PurchaseOrder
import org.json.JSONObject
import java.math.BigDecimal

object AirwallexRecurringWithIntentSessionParser {

    fun parse(
        sessionObject: JSONObject,
        clientSecret: String
    ): AirwallexRecurringWithIntentSession {
        val paymentIntentId = sessionObject.optString("paymentIntentId")

        val nextTriggerBy =
            sessionObject.toNextTriggeredBy() ?: error("nextTriggeredBy is error")

        val currency = sessionObject.optString("currency")
        val countryCode = sessionObject.optString("countryCode")

        val amount = BigDecimal(sessionObject.optDouble("amount", -1.0).takeIf { it != -1.0 }
            ?.toString() ?: error("amount is required"))

        val customerId = sessionObject.optString("customerId")

        val returnUrl = sessionObject.getNullableString("returnUrl")
        val requiresCVC = sessionObject.optBoolean("requiresCVC", false)
        val merchantTriggerReason = sessionObject.toMerchantTriggerReason()

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

        val sessionBuilder = AirwallexRecurringWithIntentSession.Builder(
            paymentIntent = paymentIntent,
            nextTriggerBy = nextTriggerBy,
            customerId = customerId,
            countryCode = countryCode
        )
            .setRequireCvc(requiresCVC)
            .setPaymentMethods(paymentMethods)
            .setRequireBillingInformation(isBillingRequired)
            .setRequireEmail(isEmailRequired)
            .setReturnUrl(returnUrl)
            .setAutoCapture(autoCapture)
        merchantTriggerReason?.let {
            sessionBuilder.setMerchantTriggerReason(merchantTriggerReason)
        }
        return sessionBuilder.build()
    }
}