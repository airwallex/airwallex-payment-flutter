package com.example.airwallex_payment_flutter.util

import com.airwallex.android.core.PaymentMethodsLayoutType
import com.airwallex.android.view.composables.PaymentElementConfiguration
import org.json.JSONObject

object PaymentSheetConfigurationParser {
    fun parse(json: JSONObject?): PaymentElementConfiguration.PaymentSheet {
        val layout = when (json?.optString("layout")?.lowercase()) {
            "accordion" -> PaymentMethodsLayoutType.ACCORDION
            else -> PaymentMethodsLayoutType.TAB
        }
        return PaymentElementConfiguration.PaymentSheet(layout = layout)
    }
}
