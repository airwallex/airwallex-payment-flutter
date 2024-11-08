package com.example.airwallex_payment_flutter.util

import com.airwallex.android.core.BillingAddressParameters
import com.airwallex.android.core.model.Address
import com.airwallex.android.core.model.Billing
import com.airwallex.android.core.model.PaymentConsent
import com.airwallex.android.core.model.PaymentMethod
import com.airwallex.android.core.model.Shipping
import org.json.JSONObject


fun JSONObject.getStringOrThrow(key: String): String {
    return getNullableString(key) ?: throw IllegalArgumentException("$key is required")
}

fun JSONObject.getNullableString(key: String): String? {
    return if (has(key) && !isNull(key)) getString(key) else null
}

fun JSONObject.getNullableMap(key: String): Map<String, Any?>? {
    return if (has(key) && !isNull(key)) optJSONObject(key)?.toMap() else null
}

fun JSONObject.getNullableBoolean(key: String): Boolean? {
    return if (has(key) && !isNull(key)) getBoolean(key) else null
}

fun JSONObject.toMap(): Map<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    val keys = keys()
    while (keys.hasNext()) {
        val key = keys.next()
        val value = this.get(key)
        map[key] = when (value) {
            is JSONObject -> value.toMap()
            else -> value
        }
    }
    return map
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

fun JSONObject.toPaymentConsentStatus(): PaymentConsent.PaymentConsentStatus? {
    val statusString = getNullableString("status")
    return when (statusString?.lowercase()) {
        "pending_verification" -> PaymentConsent.PaymentConsentStatus.PENDING_VERIFICATION
        "verified" -> PaymentConsent.PaymentConsentStatus.VERIFIED
        "disabled" -> PaymentConsent.PaymentConsentStatus.DISABLED
        else -> null
    }
}

fun JSONObject.toNumberType(): PaymentMethod.Card.NumberType? {
    val numberTypeString = getNullableString("numberType")
    return when (numberTypeString?.lowercase()) {
        "pan" -> PaymentMethod.Card.NumberType.PAN
        "external_network_token" -> PaymentMethod.Card.NumberType.EXTERNAL_NETWORK_TOKEN
        "airwallex_network_token" -> PaymentMethod.Card.NumberType.AIRWALLEX_NETWORK_TOKEN
        else -> null
    }
}

fun JSONObject.toBilling(): Billing? {
    val firstName = getNullableString("firstName")
    val lastName = getNullableString("lastName")
    val phone = getNullableString("phoneNumber")
    val email = getNullableString("email")
    val dateOfBirth = getNullableString("dateOfBirth")
    val address = optJSONObject("address")?.toAddress()

    return if (firstName == null && lastName == null && phone == null && email == null && dateOfBirth == null && address == null) {
        null
    } else {
        Billing.Builder().apply {
            setFirstName(firstName)
            setLastName(lastName)
            setPhone(phone)
            setEmail(email)
            setDateOfBirth(dateOfBirth)
            setAddress(address)
        }.build()
    }
}