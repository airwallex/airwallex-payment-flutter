package com.example.airwallex_payment_flutter

import androidx.activity.ComponentActivity
import com.airwallex.android.AirwallexStarter
import com.airwallex.android.core.Airwallex
import com.airwallex.android.core.AirwallexPaymentStatus
import com.airwallex.android.core.AirwallexSession
import com.airwallex.android.core.log.AirwallexLogger
import com.airwallex.android.view.AirwallexAddPaymentDialog
import com.example.airwallex_payment_flutter.util.AirwallexPaymentSessionConverter
import com.example.airwallex_payment_flutter.util.AirwallexRecurringSessionConverter
import com.example.airwallex_payment_flutter.util.AirwallexRecurringWithIntentSessionConverter
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AirwallexPaymentSdkModule {

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

    fun presentCardPaymentDialog(
        activity: ComponentActivity,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        val session = parseSessionFromCall(call)
        val dialog = AirwallexAddPaymentDialog(
            activity = activity,
            session = session,
            paymentResultListener = object : Airwallex.PaymentResultListener {
                override fun onCompleted(status: AirwallexPaymentStatus) {
                    AirwallexLogger.info("AirwallexPaymentSdkModule: presentCardPaymentDialog, status = $status")
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
        dialog.show()
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
