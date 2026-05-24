package com.example.own_bar

import android.app.*
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.os.IBinder
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.TextView
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class OverlayService : Service() {

    private lateinit var windowManager: WindowManager
    private lateinit var overlayView: View
    private var flutterChannel: MethodChannel? = null

    override fun onCreate() {
        super.onCreate()
        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
        createOverlayView()
        startForegroundNotification()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        intent?.let {
            when (it.getStringExtra("action")) {
                "update" -> {
                    val title = it.getStringExtra("title") ?: ""
                    val text = it.getStringExtra("text") ?: ""
                    val app = it.getStringExtra("app") ?: ""
                    updateOverlay(title, text, app)
                    sendToFlutter("notificationReceived", mapOf(
                        "title" to title,
                        "text" to text,
                        "app" to app
                    ))
                }
                "remove" -> {
                    hideOverlay()
                    sendToFlutter("notificationRemoved", null)
                }
            }
        }
        return START_STICKY
    }

    private fun createOverlayView() {
        val inflater = getSystemService(LAYOUT_INFLATER_SERVICE) as LayoutInflater
        overlayView = inflater.inflate(R.layout.overlay_notification, null)

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            else
                WindowManager.LayoutParams.TYPE_PHONE,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                    WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.CENTER_HORIZONTAL
            x = 0
            y = 100
        }

        windowManager.addView(overlayView, params)
        overlayView.visibility = View.GONE
    }

    private fun updateOverlay(title: String, text: String, app: String) {
        overlayView.findViewById<TextView>(R.id.title_text).text = title
        overlayView.findViewById<TextView>(R.id.content_text).text = text
        overlayView.visibility = View.VISIBLE
        // يمكن تحديث الشكل ليكون دائريًا أو جزيرة
    }

    private fun hideOverlay() {
        overlayView.visibility = View.GONE
    }

    private fun startForegroundNotification() {
        val channelId = "overlay_channel"
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Overlay Service",
                NotificationManager.IMPORTANCE_LOW
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }

        val notification = NotificationCompat.Builder(this, channelId)
            .setContentTitle("Dynamic Island")
            .setContentText("Running...")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .build()
        startForeground(1, notification)
    }

    private fun sendToFlutter(method: String, args: Map<String, String>?) {
        // سنحتاج إلى FlutterEngine مرتبط، هذا مثال أولي
        flutterChannel?.invokeMethod(method, args)
    }

    override fun onDestroy() {
        super.onDestroy()
        if (overlayView.isAttachedToWindow) windowManager.removeView(overlayView)
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
