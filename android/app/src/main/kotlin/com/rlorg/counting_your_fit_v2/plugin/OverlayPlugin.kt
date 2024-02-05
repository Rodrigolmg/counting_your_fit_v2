package com.rlorg.counting_your_fit_v2.plugin

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
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
    private val channelTag = "rl/overlay_channel"
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