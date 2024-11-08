package com.example.airwallex_payment_flutter.util

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