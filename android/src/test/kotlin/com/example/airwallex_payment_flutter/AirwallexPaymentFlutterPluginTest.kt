package com.example.airwallex_payment_flutter

import com.example.airwallex_payment_flutter.util.AirwallexLocaleManager
import java.util.Locale
import kotlin.test.Test
import kotlin.test.assertEquals

internal class AirwallexPaymentFlutterPluginTest {
    @Test
    fun normalizeLanguageTag_mapsChineseVariants() {
        assertEquals("zh-Hans", AirwallexLocaleManager.normalizeLanguageTag("zh"))
        assertEquals("zh-Hans", AirwallexLocaleManager.normalizeLanguageTag("zh-CN"))
        assertEquals("zh-Hant", AirwallexLocaleManager.normalizeLanguageTag("zh_Hant"))
        assertEquals("zh-Hant", AirwallexLocaleManager.normalizeLanguageTag("zh-TW"))
    }

    @Test
    fun normalizeLanguageTag_fallsBackToEnglishForBlankValues() {
        assertEquals("en", AirwallexLocaleManager.normalizeLanguageTag(null))
        assertEquals("en", AirwallexLocaleManager.normalizeLanguageTag(" "))
        assertEquals("en", AirwallexLocaleManager.normalizeLanguageTag("en-US"))
    }

    @Test
    fun localeFromLanguageTag_preservesScriptSpecificChineseLocales() {
        val simplified = AirwallexLocaleManager.localeFromLanguageTag("zh-Hans")
        val traditional = AirwallexLocaleManager.localeFromLanguageTag("zh-Hant")

        assertEquals("zh", simplified.language)
        assertEquals("Hans", simplified.script)
        assertEquals(Locale.forLanguageTag("zh-Hant"), traditional)
    }
}
