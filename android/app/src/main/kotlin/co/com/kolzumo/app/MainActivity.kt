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
                // Lanza excepción Runtime nativa en el hilo principal de Android
                // Esto genera un crash nativo 100% real interceptado por Firebase Crashlytics
                throw RuntimeException("Crashlytics Test Crash desde Android Nativo - KolZumo App")
            } else {
                result.notImplemented()
            }
        }
    }
}


