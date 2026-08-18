package com.pitol.myweekdone.my_week_done_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "my_week_done_app/accessibility",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "isReduceTransparencyEnabled" -> result.success(false)
                else -> result.notImplemented()
            }
        }
    }
}
