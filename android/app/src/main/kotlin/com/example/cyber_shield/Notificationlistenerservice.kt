package com.example.cyber_shield

import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import io.flutter.plugin.common.EventChannel

class NotificationListenerService : NotificationListenerService() {

    companion object {
        var eventSink: EventChannel.EventSink? = null
    }

    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        if (sbn == null) return

        val extras = sbn.notification.extras

        val title = extras.getCharSequence("android.title")?.toString() ?: ""
        val text = extras.getCharSequence("android.text")?.toString() ?: ""
        val packageName = sbn.packageName

        val data = hashMapOf<String, Any>(
            "appName" to packageName,
            "sender" to title,
            "message" to text,
            "receivedAt" to System.currentTimeMillis()
        )

        eventSink?.success(data)
    }
}