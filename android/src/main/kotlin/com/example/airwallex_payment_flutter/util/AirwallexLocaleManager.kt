package com.example.airwallex_payment_flutter.util

import android.app.Activity
import android.app.Application
import android.content.Context
import android.content.res.Configuration
import android.os.Build
import android.os.LocaleList
import androidx.appcompat.app.AppCompatDelegate
import androidx.core.os.LocaleListCompat
import java.util.Locale

internal class AirwallexLocaleManager(
    private val application: Application
) {
    fun applyLocale(activity: Activity? = null) {
        val languageTag = currentLanguageTag(activity)
        val locale = localeFromLanguageTag(languageTag)

        Locale.setDefault(locale)
        AppCompatDelegate.setApplicationLocales(
            LocaleListCompat.forLanguageTags(languageTag)
        )

        updateResources(application, locale)
        activity?.let { updateResources(it, locale) }
    }

    fun currentLanguageTag(activity: Activity? = null): String {
        val context = activity ?: application
        return normalizeLanguageTag(resolveLocale(context).toLanguageTag())
    }

    private fun resolveLocale(context: Context): Locale {
        val configuration = context.resources.configuration
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            val locale = configuration.locales[0]
            if (locale != null) {
                return locale
            }
        }

        @Suppress("DEPRECATION")
        return configuration.locale ?: Locale.getDefault()
    }

    private fun updateResources(context: Context, locale: Locale) {
        val resources = context.resources
        val configuration = Configuration(resources.configuration).apply {
            setLocale(locale)
            setLayoutDirection(locale)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                setLocales(LocaleList(locale))
            }
        }

        @Suppress("DEPRECATION")
        resources.updateConfiguration(configuration, resources.displayMetrics)
    }

    companion object {
        internal const val DEFAULT_LANGUAGE_TAG = "en"

        internal fun normalizeLanguageTag(languageTag: String?): String {
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

        internal fun localeFromLanguageTag(languageTag: String?): Locale {
            return Locale.forLanguageTag(normalizeLanguageTag(languageTag))
        }
    }
}
