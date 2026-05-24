package com.example.own_bar

import android.app.Notification
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.content.Intent
import android.os.Build

class NotificationListener : NotificationListenerService() {

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        super.onNotificationPosted(sbn)
        val title = sbn.notification.extras.getString(Notification.EXTRA_TITLE) ?: ""
        val text = sbn.notification.extras.getString(Notification.EXTRA_TEXT) ?: ""
        val appName = sbn.packageName

        // نرسل البيانات إلى خدمة النافذة العائمة
        val intent = Intent(this, OverlayService::class.java).apply {
            putExtra("title", title)
            putExtra("text", text)
            putExtra("app", appName)
            putExtra("action", "update")
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification) {
        super.onNotificationRemoved(sbn)
        val intent = Intent(this, OverlayService::class.java).apply {
            putExtra("action", "remove")
        }
        startService(intent)
    }
}
