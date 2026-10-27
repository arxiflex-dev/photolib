package org.photolib.photolib

import android.app.Activity
import android.content.ClipData
import android.content.Intent
import android.net.Uri
import android.os.Build.VERSION.SDK_INT
import android.provider.MediaStore
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/**
 * The intents other apps send a default gallery (ADR-0039, ADR-0401), for app/lib/features/gallery/: VIEW, the camera
 * apps' REVIEW and REVIEW_SECURE, ATTACH_DATA, EDIT, PICK, GET_CONTENT and SEND are handed to Dart as raw fields
 * (GalleryIntent.fromMap decides what each means); a pick's answer goes back with read grants, and `done` closes the
 * activity that was started for the caller. A URI of another provider that MediaStore knows, such as a file manager's
 * document, is replaced by the MediaStore item, so that the item opens in its folder.
 */
class GalleryIntents(
    private val activity: Activity,
    messenger: BinaryMessenger,
    private val secure: Boolean,
    running: Boolean,
) {
    private val channel = MethodChannel(messenger, "org.photolib/intents")

    /** The launch intent, until Dart has taken it. */
    private var launch: Intent? = if (activity.intent.hasExtra(HANDLED)) null else activity.intent

    init {
        // Dart is already running (the engine outlives activities): it takes the launch intent as a new one.
        if (running) launch?.let { onNewIntent(it) }
        if (running) launch = null
        launch?.putExtra(HANDLED, true)
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "initial" -> {
                    val intent = launch
                    launch = null
                    result.success(intent?.let(::describe))
                }

                "pick" -> {
                    val uris = (call.arguments as List<*>).map { Uri.parse(it as String) }
                    activity.setResult(Activity.RESULT_OK, answer(uris))
                    activity.finish()
                    result.success(null)
                }

                "cancel", "done" -> {
                    if (call.method == "cancel") activity.setResult(Activity.RESULT_CANCELED)
                    activity.finish()
                    result.success(null)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    /** From MainActivity.onNewIntent: an intent for the running activity. */
    fun onNewIntent(intent: Intent) {
        describe(intent)?.let { channel.invokeMethod("intent", it) }
    }

    private fun answer(uris: List<Uri>): Intent {
        val clip = ClipData.newRawUri(null, uris[0]).apply { uris.drop(1).forEach { addItem(ClipData.Item(it)) } }
        return Intent().setData(uris[0]).apply { clipData = clip }.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
    }

    /** The fields Dart needs of [intent]; null for a launch from the launcher. */
    private fun describe(intent: Intent): Map<String, Any?>? {
        val action = intent.action ?: return null
        if (action == Intent.ACTION_MAIN) return null
        val clips = mutableListOf<String>()
        intent.clipData?.let { clip -> for (i in 0 until clip.itemCount) clip.getItemAt(i).uri?.let { clips += "${media(it)}" } }
        for (stream in streams(intent)) if ("${media(stream)}" !in clips) clips += "${media(stream)}"
        return mapOf(
            "action" to action,
            "type" to intent.type,
            "data" to intent.data?.let { "${media(it)}" },
            "clips" to clips,
            "multiple" to intent.getBooleanExtra(Intent.EXTRA_ALLOW_MULTIPLE, false),
            "types" to (intent.getStringArrayExtra(Intent.EXTRA_MIME_TYPES)?.toList() ?: emptyList()),
            "secure" to secure,
        )
    }

    @Suppress("DEPRECATION") // The typed getters are API 33; this runs from API 30.
    private fun streams(intent: Intent): List<Uri> =
        when (intent.action) {
            Intent.ACTION_SEND -> listOfNotNull(intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM))
            Intent.ACTION_SEND_MULTIPLE -> intent.getParcelableArrayListExtra<Uri>(Intent.EXTRA_STREAM) ?: emptyList()
            else -> emptyList()
        }

    /** The MediaStore item [uri] is, for a file manager's document or a plain path; else [uri] itself. */
    private fun media(uri: Uri): Uri {
        if (uri.authority == MediaStore.AUTHORITY) return uri
        return try {
            when {
                uri.scheme == "file" -> byPath(uri.path) ?: uri
                SDK_INT >= 31 -> MediaStore.getMediaUri(activity, uri) ?: uri
                else -> uri
            }
        } catch (e: Exception) {
            uri
        }
    }

    private fun byPath(path: String?): Uri? {
        if (path == null) return null
        val files = MediaStore.Files.getContentUri(MediaStore.VOLUME_EXTERNAL)
        val columns = arrayOf(MediaStore.Files.FileColumns._ID, MediaStore.Files.FileColumns.MEDIA_TYPE)
        activity.contentResolver.query(files, columns, "${MediaStore.Files.FileColumns.DATA} = ?", arrayOf(path), null)
            ?.use { c ->
                if (!c.moveToFirst()) return null
                val kind = if (c.getInt(1) == MediaStore.Files.FileColumns.MEDIA_TYPE_VIDEO) "video" else "images"
                return Uri.parse("content://media/${MediaStore.VOLUME_EXTERNAL}/$kind/media/${c.getLong(0)}")
            }
        return null
    }

    companion object {
        /** Extra marking a launch intent Dart has taken, so that a recreated activity does not open it again. */
        const val HANDLED = "org.photolib.HANDLED"
    }
}
