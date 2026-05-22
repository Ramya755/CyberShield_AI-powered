package com.example.cyber_shield

import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val settingsChannelName = "scam_detector/notification_listener_settings"
    private val eventChannelName = "scam_detector/notification_listener"
    private val predictionChannelName = "scam_detector/prediction"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            settingsChannelName
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "openNotificationAccessSettings" -> {
                    val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
                    startActivity(intent)
                    result.success(null)
                }

                "isNotificationListenerEnabled" -> {
                    val enabledListeners = Settings.Secure.getString(
                        contentResolver,
                        "enabled_notification_listeners"
                    )

                    val packageName = applicationContext.packageName
                    val isEnabled = enabledListeners?.contains(packageName) == true

                    result.success(isEnabled)
                }

                else -> result.notImplemented()
            }
        }

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            eventChannelName
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                NotificationListenerService.eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                NotificationListenerService.eventSink = null
            }
        })
    }
}