package com.example.airwallex_payment_flutter.util

import com.airwallex.android.core.AirwallexSupportedCard
import org.json.JSONArray

object AirwallexSupportedBrandsParser {

    fun parse(brandsArray: JSONArray?): List<AirwallexSupportedCard>? {
        if (brandsArray == null) return null
        val values = (0 until brandsArray.length()).map { brandsArray.getString(it) }
        return values.mapNotNull { value ->
            AirwallexSupportedCard.entries.firstOrNull { it.brandName == value }
        }
    }
}
