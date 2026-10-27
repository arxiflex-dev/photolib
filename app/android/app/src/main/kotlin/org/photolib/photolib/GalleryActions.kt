package org.photolib.photolib

import android.app.Activity
import android.app.WallpaperManager
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ShortcutInfo
import android.content.pm.ShortcutManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.Icon
import android.net.Uri
import android.provider.MediaStore
import android.provider.Settings
import androidx.core.content.FileProvider
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.File
import java.security.MessageDigest
import java.util.concurrent.Executors

/**
 * What a default gallery does beside answering intents (app/lib/features/gallery/, ADR-0401): hands an item to the
 * editor the user picks with a write grant on a copy, and takes back what the editor made; sets a wallpaper for the
 * home screen, the lock screen or both; says whether Photolib is the default viewer and which camera is, and opens the
 * system's screens for both and for MANAGE_MEDIA; pins shortcuts to folders and albums; and updates the widgets.
 * Never asks for unrestricted battery use or all-files access (ADR-0039).
 */
class GalleryActions(
    private val activity: Activity,
    messenger: BinaryMessenger,
) {
    private val pool = Executors.newSingleThreadExecutor()
    /** The edit under way: its answer, the copy the editor writes, the copy's URI and what the copy held. */
    private class Edit(
        val result: MethodChannel.Result,
        val copy: File,
        val shared: Uri,
        val before: ByteArray,
    )

    private var editing: Edit? = null

    init {
        MethodChannel(messenger, "org.photolib/gallery").setMethodCallHandler { call, result ->
            when (call.method) {
                "editors" -> {
                    val type = call.arguments as String? ?: "image/*"
                    result.success(editors(type))
                }

                "editWith" -> {
                    val (uri, type, pkg) = call.arguments as List<*>
                    editWith(Uri.parse(uri as String), type as String? ?: "image/jpeg", pkg as String?, result)
                }

                "openWith" -> {
                    val (uri, type) = call.arguments as List<*>
                    openWith(Uri.parse(uri as String), type as String?)
                    result.success(null)
                }

                "setWallpaper" -> {
                    val (uri, which) = call.arguments as List<*>
                    pool.execute {
                        val failure = try {
                            setWallpaper(Uri.parse(uri as String), which as String)
                            null
                        } catch (e: Exception) {
                            NativeLog.log("warning", "gallery", "wallpaper not set", mapOf("error" to "$e"))
                            e
                        }
                        activity.runOnUiThread {
                            if (failure == null) result.success(null) else result.error("failed", failure.message, null)
                        }
                    }
                }

                "status" -> {
                    result.success(status())
                }

                "open" -> {
                    result.success(open(call.arguments as String))
                }

                "pinShortcut" -> {
                    val (id, label, link) = call.arguments as List<*>
                    result.success(pin(id as String, label as String, link as String))
                }

                "widgetsDir" -> {
                    result.success(File(activity.filesDir, PhotoWidget.DIRECTORY).also { it.mkdirs() }.path)
                }

                "updateWidgets" -> {
                    PhotoWidget.refresh(activity)
                    result.success(null)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    /** From MainActivity.onActivityResult: the editor's answer. */
    fun onActivityResult(
        requestCode: Int,
        resultCode: Int,
        data: Intent?,
    ) {
        if (requestCode != EDIT) return
        val edit = editing ?: return
        editing = null
        val (result, copy) = edit.result to edit.copy
        pool.execute {
            val answer = try {
                if (resultCode == Activity.RESULT_OK) edited(edit, data) else null
            } catch (e: Exception) {
                NativeLog.log("warning", "gallery", "edit not read", mapOf("error" to "$e"))
                e
            }
            // deletion-ok: the cache copy this edit made
            copy.delete()
            activity.runOnUiThread {
                if (answer is Exception) result.error("failed", answer.message, null) else result.success(answer)
            }
        }
    }

    /** The apps that edit an item of [type], by label. */
    private fun editors(type: String): List<Map<String, String>> {
        val intent = Intent(Intent.ACTION_EDIT).setDataAndType(Uri.parse("content://media/external/images/media/1"), type)
        return activity.packageManager
            .queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY)
            .filter { it.activityInfo.packageName != activity.packageName }
            .distinctBy { it.activityInfo.packageName }
            .map { mapOf("package" to it.activityInfo.packageName, "label" to "${it.loadLabel(activity.packageManager)}") }
    }

    /**
     * Gives the editor [pkg] a copy of the item in the app's cache, readable and writable, so that the original is
     * never written; the answer is the edited picture as JPEG bytes, or null when the editor changed nothing.
     */
    private fun editWith(
        uri: Uri,
        type: String,
        pkg: String?,
        result: MethodChannel.Result,
    ) {
        if (editing != null) return result.error("busy", "another edit is open", null)
        pool.execute {
            try {
                val dir = File(activity.cacheDir, "edits").also { it.mkdirs() }
                val copy = File.createTempFile("edit", ".${extension(type)}", dir)
                requireNotNull(activity.contentResolver.openInputStream(uri)).use { input ->
                    copy.outputStream().use { input.copyTo(it) }
                }
                val shared = FileProvider.getUriForFile(activity, "${activity.packageName}.files", copy)
                val intent =
                    Intent(Intent.ACTION_EDIT)
                        .setDataAndType(shared, type)
                        .putExtra(MediaStore.EXTRA_OUTPUT, shared)
                        .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
                if (pkg != null) intent.setPackage(pkg)
                val before = digest(copy.readBytes())
                activity.runOnUiThread {
                    editing = Edit(result, copy, shared, before)
                    try {
                        activity.startActivityForResult(intent, EDIT)
                    } catch (e: Exception) {
                        editing = null
                        // deletion-ok: the cache copy this edit made
                        copy.delete()
                        result.error("failed", e.message, null)
                    }
                }
            } catch (e: Exception) {
                activity.runOnUiThread { result.error("failed", e.message, null) }
            }
        }
    }

    /** What the editor made: a picture it returned, else the copy it wrote to when that changed; as JPEG. */
    private fun edited(
        edit: Edit,
        data: Intent?,
    ): ByteArray? {
        val returned = data?.data?.takeIf { it != edit.shared }
        val bytes =
            if (returned != null) {
                requireNotNull(activity.contentResolver.openInputStream(returned)).use { it.readBytes() }
            } else {
                edit.copy.readBytes()
            }
        if (returned == null && digest(bytes).contentEquals(edit.before)) return null
        val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size) ?: error("the editor returned no picture")
        return jpeg(bytes, bitmap)
    }

    private fun digest(bytes: ByteArray): ByteArray = MessageDigest.getInstance("SHA-256").digest(bytes)

    /** [bytes] when they are a JPEG, else [bitmap] compressed as one. */
    private fun jpeg(
        bytes: ByteArray,
        bitmap: Bitmap,
    ): ByteArray {
        if (bytes.size > 2 && bytes[0] == 0xFF.toByte() && bytes[1] == 0xD8.toByte()) return bytes
        return ByteArrayOutputStream().also { bitmap.compress(Bitmap.CompressFormat.JPEG, 95, it) }.toByteArray()
    }

    private fun extension(type: String) =
        when (type) {
            "image/png" -> "png"
            "image/webp" -> "webp"
            else -> "jpg"
        }

    /** A chooser of the apps that open the item, but Photolib, with a grant to read it. */
    private fun openWith(
        uri: Uri,
        type: String?,
    ) {
        val view =
            Intent(Intent.ACTION_VIEW)
                .setDataAndType(uri, type ?: activity.contentResolver.getType(uri) ?: "*/*")
                .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        val chooser =
            Intent.createChooser(view, null)
                .putExtra(Intent.EXTRA_EXCLUDE_COMPONENTS, arrayOf(ComponentName(activity, MainActivity::class.java)))
        activity.startActivity(chooser)
    }

    /** Sets the picture as the wallpaper of [which]: `home`, `lock` or `both`. */
    private fun setWallpaper(
        uri: Uri,
        which: String,
    ) {
        val flags =
            when (which) {
                "home" -> WallpaperManager.FLAG_SYSTEM
                "lock" -> WallpaperManager.FLAG_LOCK
                else -> WallpaperManager.FLAG_SYSTEM or WallpaperManager.FLAG_LOCK
            }
        requireNotNull(activity.contentResolver.openInputStream(uri)).use {
            WallpaperManager.getInstance(activity).setStream(it, null, true, flags)
        }
    }

    /** Whether Photolib opens pictures by default, and which app is the default camera. */
    private fun status(): Map<String, Any?> {
        val packages = activity.packageManager
        val view = Intent(Intent.ACTION_VIEW).setDataAndType(Uri.parse("content://media/external/images/media/1"), "image/jpeg")
        val viewer = packages.resolveActivity(view, PackageManager.MATCH_DEFAULT_ONLY)?.activityInfo?.packageName
        val camera = packages.resolveActivity(Intent(MediaStore.ACTION_IMAGE_CAPTURE), PackageManager.MATCH_DEFAULT_ONLY)
        return mapOf(
            "default" to (viewer == activity.packageName),
            "camera" to camera?.loadLabel(packages)?.toString(),
            "cameraPackage" to camera?.activityInfo?.packageName,
            "shortcuts" to activity.getSystemService(ShortcutManager::class.java).isRequestPinShortcutSupported,
        )
    }

    /** Opens the system's screen [what]: `defaultApps`, `manageMedia`, `notifications` or the app's `details`. */
    private fun open(what: String): Boolean {
        val details = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.parse("package:${activity.packageName}"))
        val intent =
            when (what) {
                "defaultApps" -> Intent(Settings.ACTION_MANAGE_DEFAULT_APPS_SETTINGS)
                "manageMedia" -> Intent(Settings.ACTION_REQUEST_MANAGE_MEDIA, Uri.parse("package:${activity.packageName}"))
                "notifications" ->
                    Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS).putExtra(Settings.EXTRA_APP_PACKAGE, activity.packageName)
                else -> details
            }
        return try {
            activity.startActivity(intent)
            true
        } catch (e: Exception) {
            // Some phones close the app on, or have none of, these screens: the app's details are always there.
            try {
                activity.startActivity(details)
                true
            } catch (e: Exception) {
                false
            }
        }
    }

    /** Offers to pin a shortcut to the folder or album at [link]; false when the launcher cannot. */
    private fun pin(
        id: String,
        label: String,
        link: String,
    ): Boolean {
        val shortcuts = activity.getSystemService(ShortcutManager::class.java)
        if (!shortcuts.isRequestPinShortcutSupported) return false
        val shortcut =
            ShortcutInfo.Builder(activity, id)
                .setShortLabel(label)
                .setIcon(Icon.createWithResource(activity, R.mipmap.ic_launcher))
                .setIntent(Intent(Intent.ACTION_VIEW, Uri.parse(link), activity, MainActivity::class.java))
                .build()
        return shortcuts.requestPinShortcut(shortcut, null)
    }

    private companion object {
        const val EDIT = 4603
    }
}
