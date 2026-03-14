package org.godotengine.plugin.firebase

import android.os.Bundle
import android.util.Log
import com.google.firebase.analytics.FirebaseAnalytics
import org.godotengine.godot.Dictionary
import org.godotengine.godot.plugin.SignalInfo

class Analytics(private val plugin: FirebasePlugin) {
	companion object {
		private const val TAG = "GodotFirebaseAnalytics"
	}

	private lateinit var firebaseAnalytics: FirebaseAnalytics

	fun init(activity: android.app.Activity) {
		firebaseAnalytics = FirebaseAnalytics.getInstance(activity)
		Log.d(TAG, "Firebase Analytics initialized")
	}

	fun analyticsSignals(): MutableSet<SignalInfo> {
		return mutableSetOf()
	}

	fun logEvent(name: String, parameters: Dictionary) {
		val bundle = Bundle()
		for (key in parameters.keys) {
			val value = parameters[key]
			when (value) {
				is String -> bundle.putString(key.toString(), value)
				is Int -> bundle.putLong(key.toString(), value.toLong())
				is Long -> bundle.putLong(key.toString(), value)
				is Double -> bundle.putDouble(key.toString(), value)
				is Float -> bundle.putDouble(key.toString(), value.toDouble())
				is Boolean -> bundle.putLong(key.toString(), if (value) 1L else 0L)
				else -> bundle.putString(key.toString(), value.toString())
			}
		}
		firebaseAnalytics.logEvent(name, bundle)
		Log.d(TAG, "Event logged: $name")
	}

	fun setUserProperty(name: String, value: String) {
		firebaseAnalytics.setUserProperty(name, value)
		Log.d(TAG, "User property set: $name = $value")
	}

	fun setUserId(id: String) {
		firebaseAnalytics.setUserId(id)
		Log.d(TAG, "User ID set: $id")
	}

	fun setAnalyticsCollectionEnabled(enabled: Boolean) {
		firebaseAnalytics.setAnalyticsCollectionEnabled(enabled)
		Log.d(TAG, "Analytics collection enabled: $enabled")
	}

	fun resetAnalyticsData() {
		firebaseAnalytics.resetAnalyticsData()
		Log.d(TAG, "Analytics data reset")
	}
}
