package com.rlorg.counting_your_fit_v2.plugin

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.Settings
import com.rlorg.counting_your_fit_v2.ChannelTag
import com.rlorg.counting_your_fit_v2.service.FlutterOverlayService
import com.rlorg.counting_your_fit_v2.service.FlutterWindowSetup
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngineGroup
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry

class OverlayPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    private val channelTag = ChannelTag.mainChannel
    private val cachedTag = "cachedEngine"
    private val REQUEST_CODE_FOR_OVERLAY_PERMISSION = 1248
    private var act: Activity? = null
    private lateinit var channel: MethodChannel
    private lateinit var pendingResult: Result
    private lateinit var context: Context

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        this.context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, channelTag)
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        pendingResult = result

        when(call.method){
            "requestPermission" -> {
                val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION)
                intent.data = Uri.parse("package:" + act?.packageName)
                act?.startActivityForResult(intent, REQUEST_CODE_FOR_OVERLAY_PERMISSION)
            }
            "checkPermission" -> {
                result.success(checkOverlayPermission())
            }
            "showOverlay" -> {
                if (!checkOverlayPermission()) {
                    result.error("PERMISSION", "overlay permission is not enabled", null)
                    return
                }
                val notificationVisibility = call.argument<String?>("notificationVisibility")

                FlutterWindowSetup.height = call.argument("height") ?: -1
                FlutterWindowSetup.width = call.argument("width") ?: -1
                FlutterWindowSetup.enableDrag = call.argument<Boolean>("enableDrag")!!
                FlutterWindowSetup.setGravityFromAlignment(call.argument<String?>("alignment") ?: "center")
                FlutterWindowSetup.setFlag(call.argument<String?>("flag") ?: "flagNotFocusable")
                FlutterWindowSetup.overlayTitle = call.argument<String>("overlayTitle")!!
                FlutterWindowSetup.overlayContent = call.argument<String>("overlayContent") ?: ""
                FlutterWindowSetup.positionGravity = call.argument<String>("positionGravity")!!
                FlutterWindowSetup.setNotificationVisibility(call.argument<String?>("notificationVisibility")!!)

                val intent = Intent(context, Class.forName(FlutterOverlayService::class.simpleName!!))
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
                context.startService(intent)
                result.success(null)
            }
            "isOverlayActive" -> {
                result.success(FlutterOverlayService.isRunning)
            }
            "closeOverlay" -> {
                if(FlutterOverlayService.isRunning){
                    val i = Intent(context, Class.forName(FlutterOverlayService::class.simpleName!!))
                    i.putExtra(FlutterOverlayService.intentExtraIsCloseWindow, true)
                    context.startService(i)
                    result.success(true)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        configActivity(binding)
        val enn = FlutterEngineGroup(context)
        val dEntry = DartExecutor.DartEntrypoint(
            FlutterInjector.instance().flutterLoader().findAppBundlePath(),
            "main"
        )
        val engine = enn.createAndRunEngine(context, dEntry)
        FlutterEngineCache.getInstance().put(cachedTag, engine)
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        clearActivityReference()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        configActivity(binding)
    }

    override fun onDetachedFromActivity() {
        clearActivityReference()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if(requestCode == REQUEST_CODE_FOR_OVERLAY_PERMISSION){
            pendingResult.success(checkOverlayPermission())
            return true
        }
        return false
    }

    // PRIVATE FUN
    private fun configActivity(binding: ActivityPluginBinding){
        act = binding.activity
        binding.addActivityResultListener(this)
    }

    private fun clearActivityReference(){
        act = null
    }

    private fun checkOverlayPermission(): Boolean {
        return Settings.canDrawOverlays(context)
    }
}