package com.example.airwallex_payment_flutter

import com.example.airwallex_payment_flutter.util.AirwallexLocaleManager
import kotlin.test.Test
import kotlin.test.assertEquals

internal class AirwallexPaymentFlutterPluginTest {
    @Test
    fun normalizeLanguageTag_defaultsToEnglishWhenMissing() {
        assertEquals("en", AirwallexLocaleManager.normalizeLanguageTag(null))
        assertEquals("en", AirwallexLocaleManager.normalizeLanguageTag(""))
    }

    @Test
    fun normalizeLanguageTag_normalizesChineseLanguageCodes() {
        assertEquals("zh-Hans", AirwallexLocaleManager.normalizeLanguageTag("zh_CN"))
        assertEquals("zh-Hant", AirwallexLocaleManager.normalizeLanguageTag("zh_Hant"))
    }

    @Test
    fun localeFromLanguageTag_preservesScriptSpecificChineseLocales() {
        val simplified = AirwallexLocaleManager.localeFromLanguageTag("zh-Hans")
        val traditional = AirwallexLocaleManager.localeFromLanguageTag("zh-Hant")

        assertEquals("zh", simplified.language)
        assertEquals("Hans", simplified.script)
        assertEquals("zh", traditional.language)
        assertEquals("Hant", traditional.script)
    }
}
