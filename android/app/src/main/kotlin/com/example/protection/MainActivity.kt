package com.example.protection

import android.app.Activity
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import androidx.core.app.NotificationChannelCompat
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Affiche l'écran même verrouillé, allume l'écran, et le garde actif
        window.addFlags(
            WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
            WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
            WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
        )

        // Active le mode LockTask (KIOSK)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            startLockTask()
        }

        // Crée le canal de notification utilisé par LockService (si nécessaire)
        val channel = NotificationChannelCompat.Builder(
            "lock_channel",
            NotificationManagerCompat.IMPORTANCE_DEFAULT
        )
            .setName("Protection Lock Service")
            .build()
        NotificationManagerCompat.from(this).createNotificationChannel(channel)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Gestion du canal de communication Flutter → Kotlin
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.protection/lock")
            .setMethodCallHandler { call, result ->
                if (call.method == "stopLockTask") {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        stopLockTask()
                    }
                    result.success(null)
                }
            }

        // Transmission éventuelle de la route initiale à Flutter
        val route = intent.getStringExtra("route")
        if (route != null) {
            flutterEngine.navigationChannel.setInitialRoute(route)
        }
    }
}