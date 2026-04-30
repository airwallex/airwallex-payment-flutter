package com.example.airwallex_payment_flutter.util

import com.airwallex.android.core.AirwallexSupportedCard
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertNull
import org.json.JSONArray

internal class AirwallexSupportedBrandsParserTest {

    @Test
    fun parse_returnsNull_whenInputIsNull() {
        assertNull(AirwallexSupportedBrandsParser.parse(null))
    }

    @Test
    fun parse_returnsEmptyList_whenInputIsEmpty() {
        val result = AirwallexSupportedBrandsParser.parse(JSONArray())
        assertEquals(emptyList(), result)
    }

    @Test
    fun parse_returnsMappedBrands_inOrder() {
        val input = JSONArray(listOf("visa", "mastercard"))
        val result = AirwallexSupportedBrandsParser.parse(input)
        assertEquals(
            listOf(AirwallexSupportedCard.VISA, AirwallexSupportedCard.MASTERCARD),
            result
        )
    }

    @Test
    fun parse_handlesAllKnownBrands() {
        val input = JSONArray(listOf("visa", "amex", "mastercard", "discover", "jcb", "diners", "unionpay"))
        val result = AirwallexSupportedBrandsParser.parse(input)
        assertEquals(
            listOf(
                AirwallexSupportedCard.VISA,
                AirwallexSupportedCard.AMEX,
                AirwallexSupportedCard.MASTERCARD,
                AirwallexSupportedCard.DISCOVER,
                AirwallexSupportedCard.JCB,
                AirwallexSupportedCard.DINERS_CLUB,
                AirwallexSupportedCard.UNION_PAY,
            ),
            result
        )
    }

    @Test
    fun parse_skipsUnknownBrands() {
        val input = JSONArray(listOf("visa", "bogus", "mastercard"))
        val result = AirwallexSupportedBrandsParser.parse(input)
        assertEquals(
            listOf(AirwallexSupportedCard.VISA, AirwallexSupportedCard.MASTERCARD),
            result
        )
    }
}
