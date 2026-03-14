package org.godotengine.plugin.firebase

import android.util.Log
import com.google.firebase.remoteconfig.FirebaseRemoteConfig
import com.google.firebase.remoteconfig.FirebaseRemoteConfigSettings
import org.godotengine.godot.Dictionary
import org.godotengine.godot.plugin.SignalInfo

class RemoteConfig(private val plugin: FirebasePlugin) {
	companion object {
		private const val TAG = "GodotFirebaseRemoteConfig"
	}

	private val remoteConfig: FirebaseRemoteConfig = FirebaseRemoteConfig.getInstance()

	fun remoteConfigSignals(): MutableSet<SignalInfo> {
		val signals: MutableSet<SignalInfo> = mutableSetOf()
		signals.add(SignalInfo("remote_config_fetch_completed", Dictionary::class.java))
		return signals
	}

	fun initialize() {
		val configSettings = FirebaseRemoteConfigSettings.Builder()
			.setMinimumFetchIntervalInSeconds(3600)
			.build()
		remoteConfig.setConfigSettingsAsync(configSettings)
		Log.d(TAG, "Remote Config initialized")
	}

	fun setDefaults(defaults: Dictionary) {
		val defaultsMap = mutableMapOf<String, Any>()
		for (key in defaults.keys) {
			val value = defaults[key]
			if (value != null) {
				defaultsMap[key.toString()] = value
			}
		}
		remoteConfig.setDefaultsAsync(defaultsMap)
		Log.d(TAG, "Defaults set: ${defaultsMap.keys}")
	}

	fun fetchAndActivate() {
		remoteConfig.fetchAndActivate()
			.addOnSuccessListener { activated ->
				val result = Dictionary()
				result["status"] = true
				result["activated"] = activated
				result["error"] = ""
				Log.d(TAG, "Fetch and activate succeeded (activated=$activated)")
				plugin.emitGodotSignal("remote_config_fetch_completed", result)
			}
			.addOnFailureListener { e ->
				val result = Dictionary()
				result["status"] = false
				result["activated"] = false
				result["error"] = e.message ?: "Unknown error"
				Log.e(TAG, "Fetch and activate failed", e)
				plugin.emitGodotSignal("remote_config_fetch_completed", result)
			}
	}

	fun getString(key: String): String {
		return remoteConfig.getString(key)
	}

	fun getBoolean(key: String): Boolean {
		return remoteConfig.getBoolean(key)
	}

	fun getLong(key: String): Long {
		return remoteConfig.getLong(key)
	}

	fun getDouble(key: String): Double {
		return remoteConfig.getDouble(key)
	}
}
