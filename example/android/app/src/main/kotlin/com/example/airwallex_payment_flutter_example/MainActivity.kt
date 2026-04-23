package com.example.airwallex_payment_flutter_example

import android.content.res.Configuration
import android.os.Build
import android.os.LocaleList
import androidx.appcompat.app.AppCompatDelegate
import androidx.core.os.LocaleListCompat
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "example_host_locale"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "setLanguage" -> {
                    val normalizedLanguageTag = normalizeLanguageTag(
                        call.argument<String>("languageTag")
                    )
                    applyHostLocale(normalizedLanguageTag)
                    result.success(normalizedLanguageTag)
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun applyHostLocale(languageTag: String) {
        val locale = Locale.forLanguageTag(languageTag)
        Locale.setDefault(locale)
        AppCompatDelegate.setApplicationLocales(
            LocaleListCompat.forLanguageTags(languageTag)
        )
        updateResources(resources, locale)
        updateResources(applicationContext.resources, locale)
    }

    private fun updateResources(
        targetResources: android.content.res.Resources,
        locale: Locale
    ) {
        val configuration = Configuration(targetResources.configuration).apply {
            setLocale(locale)
            setLayoutDirection(locale)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                setLocales(LocaleList(locale))
            }
        }

        @Suppress("DEPRECATION")
        targetResources.updateConfiguration(configuration, targetResources.displayMetrics)
    }

    private fun normalizeLanguageTag(languageTag: String?): String {
        val trimmedLanguageTag = languageTag?.trim().orEmpty()
        if (trimmedLanguageTag.isEmpty()) {
            return DEFAULT_LANGUAGE_TAG
        }

        val parsedLocale = Locale.forLanguageTag(trimmedLanguageTag.replace('_', '-'))
        if (parsedLocale.language.isBlank()) {
            return DEFAULT_LANGUAGE_TAG
        }

        return when {
            parsedLocale.language.equals("zh", ignoreCase = true) -> {
                val script = parsedLocale.script.lowercase()
                val country = parsedLocale.country.uppercase()
                when {
                    trimmedLanguageTag.equals("zh_Hant", ignoreCase = true) -> "zh-Hant"
                    script == "hant" -> "zh-Hant"
                    country == "TW" || country == "HK" || country == "MO" -> "zh-Hant"
                    else -> "zh-Hans"
                }
            }

            parsedLocale.language.equals("en", ignoreCase = true) -> DEFAULT_LANGUAGE_TAG
            else -> parsedLocale.toLanguageTag()
        }
    }

    companion object {
        private const val DEFAULT_LANGUAGE_TAG = "en"
    }
}
