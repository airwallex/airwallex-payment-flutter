package com.example.airwallex_payment_flutter.util

import com.airwallex.android.core.AirwallexPaymentSession
import com.airwallex.android.core.GooglePayOptions
import com.airwallex.android.core.ShippingAddressParameters
import com.airwallex.android.core.googlePaySupportedNetworks
import com.airwallex.android.core.model.PaymentIntent
import com.airwallex.android.core.model.PurchaseOrder
import org.json.JSONObject
import java.math.BigDecimal

object AirwallexPaymentSessionParser {

    fun parse(sessionObject: JSONObject, clientSecret: String): AirwallexPaymentSession {
        val googlePayOptions = sessionObject.optJSONObject("googlePayOptions")?.toGooglePayOptions()
        val customerId = sessionObject.getNullableString("customerId")
        val returnUrl = sessionObject.getNullableString("returnUrl")
        val paymentMethods = sessionObject.optJSONArray("paymentMethods")?.let { jsonArray ->
            List(jsonArray.length()) { i -> jsonArray.optString(i, null) }
        }
        val autoCapture = sessionObject.optBoolean("autoCapture", true)
        val hidePaymentConsents = sessionObject.optBoolean("hidePaymentConsents", false)
        val isBillingRequired = sessionObject.optBoolean("isBillingRequired", true)
        val isEmailRequired = sessionObject.optBoolean("isEmailRequired", false)

        val shipping = sessionObject.optJSONObject("shipping")?.toShipping()
        val amount = BigDecimal(sessionObject.optDouble("amount", -1.0).takeIf { it != -1.0 }
            ?.toString() ?: error("amount is required"))
        val currency = sessionObject.getStringOrThrow("currency")
        val countryCode = sessionObject.getStringOrThrow("countryCode")

        val paymentIntentId = sessionObject.getStringOrThrow("paymentIntentId")

        if (customerId == "") {
            error("customerId must not be empty")
        }

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

        return AirwallexPaymentSession.Builder(
            paymentIntent = paymentIntent,
            countryCode = countryCode,
            googlePayOptions = googlePayOptions,
        ).setRequireBillingInformation(isBillingRequired)
            .setRequireEmail(isEmailRequired)
            .setReturnUrl(returnUrl)
            .setAutoCapture(autoCapture)
            .setHidePaymentConsents(hidePaymentConsents)
            .setPaymentMethods(paymentMethods)
            .build()
    }

    private fun JSONObject.toGooglePayOptions(): GooglePayOptions {
        val billingAddressParameters =
            this.optJSONObject("billingAddressParameters")?.toBillingAddressParameters()
        val shippingAddressParameters =
            this.optJSONObject("shippingAddressParameters")?.toShippingAddressParameters()

        return GooglePayOptions(
            allowedCardAuthMethods = this.optJSONArray("allowedCardAuthMethods")?.let { jsonArray ->
                List(jsonArray.length()) { i -> jsonArray.optString(i, null) }
            },
            merchantName = this.getNullableString("merchantName"),
            allowPrepaidCards = this.getNullableBoolean("allowPrepaidCards"),
            allowCreditCards = this.getNullableBoolean("allowCreditCards"),
            assuranceDetailsRequired = this.getNullableBoolean("assuranceDetailsRequired"),
            billingAddressRequired = this.getNullableBoolean("billingAddressRequired"),
            billingAddressParameters = billingAddressParameters,
            transactionId = this.getNullableString("transactionId"),
            totalPriceLabel = this.getNullableString("totalPriceLabel"),
            checkoutOption = this.getNullableString("checkoutOption"),
            emailRequired = this.getNullableBoolean("emailRequired"),
            shippingAddressRequired = this.getNullableBoolean("shippingAddressRequired"),
            shippingAddressParameters = shippingAddressParameters,
            allowedCardNetworks = this.optJSONArray("allowedCardNetworks")?.let { jsonArray ->
                List(jsonArray.length()) { i -> jsonArray.optString(i, null) }
            } ?: googlePaySupportedNetworks(),
            skipReadinessCheck = this.optBoolean("skipReadinessCheck", false)
        )
    }

    private fun JSONObject.toShippingAddressParameters(): ShippingAddressParameters {
        val allowedCountryCodes = this.optJSONArray("allowedCountryCodes")?.let { jsonArray ->
            List(jsonArray.length()) { i -> jsonArray.optString(i, null) }
        }
        return ShippingAddressParameters(
            allowedCountryCodes = allowedCountryCodes,
            phoneNumberRequired = this.optBoolean("phoneNumberRequired")
        )
    }
}