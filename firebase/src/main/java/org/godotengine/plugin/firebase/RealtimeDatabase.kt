package org.godotengine.plugin.firebase

import android.util.Log
import com.google.firebase.Firebase
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.ValueEventListener
import com.google.firebase.database.database
import org.godotengine.godot.Dictionary
import org.godotengine.godot.plugin.SignalInfo

class RealtimeDatabase(private val plugin: FirebasePlugin) {
	companion object {
		private const val TAG = "GodotRealtimeDatabase"
	}

	private val db = Firebase.database.reference
	private val listeners: MutableMap<String, ValueEventListener> = mutableMapOf()

	fun realtimeDbSignals(): MutableSet<SignalInfo> {
		val signals: MutableSet<SignalInfo> = mutableSetOf()
		signals.add(SignalInfo("realtime_write_task_completed", Dictionary::class.java))
		signals.add(SignalInfo("realtime_get_task_completed", Dictionary::class.java))
		signals.add(SignalInfo("realtime_update_task_completed", Dictionary::class.java))
		signals.add(SignalInfo("realtime_delete_task_completed", Dictionary::class.java))
		signals.add(SignalInfo("realtime_db_value_changed", String::class.java, Dictionary::class.java))
		return signals
	}

	private fun createResultDict(
		status: Boolean,
		path: String? = null,
		error: String? = null,
		data: Dictionary? = null
	): Dictionary {
		val result = Dictionary()
		result["status"] = status
		if (path != null) result["path"] = path
		if (error != null) result["error"] = error
		if (data != null) result["data"] = data
		return result
	}

	fun setValue(path: String, data: Dictionary) {
		val map = data.toMap()
		db.child(path).setValue(map)
			.addOnSuccessListener {
				Log.d(TAG, "Data set successfully at $path")
				plugin.emitGodotSignal("realtime_write_task_completed", createResultDict(true, path))
			}
			.addOnFailureListener { e ->
				Log.e(TAG, "Error setting data at $path:", e)
				plugin.emitGodotSignal("realtime_write_task_completed", createResultDict(false, path, e.message))
			}
	}

	fun getValue(path: String) {
		db.child(path).get()
			.addOnSuccessListener { snapshot ->
				val data = snapshotToDictionary(snapshot)
				plugin.emitGodotSignal("realtime_get_task_completed", createResultDict(true, path, data = data))
			}
			.addOnFailureListener { e ->
				Log.e(TAG, "Error getting data at $path:", e)
				plugin.emitGodotSignal("realtime_get_task_completed", createResultDict(false, path, e.message))
			}
	}

	fun updateValue(path: String, data: Dictionary) {
		val map = data.toMap()
		db.child(path).updateChildren(map)
			.addOnSuccessListener {
				Log.d(TAG, "Data at $path updated successfully")
				plugin.emitGodotSignal("realtime_update_task_completed", createResultDict(true, path))
			}
			.addOnFailureListener { e ->
				Log.e(TAG, "Error updating data at $path:", e)
				plugin.emitGodotSignal("realtime_update_task_completed", createResultDict(false, path, e.message))
			}
	}

	fun deleteValue(path: String) {
		db.child(path).removeValue()
			.addOnSuccessListener {
				Log.d(TAG, "Data at $path deleted successfully")
				plugin.emitGodotSignal("realtime_delete_task_completed", createResultDict(true, path))
			}
			.addOnFailureListener { e ->
				Log.e(TAG, "Error deleting data at $path:", e)
				plugin.emitGodotSignal("realtime_delete_task_completed", createResultDict(false, path, e.message))
			}
	}

	fun listenToPath(path: String) {
		val ref = db.child(path)
		val listener = object : ValueEventListener {
			override fun onDataChange(snapshot: DataSnapshot) {
				val data = snapshotToDictionary(snapshot)
				Log.d(TAG, "Data changed at $path")
				plugin.emitGodotSignal("realtime_db_value_changed", path, data)
			}

			override fun onCancelled(error: DatabaseError) {
				Log.e(TAG, "Listener at $path cancelled: ${error.message}")
			}
		}
		ref.addValueEventListener(listener)
		listeners[path] = listener
	}

	fun stopListening(path: String) {
		val ref = db.child(path)
		listeners[path]?.let {
			ref.removeEventListener(it)
			listeners.remove(path)
			Log.d(TAG, "Stopped listening at $path")
		}
	}

	private fun snapshotToDictionary(snapshot: DataSnapshot): Dictionary {
		val dict = Dictionary()

		if (snapshot.exists()) {
			if (snapshot.hasChildren()) {
				for (child in snapshot.children) {
					dict[child.key ?: ""] = convertValueToGodotType(child.value)
				}
			} else {
				dict["value"] = convertValueToGodotType(snapshot.value)
			}
		}
		return dict
	}

	private fun convertValueToGodotType(value: Any?): Any? {
		return when (value) {
			is Map<*, *> -> {
				val newDict = Dictionary()
				value.forEach { (k, v) ->
					if (k != null) {
						newDict[k.toString()] = convertValueToGodotType(v)
					}
				}
				newDict
			}
			is List<*> -> {
				value.map { convertValueToGodotType(it) }.toTypedArray()
			}
			else -> value
		}
	}
}
