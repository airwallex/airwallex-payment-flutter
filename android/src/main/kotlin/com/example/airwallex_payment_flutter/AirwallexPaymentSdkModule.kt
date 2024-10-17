package com.example.airwallex_payment_flutter

import androidx.activity.ComponentActivity
import com.airwallex.android.AirwallexStarter
import com.airwallex.android.core.Airwallex
import com.airwallex.android.core.AirwallexPaymentSession
import com.airwallex.android.core.AirwallexPaymentStatus
import com.airwallex.android.core.AirwallexSession
import com.airwallex.android.core.log.AirwallexLogger
import com.example.airwallex_payment_flutter.util.AirwallexPaymentSessionConverter
import com.example.airwallex_payment_flutter.util.AirwallexRecurringSessionConverter
import com.example.airwallex_payment_flutter.util.AirwallexRecurringWithIntentSessionConverter
import com.example.airwallex_payment_flutter.util.CardConverter
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AirwallexPaymentSdkModule {
    private lateinit var airwallex: Airwallex

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

    fun startPayWithCardDetails(
        activity: ComponentActivity,
        call: MethodCall,
        result: MethodChannel.Result
    ) = runWithAirwallex(activity) {
        val session = parseSessionFromCall(call)
        val card = CardConverter.fromMethodCall(call)
        airwallex.confirmPaymentIntent(
            session = session,
            card = card,
            billing = null,
            saveCard = false,
            listener = object : Airwallex.PaymentResultListener {
                override fun onCompleted(status: AirwallexPaymentStatus) {
                    AirwallexLogger.info("AirwallexPaymentSdkModule: startPayWithCardDetails, status = $status")
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

    private fun parseSessionFromCall(call: MethodCall): AirwallexSession {
        val argumentsMap = call.arguments<Map<String, Any?>>()
            ?: throw IllegalArgumentException("Arguments data is required")
        val clientSecret = argumentsMap["clientSecret"] as? String
            ?: throw IllegalArgumentException("clientSecret is required")
        val type = argumentsMap["type"] as? String
            ?: throw IllegalArgumentException("type is required")

        return when (type) {
            "OneOff" -> {
                AirwallexPaymentSessionConverter.fromMap(argumentsMap, clientSecret)
            }

            "Recurring" -> {
                AirwallexRecurringSessionConverter.fromMapToRecurringSession(
                    argumentsMap,
                    clientSecret
                )
            }

            "RecurringWithIntent" -> {
                AirwallexRecurringWithIntentSessionConverter.fromMapToRecurringWithIntentSession(
                    argumentsMap,
                    clientSecret
                )
            }

            else -> {
                throw IllegalArgumentException("Unsupported session type: $type")
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
}
