package com.example.airwallex_payment_flutter.util

import com.airwallex.android.core.*
import com.airwallex.android.core.model.*
import com.example.airwallex_payment_flutter.util.AirwallexPaymentSessionConverter.toShipping
import java.math.BigDecimal

@Suppress("UNCHECKED_CAST")
object AirwallexRecurringWithIntentSessionConverter {

    fun fromMapToRecurringWithIntentSession(sessionMap: Map<String, Any?>, clientSecret: String): AirwallexRecurringWithIntentSession {
        val paymentIntentId = sessionMap["paymentIntentId"] as? String
            ?: throw IllegalArgumentException("paymentIntentId is required")

        val nextTriggerBy = (sessionMap["nextTriggeredBy"] as? String)?.let {
            toNextTriggeredBy(it) ?: throw IllegalArgumentException("Invalid NextTriggeredBy value")
        } ?: throw IllegalArgumentException("nextTriggeredBy is required")

        val currency = sessionMap["currency"] as? String
            ?: throw IllegalArgumentException("currency is required")

        val countryCode = sessionMap["countryCode"] as? String
            ?: throw IllegalArgumentException("countryCode is required")

        val amount = BigDecimal((sessionMap["amount"] as? Int)?.toString() ?: throw IllegalArgumentException("amount is required"))

        val customerId = sessionMap["customerId"] as? String
            ?: throw IllegalArgumentException("customerId is required")

        val returnUrl = sessionMap["returnUrl"] as? String
        val requiresCVC = sessionMap["requiresCVC"] as? Boolean ?: false
        val merchantTriggerReason = (sessionMap["merchantTriggerReason"] as? String)?.let {
            toMerchantTriggerReason(it) ?: throw IllegalArgumentException("Invalid MerchantTriggerReason value")
        } ?: PaymentConsent.MerchantTriggerReason.UNSCHEDULED

        val paymentMethods = sessionMap["paymentMethods"] as? List<String>
        val shipping = (sessionMap["shipping"] as? Map<String, Any?>)?.toShipping()
        val isBillingRequired = sessionMap["isBillingRequired"] as? Boolean ?: true
        val isEmailRequired = sessionMap["isEmailRequired"] as? Boolean ?: false
        val autoCapture = sessionMap["autoCapture"] as? Boolean ?: true
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
        return when (value) {
            "merchant" -> PaymentConsent.NextTriggeredBy.MERCHANT
            "customer" -> PaymentConsent.NextTriggeredBy.CUSTOMER
            else -> null
        }
    }

    private fun toMerchantTriggerReason(value: String): PaymentConsent.MerchantTriggerReason? {
        return when (value) {
            "scheduled" -> PaymentConsent.MerchantTriggerReason.SCHEDULED
            "unscheduled" -> PaymentConsent.MerchantTriggerReason.UNSCHEDULED
            else -> null
        }
    }
}