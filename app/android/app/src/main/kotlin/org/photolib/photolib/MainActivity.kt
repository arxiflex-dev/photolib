package org.photolib.photolib

import android.content.Context
import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

/** Shows the process's one engine (PhotolibApplication), which outlives it, and adds the channels that need it. */
open class MainActivity : FlutterActivity() {
    private var mediaStore: MediaStoreChannel? = null
    private var requests: MediaRequests? = null
    private var intents: GalleryIntents? = null
    private var actions: GalleryActions? = null

    /** Whether this is the activity over the lock screen (SecureReviewActivity): it shows what it was sent and no more. */
    protected open val secure = false

    /** Whether main() ran before this activity, which then does not start it at its launch intent's route. */
    private var running = false

    override fun provideFlutterEngine(context: Context): FlutterEngine {
        val engine = PhotolibApplication.engine(context)
        running = engine.dartExecutor.isExecutingDart
        return engine
    }

    override fun shouldDestroyEngineWithHost() = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // A link that opened the app while it ran in the background (ADR-0243).
        val link = intent.data
        if (running && savedInstanceState == null && link != null) {
            flutterEngine?.navigationChannel?.pushRouteInformation("$link")
        }
    }

    override fun onResume() {
        super.onResume()
        preferHighestRefreshRate()
    }

    /** The fastest mode at this resolution (docs/10 §3.3): pinning the current one can hold an LTPO panel at 30 Hz. */
    private fun preferHighestRefreshRate() {
        val display = display ?: return
        val current = display.mode
        val best =
            display.supportedModes
                .filter { it.physicalWidth == current.physicalWidth && it.physicalHeight == current.physicalHeight }
                .maxByOrNull { it.refreshRate } ?: return
        window.attributes = window.attributes.apply { preferredDisplayModeId = best.modeId }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        mediaStore = MediaStoreChannel(this, flutterEngine.dartExecutor.binaryMessenger)
        requests = MediaRequests(this, flutterEngine.dartExecutor.binaryMessenger)
        ViewerChannel(this, flutterEngine.dartExecutor.binaryMessenger)
        intents = GalleryIntents(this, flutterEngine.dartExecutor.binaryMessenger, secure, running)
        actions = GalleryActions(this, flutterEngine.dartExecutor.binaryMessenger)
        HdrLeafFactory.register(this, flutterEngine)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        intents?.onNewIntent(intent)
    }

    override fun onActivityResult(
        requestCode: Int,
        resultCode: Int,
        data: Intent?,
    ) {
        super.onActivityResult(requestCode, resultCode, data)
        requests?.onActivityResult(requestCode, resultCode)
        actions?.onActivityResult(requestCode, resultCode, data)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        mediaStore?.onPermissionsResult(requestCode)
    }
}
