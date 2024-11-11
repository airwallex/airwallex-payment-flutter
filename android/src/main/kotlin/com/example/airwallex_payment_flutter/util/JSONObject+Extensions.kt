package com.example.airwallex_payment_flutter.util

import com.airwallex.android.core.BillingAddressParameters
import com.airwallex.android.core.model.Address
import com.airwallex.android.core.model.PaymentConsent
import com.airwallex.android.core.model.Shipping
import org.json.JSONObject


fun JSONObject.getStringOrThrow(key: String): String {
    return getNullableString(key) ?: throw IllegalArgumentException("$key is required")
}

fun JSONObject.getNullableString(key: String): String? {
    return if (has(key) && !isNull(key)) getString(key) else null
}

fun JSONObject.getNullableBoolean(key: String): Boolean? {
    return if (has(key) && !isNull(key)) getBoolean(key) else null
}

fun JSONObject.toNextTriggeredBy(): PaymentConsent.NextTriggeredBy? {
    val nextTriggeredBy = getNullableString("nextTriggeredBy")
    return when (nextTriggeredBy?.lowercase()) {
        "merchant" -> PaymentConsent.NextTriggeredBy.MERCHANT
        "customer" -> PaymentConsent.NextTriggeredBy.CUSTOMER
        else -> null
    }
}

fun JSONObject.toMerchantTriggerReason(): PaymentConsent.MerchantTriggerReason? {
    val merchantTriggerReason = getNullableString("merchantTriggerReason")
    return when (merchantTriggerReason?.lowercase()) {
        "scheduled" -> PaymentConsent.MerchantTriggerReason.SCHEDULED
        "unscheduled" -> PaymentConsent.MerchantTriggerReason.UNSCHEDULED
        else -> null
    }
}

fun JSONObject.toShipping(): Shipping? {
    val firstName = this.getNullableString("firstName")
    val lastName = this.getNullableString("lastName")
    val phoneNumber = this.getNullableString("phoneNumber")
    val email = this.getNullableString("email")
    val shippingMethod = this.getNullableString("shippingMethod")
    val address = this.optJSONObject("address")?.toAddress()

    return if (firstName.isNullOrEmpty() && lastName.isNullOrEmpty() &&
        phoneNumber.isNullOrEmpty() && email.isNullOrEmpty() &&
        shippingMethod.isNullOrEmpty() && address == null
    ) {
        null
    } else {
        Shipping.Builder().apply {
            setFirstName(firstName)
            setLastName(lastName)
            setPhone(phoneNumber)
            setEmail(email)
            setShippingMethod(shippingMethod)
            setAddress(address)
        }.build()
    }
}

fun JSONObject.toAddress(): Address? {
    val countryCode = this.getNullableString("countryCode")
    val state = this.getNullableString("state")
    val city = this.getNullableString("city")
    val street = this.getNullableString("street")
    val postcode = this.getNullableString("postcode")

    return if (countryCode.isNullOrEmpty() && state.isNullOrEmpty() &&
        city.isNullOrEmpty() && street.isNullOrEmpty() && postcode.isNullOrEmpty()
    ) {
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

fun JSONObject.toBillingAddressParameters(): BillingAddressParameters {
    val formatStr = this.getNullableString("format")
    val format = when (formatStr?.lowercase()) {
        "min" -> BillingAddressParameters.Format.MIN
        "full" -> BillingAddressParameters.Format.FULL
        else -> error("Unknown format: $formatStr")
    }
    return BillingAddressParameters(
        format = format,
        phoneNumberRequired = this.optBoolean("phoneNumberRequired")
    )
}