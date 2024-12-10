package com.example.auto_sms

import android.content.pm.PackageManager
import android.telephony.SmsManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.auto_sms/sms"
    private val SMS_PERMISSION_CODE = 101

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "sendSMS") {
                val number = call.argument<String>("number")
                val message = call.argument<String>("message")

                if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.SEND_SMS) == PackageManager.PERMISSION_GRANTED) {
                    if (!number.isNullOrEmpty() && !message.isNullOrEmpty()) {
                        try {
                            sendSMS(number, message)
                            result.success("SMS sent successfully")
                        } catch (e: Exception) {
                            result.error("SMS_ERROR", "Failed to send SMS: ${e.message}", null)
                        }
                    } else {
                        result.error("INVALID_ARGUMENTS", "Number or Message is null/empty", null)
                    }
                } else {
                    requestSMSPermission()
                    result.error("PERMISSION_DENIED", "SMS permission not granted", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun sendSMS(number: String, message: String) {
        val smsManager = SmsManager.getDefault()
        smsManager.sendTextMessage(number, null, message, null, null)
    }

    private fun requestSMSPermission() {
        ActivityCompat.requestPermissions(this, arrayOf(android.Manifest.permission.SEND_SMS), SMS_PERMISSION_CODE)
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == SMS_PERMISSION_CODE) {
            if ((grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED)) {
                println("SMS Permission Granted")
            } else {
                println("SMS Permission Denied")
            }
        }
    }
}
