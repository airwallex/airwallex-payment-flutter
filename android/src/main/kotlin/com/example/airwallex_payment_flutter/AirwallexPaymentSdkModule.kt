package com.example.airwallex_payment_flutter

import android.app.Application
import androidx.activity.ComponentActivity
import com.airwallex.android.AirwallexStarter
import com.airwallex.android.card.CardComponent
import com.airwallex.android.core.Airwallex
import com.airwallex.android.core.AirwallexConfiguration
import com.airwallex.android.core.AirwallexPaymentSession
import com.airwallex.android.core.AirwallexPaymentStatus
import com.airwallex.android.core.AirwallexSession
import com.airwallex.android.core.Environment
import com.airwallex.android.core.log.AirwallexLogger
import com.airwallex.android.core.model.PaymentConsent
import com.airwallex.android.core.model.PaymentMethod
import com.airwallex.android.googlepay.GooglePayComponent
import com.airwallex.android.redirect.RedirectComponent
import com.airwallex.android.wechat.WeChatComponent
import com.example.airwallex_payment_flutter.util.AirwallexPaymentSessionParser
import com.example.airwallex_payment_flutter.util.AirwallexRecurringSessionParser
import com.example.airwallex_payment_flutter.util.AirwallexRecurringWithIntentSessionParser
import com.example.airwallex_payment_flutter.util.AirwallexCardParser
import com.example.airwallex_payment_flutter.util.AirwallexPaymentConsentParser
import com.example.airwallex_payment_flutter.util.getNullableString
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class AirwallexPaymentSdkModule {
    private lateinit var airwallex: Airwallex

    fun initialize(application: Application, call: MethodCall, result: MethodChannel.Result) {
        val arguments = call.arguments<JSONObject>() ?: error("Arguments data is required")
        val environment = getEnvironment(arguments.optString("environment"))
        val enableLogging = arguments.optBoolean("enableLogging", true)
        val saveLogToLocal = arguments.optBoolean("saveLogToLocal", false)
        AirwallexLogger.info("AirwallexPaymentSdkModule: initialize, environment = $environment, enableLogging = $enableLogging, saveLogToLocal = $saveLogToLocal")
        AirwallexStarter.initialize(
            application,
            AirwallexConfiguration.Builder()
                .enableLogging(enableLogging)
                .saveLogToLocal(saveLogToLocal)
                .setEnvironment(environment)
                .setSupportComponentProviders(
                    listOf(
                        CardComponent.PROVIDER,
                        WeChatComponent.PROVIDER,
                        RedirectComponent.PROVIDER,
                        GooglePayComponent.PROVIDER
                    )
                )
                .build()
        )
        result.success(null)
    }

    fun presentEntirePaymentFlow(
        activity: ComponentActivity,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        val session = parseSessionFromCall(call)
        AirwallexStarter.presentEntirePaymentFlow(
            activity = activity,
            session = session,
            paymentResultListener = object : Airwallex.PaymentResultListener {
                override fun onCompleted(status: AirwallexPaymentStatus) {
                    AirwallexLogger.info("AirwallexPaymentSdkModule: presentEntirePaymentFlow, status = $status")
                    when (status) {
                        is AirwallexPaymentStatus.Failure -> {
                            result.error("payment_failure", status.exception.localizedMessage, null)
                        }

                        else -> {
                            val resultData = mapAirwallexPaymentStatusToResult(status)
                            result.success(resultData)
                        }
                    }
                }
            }
        )
    }

    fun presentCardPaymentFlow(
        activity: ComponentActivity,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        val session = parseSessionFromCall(call)
        AirwallexStarter.presentCardPaymentFlow(
            activity = activity,
            session = session,
            paymentResultListener = object : Airwallex.PaymentResultListener {
                override fun onCompleted(status: AirwallexPaymentStatus) {
                    AirwallexLogger.info("AirwallexPaymentSdkModule: presentCardPaymentFlow, status = $status")
                    when (status) {
                        is AirwallexPaymentStatus.Failure -> {
                            result.error("payment_failure", status.exception.localizedMessage, null)
                        }

                        else -> {
                            val resultData = mapAirwallexPaymentStatusToResult(status)
                            result.success(resultData)
                        }
                    }
                }
            }
        )
    }

    fun payWithCardDetails(
        activity: ComponentActivity,
        call: MethodCall,
        result: MethodChannel.Result
    ) = runWithAirwallex(activity) {
        val session = parseSessionFromCall(call)
        val card = parseCardFromCall(call)
        val saveCard = call.arguments<JSONObject>()?.optBoolean("saveCard")
            ?: error("saveCard is required")

        airwallex.confirmPaymentIntent(
            session = session,
            card = card,
            billing = null,
            saveCard = saveCard,
            listener = object : Airwallex.PaymentResultListener {
                override fun onCompleted(status: AirwallexPaymentStatus) {
                    AirwallexLogger.info("AirwallexPaymentSdkModule: payWithCardDetails, status = $status")
                    when (status) {
                        is AirwallexPaymentStatus.Failure -> {
                            result.error("payment_failure", status.exception.localizedMessage, null)
                        }

                        else -> {
                            val resultData = mapAirwallexPaymentStatusToResult(status)
                            result.success(resultData)
                        }
                    }
                }
            }
        )
    }

    fun payWithConsent(
        activity: ComponentActivity,
        call: MethodCall,
        result: MethodChannel.Result
    ) = runWithAirwallex(activity) {
        val session = parseSessionFromCall(call)
        val paymentConsent = parsePaymentConsentFromCall(call)
        airwallex.confirmPaymentIntent(
            session = session as AirwallexPaymentSession,
            paymentConsent = paymentConsent,
            listener = object : Airwallex.PaymentResultListener {
                override fun onCompleted(status: AirwallexPaymentStatus) {
                    AirwallexLogger.info("AirwallexPaymentSdkModule: payWithConsent, status = $status")
                    when (status) {
                        is AirwallexPaymentStatus.Failure -> {
                            result.error("payment_failure", status.exception.localizedMessage, null)
                        }

                        else -> {
                            val resultData = mapAirwallexPaymentStatusToResult(status)
                            result.success(resultData)
                        }
                    }
                }
            }
        )
    }

    fun startGooglePay(
        activity: ComponentActivity,
        call: MethodCall,
        result: MethodChannel.Result
    ) = runWithAirwallex(activity) {
        val session = parseSessionFromCall(call)
        airwallex.startGooglePay(
            session = session as AirwallexPaymentSession,
            listener = object : Airwallex.PaymentResultListener {
                override fun onCompleted(status: AirwallexPaymentStatus) {
                    AirwallexLogger.info("AirwallexPaymentSdkModule: startGooglePay, status = $status")
                    when (status) {
                        is AirwallexPaymentStatus.Failure -> {
                            result.error("payment_failure", status.exception.localizedMessage, null)
                        }

                        else -> {
                            val resultData = mapAirwallexPaymentStatusToResult(status)
                            result.success(resultData)
                        }
                    }
                }
            }
        )
    }

    private fun runWithAirwallex(activity: ComponentActivity, block: () -> Unit) {
        if (!::airwallex.isInitialized) {
            airwallex = Airwallex(activity)
        }
        block()
    }

    private fun parsePaymentConsentFromCall(call: MethodCall): PaymentConsent {
        val argumentsObject = call.arguments<JSONObject>()
        val consentObject =
            argumentsObject?.optJSONObject("consent") ?: error("consent is required")
        return AirwallexPaymentConsentParser.parse(consentObject)
    }

    private fun parseCardFromCall(call: MethodCall): PaymentMethod.Card {
        val argumentsObject = call.arguments<JSONObject>()
        val cardJson = argumentsObject?.optJSONObject("card")
            ?: throw IllegalArgumentException("card is required")
        return AirwallexCardParser.parse(cardJson)
    }

    private fun parseSessionFromCall(call: MethodCall): AirwallexSession {
        val argumentsObject = call.arguments<JSONObject>()

        val sessionObject =
            argumentsObject?.optJSONObject("session") ?: error("session is required")

        val clientSecret =
            sessionObject.getNullableString("clientSecret") ?: error("clientSecret is required")

        val type = sessionObject.getNullableString("type") ?: error("type is required")

        return when (type) {
            "OneOff" -> {
                AirwallexPaymentSessionParser.parse(sessionObject, clientSecret)
            }

            "Recurring" -> {
                AirwallexRecurringSessionParser.parse(
                    sessionObject,
                    clientSecret
                )
            }

            "RecurringWithIntent" -> {
                AirwallexRecurringWithIntentSessionParser.parse(
                    sessionObject,
                    clientSecret
                )
            }

            else -> {
                error("Unsupported session type: $type")
            }
        }
    }

    private fun mapAirwallexPaymentStatusToResult(status: AirwallexPaymentStatus): Map<String, Any?> {
        return when (status) {
            is AirwallexPaymentStatus.Success -> {
                mapOf(
                    "status" to "success",
                    "paymentIntentId" to status.paymentIntentId,
                    "consentId" to status.consentId,
                    "additionalInfo" to status.additionalInfo
                )
            }

            is AirwallexPaymentStatus.InProgress -> {
                mapOf(
                    "status" to "inProgress",
                    "paymentIntentId" to status.paymentIntentId
                )
            }

            else -> {
                mapOf(
                    "status" to "cancelled"
                )
            }
        }
    }

    private fun getEnvironment(environment: String?): Environment {
        val defaultEnvironment = if (BuildConfig.DEBUG) Environment.DEMO else Environment.PRODUCTION
        return when (environment) {
            Environment.STAGING.value -> Environment.STAGING
            Environment.DEMO.value -> Environment.DEMO
            Environment.PRODUCTION.value -> Environment.PRODUCTION
            else -> defaultEnvironment
        }
    }
}
