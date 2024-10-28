package com.example.airwallex_payment_flutter.util

import com.airwallex.android.core.AirwallexPaymentSession
import com.airwallex.android.core.BillingAddressParameters
import com.airwallex.android.core.GooglePayOptions
import com.airwallex.android.core.ShippingAddressParameters
import com.airwallex.android.core.googlePaySupportedNetworks
import com.airwallex.android.core.model.Address
import com.airwallex.android.core.model.PaymentIntent
import com.airwallex.android.core.model.PurchaseOrder
import com.airwallex.android.core.model.Shipping
import java.math.BigDecimal

@Suppress("UNCHECKED_CAST")
object AirwallexPaymentSessionConverter {

    fun fromMap(sessionMap: Map<String, Any?>, clientSecret: String): AirwallexPaymentSession {
        val googlePayOptions =
            (sessionMap["googlePayOptions"] as? Map<String, Any?>)?.toGooglePayOptions()
        val customerId = sessionMap["customerId"] as? String
        val returnUrl = sessionMap["returnUrl"] as? String
        val paymentMethods = sessionMap["paymentMethods"] as? List<String>
        val autoCapture = sessionMap["autoCapture"] as? Boolean ?: true
        val hidePaymentConsents = sessionMap["hidePaymentConsents"] as? Boolean ?: false
        val isBillingRequired = sessionMap["isBillingRequired"] as? Boolean ?: true
        val isEmailRequired = sessionMap["isEmailRequired"] as? Boolean ?: false

        val shipping = (sessionMap["shipping"] as? Map<String, Any?>)?.toShipping()
        val amount = BigDecimal((sessionMap["amount"] as? Double)?.toString() ?: "0")
        val currency = sessionMap["currency"] as? String
            ?: throw IllegalArgumentException("currency is required")
        val countryCode = sessionMap["countryCode"] as? String
            ?: throw IllegalArgumentException("countryCode is required")

        val paymentIntentId = sessionMap["paymentIntentId"] as? String
            ?: throw IllegalArgumentException("paymentIntentId is required")

        if (customerId == "") {
            throw IllegalArgumentException("customerId must not be empty")
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

    private fun Map<String, Any?>.toGooglePayOptions(): GooglePayOptions {
        val billingAddressParametersMap = this["billingAddressParameters"] as? Map<String, Any?>
        val shippingAddressParametersMap = this["shippingAddressParameters"] as? Map<String, Any?>

        val billingAddressParameters = billingAddressParametersMap?.toBillingAddressParameters()
        val shippingAddressParameters = shippingAddressParametersMap?.toShippingAddressParameters()

        return GooglePayOptions(
            allowedCardAuthMethods = this["allowedCardAuthMethods"] as? List<String>,
            merchantName = this["merchantName"] as? String,
            allowPrepaidCards = this["allowPrepaidCards"] as? Boolean,
            allowCreditCards = this["allowCreditCards"] as? Boolean,
            assuranceDetailsRequired = this["assuranceDetailsRequired"] as? Boolean,
            billingAddressRequired = this["billingAddressRequired"] as? Boolean,
            billingAddressParameters = billingAddressParameters,
            transactionId = this["transactionId"] as? String,
            totalPriceLabel = this["totalPriceLabel"] as? String,
            checkoutOption = this["checkoutOption"] as? String,
            emailRequired = this["emailRequired"] as? Boolean,
            shippingAddressRequired = this["shippingAddressRequired"] as? Boolean,
            shippingAddressParameters = shippingAddressParameters,
            allowedCardNetworks = this["allowedCardNetworks"] as? List<String>
                ?: googlePaySupportedNetworks(),
            skipReadinessCheck = this["skipReadinessCheck"] as? Boolean ?: false
        )
    }

    private fun Map<String, Any?>.toBillingAddressParameters(): BillingAddressParameters {
        val formatStr = this["format"] as? String
        val format = when (formatStr?.lowercase()) {
            "min" -> BillingAddressParameters.Format.MIN
            "full" -> BillingAddressParameters.Format.FULL
            else -> throw IllegalArgumentException("Unknown format: $formatStr")
        }
        return BillingAddressParameters(
            format = format,
            phoneNumberRequired = this["phoneNumberRequired"] as? Boolean
        )
    }

    private fun Map<String, Any?>.toShippingAddressParameters(): ShippingAddressParameters {
        return ShippingAddressParameters(
            allowedCountryCodes = this["allowedCountryCodes"] as? List<String>,
            phoneNumberRequired = this["phoneNumberRequired"] as? Boolean
        )
    }

    fun Map<String, Any?>.toShipping(): Shipping? {
        val firstName = this["firstName"] as? String
        val lastName = this["lastName"] as? String
        val phone = this["phoneNumber"] as? String
        val email = this["email"] as? String
        val shippingMethod = this["shippingMethod"] as? String
        val address = (this["address"] as? Map<String, Any?>)?.toAddress()

        return if (firstName == null && lastName == null && phone == null && email == null && shippingMethod == null && address == null) {
            null
        } else {
            Shipping.Builder().apply {
                setFirstName(firstName)
                setLastName(lastName)
                setPhone(phone)
                setEmail(email)
                setShippingMethod(shippingMethod)
                setAddress(address)
            }.build()
        }
    }

    private fun Map<String, Any?>.toAddress(): Address? {
        val countryCode = this["countryCode"] as? String
        val state = this["state"] as? String
        val city = this["city"] as? String
        val street = this["street"] as? String
        val postcode = this["postcode"] as? String

        return if (countryCode == null && state == null && city == null && street == null && postcode == null) {
            null
        } else {
            Address.Builder().apply {
                setCountryCode(countryCode)
                setState(state)
                setCity(city)
                setStreet(street)
                setPostcode(postcode)
            }.build()
        }
    }
}