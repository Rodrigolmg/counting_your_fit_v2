package com.rlorg.counting_your_fit_v2.service

import android.service.autofill.Validators.or
import android.view.Gravity
import android.view.WindowManager
import androidx.core.app.NotificationCompat

abstract class FlutterWindowSetup {
    companion object {
        var height: Int = WindowManager.LayoutParams.MATCH_PARENT
        var width: Int = WindowManager.LayoutParams.MATCH_PARENT
        var flag: Int = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
        var gravity: Int = Gravity.CENTER
        var enableDrag: Boolean = false
        var positionGravity = "none"
        var overlayTitle = "Overlay is activated"
        var overlayContent = "Tap to edit settings or disable"
        var notificationVisibility = NotificationCompat.VISIBILITY_PRIVATE

        fun setFlag(name: String) {
            if(name.equals("flagNotFocusable", ignoreCase = true)
                or name.equals("defaultFlag", ignoreCase = true)){
                flag = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
            }

            if(name.equals("flagNotTouchable", ignoreCase = true)
                or name.equals("clickThrough", ignoreCase = true)){
                flag = WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE
                    .or(WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE)
                    .or(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS)
                    .or(WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN)
            }

            if(name.equals("flagNotTouchModal", ignoreCase = true)
                or name.equals("focusPointer", ignoreCase = true)){
                flag = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
            }
        }

        fun setGravityFromAlignment(alignment: String){
            when(alignment.lowercase()){
                "topleft" -> gravity = Gravity.TOP.or(Gravity.START)
                "topcenter" -> gravity = Gravity.TOP
                "topright" -> gravity = Gravity.TOP.or(Gravity.END)
                "centerleft" -> gravity = Gravity.CENTER.or(Gravity.START)
                "center" -> gravity = Gravity.CENTER
                "centerright" -> gravity = Gravity.CENTER.or(Gravity.END)
                "bottomleft" -> gravity = Gravity.BOTTOM.or(Gravity.START)
                "bottomCenter" -> gravity = Gravity.BOTTOM
                "bottomright" -> gravity = Gravity.BOTTOM.or(Gravity.END)
            }
        }

        fun setNotificationVisibility(name: String){
            notificationVisibility = when(name.lowercase()){
                "flagnotfocusable", "defaultflag" -> {
                    WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
                }
                "flagnottouchable", "clickthrough" -> {
                    WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE
                        .or(WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE)
                        .or(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS)
                        .or(WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN)
                }
                "flagnottouchmodal", "focuspointer" -> {
                    WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
                }
                else -> notificationVisibility
            }
        }
    }
}