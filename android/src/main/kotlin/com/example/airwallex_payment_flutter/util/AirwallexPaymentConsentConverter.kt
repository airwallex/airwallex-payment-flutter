package com.example.airwallex_payment_flutter.util

import com.airwallex.android.core.model.PaymentConsent
import com.airwallex.android.core.model.PaymentMethod
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.TimeZone

object AirwallexPaymentConsentConverter {

    fun fromJsonObject(consentObject: JSONObject): PaymentConsent {
        val id = consentObject.getNullableString("id")
        val requestId = consentObject.getNullableString("requestId")
        val customerId = consentObject.getNullableString("customerId")
        val nextTriggeredBy = consentObject.toNextTriggeredBy()
        val merchantTriggerReason = consentObject.toMerchantTriggerReason()
        val requiresCvc = consentObject.optBoolean("requiresCvc", false)
        val status = consentObject.toPaymentConsentStatus()
        val createdAt = consentObject.getNullableString("createdAt")?.let { parseDateString(it) }
        val updatedAt = consentObject.getNullableString("updatedAt")?.let { parseDateString(it) }
        val clientSecret = consentObject.getNullableString("clientSecret")

        val paymentMethod = consentObject.optJSONObject("paymentMethod")?.toPaymentMethod()
        val initialPaymentIntentId = consentObject.getNullableString("initialPaymentIntentId")
        val metadata = consentObject.getNullableMap("metadata")

        return PaymentConsent(
            id = id,
            requestId = requestId,
            customerId = customerId,
            paymentMethod = paymentMethod,
            status = status,
            nextTriggeredBy = nextTriggeredBy,
            merchantTriggerReason = merchantTriggerReason,
            requiresCvc = requiresCvc,
            createdAt = createdAt,
            updatedAt = updatedAt,
            clientSecret = clientSecret,
            //Fields that are not needed for now will be implemented later.
            initialPaymentIntentId = null,
            metadata = null,
            nextAction = null,
        )
    }

    private fun JSONObject.toPaymentMethod(): PaymentMethod {
        val id = getNullableString("id") ?: error("paymentMethod id is required")
        val customerId = getNullableString("customerId")
        val type = getNullableString("type") ?: error("paymentMethod type is required")
        val card = optJSONObject("card")?.let { AirwallexCardConverter.fromJsonObject(it) }
        val billing = optJSONObject("billing")?.toBilling()

        val requestId = getNullableString("requestId")
        return PaymentMethod.Builder()
            .setId(id)
            .setCustomerId(customerId)
            .setType(type)
            .setCard(card)
            .setBilling(billing)
            //Fields that are not needed for now will be implemented later.
            .setRequestId(null)
            .setStatus(null)
            .setMetadata(null)
            .setCreatedAt(null)
            .setUpdatedAt(null)
            .build()
    }


    private fun parseDateString(dateString: String): Date? {
        val dateFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.getDefault())
        dateFormat.timeZone = TimeZone.getTimeZone("UTC")
        return dateFormat.parse(dateString)
    }
}

