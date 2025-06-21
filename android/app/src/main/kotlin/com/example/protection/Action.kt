package com.example.protection

import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.IBinder
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat

class Action : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        if (Intent.ACTION_BOOT_COMPLETED == intent?.action) {
            val serviceIntent = Intent(context, LockService::class.java)
            context.startForegroundService(serviceIntent)
        }
    }

    class LockService : Service() {
        override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
            val notification = NotificationCompat.Builder(this, "lock_channel")
                .setContentTitle("Protection")
                .setContentText("Application de verrouillage active")
                .setSmallIcon(android.R.drawable.ic_lock_lock)
                .build()

            startForeground(1, notification)

            val lockIntent = Intent(this, MainActivity::class.java)
            lockIntent.putExtra("route", "/deverouillage") // 👈 On passe la route Flutter
            lockIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(lockIntent)

            return START_STICKY
        }

        override fun onBind(intent: Intent?): IBinder? {
            return null
        }
    }
}







