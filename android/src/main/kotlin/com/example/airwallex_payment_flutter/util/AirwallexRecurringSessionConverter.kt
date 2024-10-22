package com.example.airwallex_payment_flutter.util

import com.airwallex.android.core.AirwallexRecurringSession
import com.airwallex.android.core.model.*
import com.example.airwallex_payment_flutter.util.AirwallexPaymentSessionConverter.toShipping
import java.math.BigDecimal

@Suppress("UNCHECKED_CAST")
object AirwallexRecurringSessionConverter {

    fun fromMapToRecurringSession(
        sessionMap: Map<String, Any?>,
        clientSecret: String
    ): AirwallexRecurringSession {
        val nextTriggerBy = (sessionMap["nextTriggeredBy"] as? String)?.let {
            toNextTriggeredBy(it) ?: throw IllegalArgumentException("Invalid NextTriggeredBy value")
        } ?: throw IllegalArgumentException("nextTriggeredBy is required")

        val requiresCVC = sessionMap["requiresCVC"] as? Boolean ?: false

        val merchantTriggerReason = (sessionMap["merchantTriggerReason"] as? String)?.let {
            toMerchantTriggerReason(it)
                ?: throw IllegalArgumentException("Invalid MerchantTriggerReason value")
        } ?: PaymentConsent.MerchantTriggerReason.UNSCHEDULED

        val currency = sessionMap["currency"] as? String
            ?: throw IllegalArgumentException("currency is required")
        val countryCode = sessionMap["countryCode"] as? String
            ?: throw IllegalArgumentException("countryCode is required")
        val amount = BigDecimal(
            (sessionMap["amount"] as? Double)?.toString()
                ?: throw IllegalArgumentException("amount is required")
        )
        val customerId = sessionMap["customerId"] as? String
            ?: throw IllegalArgumentException("customerId is required")

        val returnUrl = sessionMap["returnUrl"] as? String
        val shipping = (sessionMap["shipping"] as? Map<String, Any?>)?.toShipping()
        val isBillingRequired = sessionMap["isBillingRequired"] as? Boolean ?: true
        val paymentMethods = sessionMap["paymentMethods"] as? List<String>
        val isEmailRequired = sessionMap["isEmailRequired"] as? Boolean ?: false

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