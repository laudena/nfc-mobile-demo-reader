package com.laudev.demo_reader

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.laudev.demo_reader/links"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d("DeepLink", "onCreate data=${intent?.data}")
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        Log.d("DeepLink", "onNewIntent data=${intent.data}")
        setIntent(intent)           // <— critical for warm starts
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {
        val data = intent?.dataString ?: return
        Log.d("DeepLink", "handleIntent -> $data")
        Handler(Looper.getMainLooper()).post {
            flutterEngine?.dartExecutor?.binaryMessenger?.let { m ->
                MethodChannel(m, CHANNEL).invokeMethod("link", data, null)
            }
        }
    }
}
