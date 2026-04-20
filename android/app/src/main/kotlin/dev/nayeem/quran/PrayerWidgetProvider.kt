package dev.nayeem.quran

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class PrayerWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: android.content.SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.prayer_widget).apply {
                val nextName = widgetData.getString("next_prayer_name", "Next Prayer")
                val nextTime = widgetData.getString("next_prayer_time", "—")
                val countdown = widgetData.getString("next_prayer_countdown", "")
                setTextViewText(R.id.widget_title, "Next: $nextName")
                setTextViewText(R.id.widget_time, nextTime ?: "—")
                setTextViewText(R.id.widget_countdown, countdown ?: "")

                // Open the app when the widget is tapped
                val openAppIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_root, openAppIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
