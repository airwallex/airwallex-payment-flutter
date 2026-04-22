package com.example.airwallex_payment_flutter

import android.app.Application
import android.content.Context
import androidx.activity.ComponentActivity
import com.airwallex.android.core.log.AirwallexLogger
import com.example.airwallex_payment_flutter.util.AirwallexActivityManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/** AirwallexPaymentFlutterPlugin */
class AirwallexPaymentFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private lateinit var applicationContext: Context
    private var activity: ComponentActivity? = null
    private var sdkModule = AirwallexPaymentSdkModule()
    private var activityManager: AirwallexActivityManager? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = flutterPluginBinding.applicationContext
        activityManager = AirwallexActivityManager(applicationContext as Application)
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "airwallex_payment_flutter",
            JSONMethodCodec.INSTANCE
        )
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        AirwallexLogger.info("AirwallexPaymentFlutterPlugin: onMethodCall call.method= ${call.method}")
        when (call.method) {
            "initialize" -> sdkModule.initialize(applicationContext as Application, call, result)
            "setLocale" -> sdkModule.setLocale(
                application = applicationContext as Application,
                activity = resolveActivity(),
                call = call,
                result = result
            )
            "closeNativeScreen" -> {
                activityManager?.getCurrentActivity()?.finish()
                result.success(null)
            }
            else -> {
                val currentActivity = resolveActivity()
                if (currentActivity == null) {
                    result.error("Activity not attached", "Unable to perform operation", null)
                    return
                }
                when (call.method) {
                    "presentEntirePaymentFlow" -> sdkModule.presentEntirePaymentFlow(currentActivity, call, result)
                    "presentCardPaymentFlow" -> sdkModule.presentCardPaymentFlow(currentActivity, call, result)
                    "payWithCardDetails" -> sdkModule.payWithCardDetails(currentActivity, call, result)
                    "startGooglePay" -> sdkModule.startGooglePay(currentActivity, call, result)
                    "payWithConsent" -> sdkModule.payWithConsent(currentActivity, call, result)
                    else -> result.notImplemented()
                }
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity as ComponentActivity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    private fun resolveActivity(): ComponentActivity? {
        return activity ?: (activityManager?.getCurrentActivity() as? ComponentActivity)
    }

}
