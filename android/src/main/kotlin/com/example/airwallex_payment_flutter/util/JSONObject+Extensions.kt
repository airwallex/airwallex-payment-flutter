package com.example.airwallex_payment_flutter.util

import org.json.JSONObject


fun JSONObject.getNullableStringOrThrow(key: String): String {
    return optNullableString(key) ?: throw IllegalArgumentException("$key is required")
}

fun JSONObject.optNullableString(key: String): String? {
    return if (has(key) && !isNull(key)) getString(key) else null
}

fun JSONObject.optNullableBoolean(key: String): Boolean? {
    return if (has(key) && !isNull(key)) getBoolean(key) else null
}