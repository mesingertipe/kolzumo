package co.com.kolzumo.app

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val CRASH_CHANNEL = "co.com.kolzumo.app/crash_test"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CRASH_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "forceCrash") {
                // En un hilo desacoplado de Flutter lanzamos el RuntimeException
                // Esto garantiza que el sistema Android no pueda interceptarlo y tumbe el proceso
                Thread {
                    throw RuntimeException("Crashlytics Test Crash Nativo - KolZumo")
                }.start()
                result.success(true)
            } else {
                result.notImplemented()
            }
        }
    }
}


