package com.pollfish.magicreceipts.flutter

import android.app.Activity
import android.os.Build
import androidx.annotation.NonNull
import com.pollfish.magicreceipts.MagicReceipts
import com.pollfish.magicreceipts.builder.Params
import com.pollfish.magicreceipts.listener.*

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** MagicReceiptsPlugin */
class MagicReceiptsPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private var binding: FlutterPluginBinding? = null
    private var activity: Activity? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "magic_receipts")
        channel.setMethodCallHandler(this)
        this.binding = flutterPluginBinding;
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "initialize" -> initMagicReceipts(call, result)
            "show" -> result.success(show())
            "hide" -> result.success(hide())
            "isReady" -> result.success(isReady())
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        this.binding = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    private fun initMagicReceipts(call: MethodCall, result: Result) {
        if (Build.VERSION.SDK_INT < 21) {
            result.error(
                "unsupported_os_version",
                "Magic Receipts SDK is available on SDK 21 or higher.",
                null
            )
            return
        }

        if (activity == null) {
            result.error(
                "activity_not_found",
                "Tried to initialize Magic Receipts SDK with a null activity.",
                null
            )
            return
        }

        call.argument<String>("androidApiKey")?.let { apiKey ->
            val builder = Params.Builder(apiKey)

            call.argument<String>("clickId")?.let {
                builder.clickId(it)
            }

            call.argument<String>("userId")?.let {
                builder.userId(it)
            }

            call.argument<Boolean>("incentiveMode")?.let {
                builder.incentiveMode(it)
            }

            builder.wallLoadedListener(object : MagicReceiptsWallLoadedListener {
                override fun onWallDidLoad() {
                    channel.invokeMethod("magicReceiptsWallLoaded", null)
                }
            })

            builder.wallLoadFailedListener(object : MagicReceiptsWallLoadFailedListener {
                override fun onWallDidFailToLoad(error: MagicReceiptsLoadError) {
                    channel.invokeMethod("magicReceiptsWallLoadFailed", error.toString())
                }
            })

            builder.wallShowedListener(object : MagicReceiptsWallShowedListener {
                override fun onWallDidShow() {
                    channel.invokeMethod("magicReceiptsWallShowed", null)
                }
            })

            builder.wallShowFailedListener(object : MagicReceiptsWallShowFailedListener {
                override fun onWallDidFailToShow(error: MagicReceiptsShowError) {
                    channel.invokeMethod("magicReceiptsWallShowFailed", error.toString())
                }
            })

            builder.wallHiddenListener(object : MagicReceiptsWallHiddenListener {
                override fun onWallDidHide() {
                    channel.invokeMethod("magicReceiptsWallHidden", null)
                }
            })

            binding?.let {
                MagicReceipts.initialize(activity!!, builder.build())
            } ?: run {
                result.error("binding_not_found", "Flutter plugin binding was null", null)
            }

        } ?: run { result.error("no_api_key", "A null android api key was provided.", null) }
    }

    private fun show() {
        MagicReceipts.show()
    }

    private fun hide() {
        MagicReceipts.hide()
    }

    private fun isReady() = MagicReceipts.isReady()
}
