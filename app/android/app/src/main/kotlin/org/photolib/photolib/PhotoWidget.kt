package org.photolib.photolib

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.widget.RemoteViews
import org.json.JSONObject
import java.io.File

/**
 * A home-screen widget that shows one picture of the app's `widgets/snapshot.json` under [kind]: `memories`, `people`,
 * `albums` or `favourites` (MOB-11, ADR-0401). The app writes the pictures, already rendered, and the entries (title,
 * image file, the `photolib://` link a tap opens) from app/lib/features/gallery/widgets.dart; a widget reads files and
 * never the library, which stays sealed in the vault. Without an entry it shows the app's name and opens the app.
 */
open class PhotoWidget(
    private val kind: String,
) : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        manager: AppWidgetManager,
        ids: IntArray,
    ) {
        for (id in ids) manager.updateAppWidget(id, views(context))
    }

    private fun views(context: Context): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_photo)
        val entry = read(context)?.optJSONObject(kind)
        val image = entry?.optString("image")?.takeIf { it.isNotEmpty() }?.let { File(directory(context), it) }
        val bitmap = image?.takeIf { it.isFile }?.let { decode(it) }
        if (bitmap != null) {
            views.setImageViewBitmap(R.id.widget_image, bitmap)
        } else {
            views.setImageViewResource(R.id.widget_image, R.mipmap.ic_launcher)
        }
        val title = entry?.optString("title")?.takeIf { it.isNotEmpty() } ?: context.getString(R.string.app_name)
        views.setTextViewText(R.id.widget_title, title)
        val link = entry?.optString("link")?.takeIf { it.isNotEmpty() }
        val open =
            if (link != null) {
                Intent(Intent.ACTION_VIEW, Uri.parse(link), context, MainActivity::class.java)
            } else {
                Intent(context, MainActivity::class.java)
            }
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        views.setOnClickPendingIntent(R.id.widget_root, PendingIntent.getActivity(context, kind.hashCode(), open, flags))
        return views
    }

    /** At most 512 px a side: a widget's pictures travel in a binder transaction of limited size. */
    private fun decode(file: File): Bitmap? {
        val options = BitmapFactory.Options().apply { inJustDecodeBounds = true }
        BitmapFactory.decodeFile(file.path, options)
        options.inSampleSize = maxOf(1, maxOf(options.outWidth, options.outHeight) / 512)
        options.inJustDecodeBounds = false
        return BitmapFactory.decodeFile(file.path, options)
    }

    companion object {
        /** The folder of the app's files the snapshot and its pictures are in. */
        const val DIRECTORY = "widgets"

        private val providers =
            listOf(
                MemoriesWidget::class.java,
                PeopleWidget::class.java,
                AlbumsWidget::class.java,
                FavouritesWidget::class.java,
            )

        private fun directory(context: Context) = File(context.filesDir, DIRECTORY)

        private fun read(context: Context): JSONObject? =
            try {
                JSONObject(File(directory(context), "snapshot.json").readText())
            } catch (e: Exception) {
                null
            }

        /** Draws every placed widget again from the snapshot. */
        fun refresh(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            for (provider in providers) {
                val ids = manager.getAppWidgetIds(ComponentName(context, provider))
                if (ids.isNotEmpty()) {
                    val update = Intent(AppWidgetManager.ACTION_APPWIDGET_UPDATE, null, context, provider)
                    context.sendBroadcast(update.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids))
                }
            }
        }
    }
}

/** On this day: a picture of years past. */
class MemoriesWidget : PhotoWidget("memories")

/** A person the library found. */
class PeopleWidget : PhotoWidget("people")

/** An album's cover. */
class AlbumsWidget : PhotoWidget("albums")

/** The latest favourite. */
class FavouritesWidget : PhotoWidget("favourites")
