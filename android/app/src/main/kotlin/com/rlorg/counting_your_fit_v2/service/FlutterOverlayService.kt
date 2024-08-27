package com.rlorg.counting_your_fit_v2.service

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.content.Context
import android.content.res.Resources
import android.content.res.Configuration
import android.graphics.Color
import android.graphics.PixelFormat
import android.graphics.Point
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.text.Layout
import android.util.DisplayMetrics
import android.util.TypedValue
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.view.WindowManager.LayoutParams
import androidx.core.app.NotificationCompat
import com.rlorg.counting_your_fit_v2.ChannelTag
import com.rlorg.counting_your_fit_v2.plugin.OverlayPlugin
import io.flutter.embedding.android.FlutterTextureView
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel
import java.util.Timer
import java.util.TimerTask
import kotlin.math.abs

class FlutterOverlayService: Service(), View.OnTouchListener {
    companion object {
        var isRunning: Boolean = false
        var intentExtraIsCloseWindow = "IsCloseWindow"
    }

    private var mStatusBarHeight = -1
    private var mNavigationBarHeight = -1
    private var DEFAULT_STATUS_BAR_HEIGHT_DP = 25
    private var MAXIMUM_OPACITY_ALLOWED_FOR_S_AND_HIGHER = .8f

    private var windowManager: WindowManager? = null
    private var flutterChannel: MethodChannel = MethodChannel(FlutterEngineCache.getInstance().get(ChannelTag.cachedTag)!!.dartExecutor,
        ChannelTag.overlayChannel)
    private var clickableFlag = LayoutParams.FLAG_NOT_TOUCHABLE
        .or(LayoutParams.FLAG_NOT_FOCUSABLE)
        .or(LayoutParams.FLAG_LAYOUT_NO_LIMITS)
        .or(LayoutParams.FLAG_LAYOUT_IN_SCREEN)
    private var szWindow = Point()

    private lateinit var resources: Resources
    private lateinit var flutterView: FlutterView

    private var animationHandler = Handler()
    private var lastX: Float = 1f
    private var lastY: Float = 1f
    private var lastYPosition = 1
    private var dragging = false
    private lateinit var mAnimationTimer: Timer
    private  lateinit var animationTimerTask: AnimationTimerTask

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        resources = applicationContext.resources
        val isCloseWindow = intent!!.getBooleanExtra(intentExtraIsCloseWindow, false)
        if(isCloseWindow) {
            if(windowManager != null){
                windowManager!!.removeView(flutterView)
                windowManager = null
                flutterView.detachFromFlutterEngine()
                stopSelf()
            }
            isRunning = false
            return START_STICKY
        }
        if(windowManager != null){
            windowManager!!.removeView(flutterView)
            windowManager = null
            flutterView.detachFromFlutterEngine()
            stopSelf()
        }
        isRunning = true
        val engine: FlutterEngine? = FlutterEngineCache.getInstance().get(ChannelTag.cachedTag)
        engine?.lifecycleChannel?.appIsResumed()
        flutterView = FlutterView(applicationContext, FlutterTextureView(applicationContext))
        flutterView.attachToFlutterEngine(engine!!)
        flutterView.fitsSystemWindows = true
        flutterView.focusable = FlutterView.FOCUSABLE
        flutterView.isFocusableInTouchMode = true
        flutterView.setBackgroundColor(Color.TRANSPARENT)
        flutterChannel.setMethodCallHandler { call, result ->
            if(call.method.equals("updateFlag")){
                val flag = call.argument<Any>("flag").toString()
                updateOverlayFlag(result, flag)
            } else if (call.method.equals("resizeOverlay")){
                val width = call.argument<Int>("width")
                val height = call.argument<Int>("height")
                resizeOverlay(width!!, height!!, result)
            }
        }
        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB){
            windowManager!!.defaultDisplay.getSize(szWindow)
        } else {
            val displayMetrics = DisplayMetrics()
            windowManager!!.defaultDisplay.getMetrics(displayMetrics)
            val w = displayMetrics.widthPixels
            val h = displayMetrics.heightPixels
            szWindow.set(w, h)
        }

        val params = LayoutParams(
            if(FlutterWindowSetup.width == -1999) -1 else FlutterWindowSetup.width,
            if(FlutterWindowSetup.height != -1999) FlutterWindowSetup.height else getScreenHeight(),
            0,
            -getStatusBarHeightPx(),
            LayoutParams.TYPE_APPLICATION_OVERLAY,
            FlutterWindowSetup.flag
                .or(LayoutParams.FLAG_LAYOUT_NO_LIMITS)
                .or(LayoutParams.FLAG_LAYOUT_IN_SCREEN)
                .or(LayoutParams.FLAG_LAYOUT_INSET_DECOR)
                .or(LayoutParams.FLAG_HARDWARE_ACCELERATED),
            PixelFormat.TRANSLUCENT
        )

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.S
            && FlutterWindowSetup.flag == clickableFlag){
            params.alpha = MAXIMUM_OPACITY_ALLOWED_FOR_S_AND_HIGHER
        }

        params.gravity = FlutterWindowSetup.gravity
        flutterView.setOnTouchListener(this)
        windowManager!!.addView(flutterView, params)
        return START_STICKY
    }

    private fun getScreenHeight(): Int {
        val display = windowManager!!.defaultDisplay
        val dm = DisplayMetrics()
        display.getRealMetrics(dm)
        return if(isInPortrait()){
            dm.heightPixels + getStatusBarHeightPx() + getNavigationBarHeightPx()
        } else {
            dm.heightPixels + getStatusBarHeightPx()
        }
    }

    private fun getNavigationBarHeightPx(): Int {
        if(mNavigationBarHeight == -1){
            val navBarHeightId = resources
                .getIdentifier("navigation", "dimen", " android")

            mNavigationBarHeight = if(navBarHeightId > 0)
                resources.getDimensionPixelSize(navBarHeightId)
            else
                dpToPx(DEFAULT_STATUS_BAR_HEIGHT_DP)
        }

        return mNavigationBarHeight
    }

    override fun onDestroy() {
        isRunning = false
        val notificationManager = applicationContext.getSystemService(Context.NOTIFICATION_SERVICE)
            as NotificationManager
        notificationManager.cancel(ChannelTag.notificationId)
    }

    override fun onCreate() {
        createNotificationChannel()
        val notificationIntent = Intent(this, Class.forName(OverlayPlugin::class.simpleName!!))
        val pendingFlags =
            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.S){
                PendingIntent.FLAG_IMMUTABLE
            } else {
                PendingIntent.FLAG_UPDATE_CURRENT
            }

        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            notificationIntent,
            pendingFlags
        )

        val notifyIcon = getDrawableResourceId("mipmap", "launcher")
        val notification = NotificationCompat.Builder(this, ChannelTag.channelId)
            .setContentTitle(FlutterWindowSetup.overlayTitle)
            .setContentText(FlutterWindowSetup.overlayContent)
            .setSmallIcon(notifyIcon)
            .setContentIntent(pendingIntent)
            .setVisibility(FlutterWindowSetup.notificationVisibility)
            .build()

        startForeground(ChannelTag.notificationId, notification)
    }

    private fun getDrawableResourceId(resType: String, name: String): Int {
        return applicationContext
            .resources
            .getIdentifier(
                String.format("ic_%s", name),
                resType,
                applicationContext.packageName
            )
    }

    private fun isInPortrait() : Boolean {
        return resources.configuration.orientation == Configuration.ORIENTATION_PORTRAIT
    }

    private fun updateOverlayFlag(result: MethodChannel.Result, flag: String){
        if(windowManager != null) {
            FlutterWindowSetup.setFlag(flag)
            val params: LayoutParams = flutterView.layoutParams as LayoutParams
            params.flags = FlutterWindowSetup.flag
                .or(LayoutParams.FLAG_LAYOUT_IN_SCREEN)
                .or(LayoutParams.FLAG_LAYOUT_INSET_DECOR)
                .or(LayoutParams.FLAG_HARDWARE_ACCELERATED)

            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.S
                && FlutterWindowSetup.flag == clickableFlag){
                params.alpha = 1f
            }

            windowManager!!.updateViewLayout(flutterView, params)
            result.success(true)
        } else {
            result.success(false)
        }
    }

    private fun resizeOverlay(width:Int, height: Int, result: MethodChannel.Result){
        if(windowManager != null){
            val params: LayoutParams = flutterView.layoutParams as LayoutParams
            params.width = if(width == -1999 or -1) -1 else dpToPx(width)
            params.height = if(height != 1999 or -1) dpToPx(height) else height
            windowManager!!.updateViewLayout(flutterView, params)
            result.success(true)
        } else {
            result.success(false)
        }
    }

    private fun dpToPx(dp: Int): Int {
        return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP,
            dp.toFloat(), resources.displayMetrics).toInt()
    }

    private fun getStatusBarHeightPx(): Int {
        if(mStatusBarHeight == -1){
            val statusBarHeight = resources.getIdentifier(
            "status_bar_height",
            "dimen",
            "android"
            )

            mStatusBarHeight = if(statusBarHeight > 0){
                resources.getDimensionPixelSize(statusBarHeight)
            } else {
                dpToPx(DEFAULT_STATUS_BAR_HEIGHT_DP)
            }
        }

        return mStatusBarHeight
    }

    private fun createNotificationChannel() {
        val serviceChannel = NotificationChannel(
            ChannelTag.channelId,
            "Foreground Service Channel",
            NotificationManager.IMPORTANCE_DEFAULT
        )

        val manager = getSystemService(NotificationManager::class.simpleName!!) as NotificationManager
        manager.createNotificationChannel(serviceChannel)
    }

    override fun onTouch(v: View?, event: MotionEvent?): Boolean {
        if(windowManager != null && FlutterWindowSetup.enableDrag){
            val params = flutterView.layoutParams as LayoutParams
            when (event?.action){
                MotionEvent.ACTION_DOWN -> {
                    dragging = false
                    lastX = event.rawX - lastX
                    lastY = event.rawY - lastY
                }
                MotionEvent.ACTION_MOVE -> {
                    val dx = event.rawX - lastX
                    val dy = event.rawY - lastY
                    if(!dragging && dx * dx + dy * dy < 25){
                        return false
                    }
                    lastX = event.rawX
                    lastY = event.rawY
                    val xx = params.x + dx.toInt()
                    val yy = params.y + dy.toInt()
                    params.x = xx
                    params.y = yy
                    windowManager!!.updateViewLayout(flutterView, params)
                    dragging = true
                }
                MotionEvent.ACTION_UP, MotionEvent.ACTION_CANCEL -> {
                    lastYPosition = params.y
                    if(FlutterWindowSetup.positionGravity != "none"){
                        windowManager!!.updateViewLayout(flutterView, params)
                        animationTimerTask = AnimationTimerTask()
                        mAnimationTimer = Timer()
                        mAnimationTimer.schedule(animationTimerTask, 0, 25)
                    }
                    return false
                }
                else -> return false
            }
            return false
        }
        return false
    }

    inner class AnimationTimerTask: TimerTask() {
        private var destX = 1
        private var destY = 1
        private var params = flutterView.layoutParams as LayoutParams

        init {
            destY = lastYPosition
            when(FlutterWindowSetup.positionGravity){
                "auto" -> {
                    destX = if((params.x + (flutterView.width / 2)) <= szWindow.x / 2){
                        0
                    } else {
                        szWindow.x - flutterView.width
                    }
                }
                "left" -> destX = 0
                "right" -> destX = szWindow.x - flutterView.width
                else -> {
                    destX = params.x
                    destY = params.y
                }
            }
        }

        override fun run() {
            animationHandler.post {
                params.x = (2 * (params.x - destX)) / 3 + destX
                params.y = (2 * (params.y - destY)) / 3 + destY
                windowManager!!.updateViewLayout(flutterView, params)
                if(abs(params.x - destX) < 2 && abs(params.y - destY) < 2){
                    this.cancel()
                }
            }
        }

    }
}