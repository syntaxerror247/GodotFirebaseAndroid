package org.godotengine.plugin.firebase

import android.net.Uri
import android.util.Log
import com.google.firebase.Firebase
import com.google.firebase.storage.storage
import java.io.File
import org.godotengine.godot.Dictionary
import org.godotengine.godot.plugin.SignalInfo

class CloudStorage(private val plugin: FirebasePlugin) {
	companion object {
		private const val TAG = "GodotCloudStorage"
	}

	private val storage = Firebase.storage
	private val storageRef = storage.reference

	fun storageSignals(): MutableSet<SignalInfo> {
		val signals: MutableSet<SignalInfo> = mutableSetOf()
		signals.add(SignalInfo("storage_upload_task_completed", Dictionary::class.java))
		signals.add(SignalInfo("storage_download_task_completed", Dictionary::class.java))
		signals.add(SignalInfo("storage_delete_task_completed", Dictionary::class.java))
		signals.add(SignalInfo("storage_list_task_completed", Dictionary::class.java))
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

	fun uploadFile(path: String, localFilePath: String) {
		val localFile = File(localFilePath)
		if (!localFile.exists()) {
			Log.e(TAG, "Local file does not exist: $localFilePath")
			plugin.emitGodotSignal("storage_upload_task_completed", createResultDict(false, path, "Local file does not exist: $localFilePath"))
			return
		}

		val fileUri = Uri.fromFile(localFile)
		val ref = storageRef.child(path)

		ref.putFile(fileUri)
			.addOnSuccessListener {
				Log.d(TAG, "File uploaded successfully: $path")
				plugin.emitGodotSignal("storage_upload_task_completed", createResultDict(true, path))
			}
			.addOnFailureListener { e ->
				Log.e(TAG, "Upload failed: $path")
				plugin.emitGodotSignal("storage_upload_task_completed", createResultDict(false, path, e.message))
			}
	}

	fun downloadFile(path: String, destinationPath: String) {
		val localFile = File(destinationPath)
		val ref = storageRef.child(path)

		ref.getFile(localFile)
			.addOnSuccessListener {
				Log.d(TAG, "File downloaded successfully to $destinationPath")
				plugin.emitGodotSignal("storage_download_task_completed", createResultDict(false, destinationPath))
			}
			.addOnFailureListener { e ->
				Log.e(TAG, "Download failed: $path")
				plugin.emitGodotSignal("storage_download_task_completed", createResultDict(false, destinationPath, e.message))
			}
	}

	fun deleteFile(path: String) {
		val ref = storageRef.child(path)

		ref.delete()
			.addOnSuccessListener {
				Log.d(TAG, "File deleted: $path")
				plugin.emitGodotSignal("storage_delete_task_completed", createResultDict(true, path))
			}
			.addOnFailureListener { e ->
				Log.e(TAG, "Deletion failed: $path")
				plugin.emitGodotSignal("storage_delete_task_completed", createResultDict(false, path, e.message))
			}
	}

	fun listFiles(path: String) {
		val ref = storageRef.child(path)

		ref.listAll()
			.addOnSuccessListener { listResult ->
				val result = Dictionary()
				val items = listResult.items.map { it.name }
				val prefixes = listResult.prefixes.map { it.name }
				result["files"] = items.toTypedArray()
				result["folders"] = prefixes.toTypedArray()

				Log.d(TAG, "Listed files at $path")
				plugin.emitGodotSignal("storage_list_task_completed", createResultDict(true, path, data = result))
			}
			.addOnFailureListener { e ->
				Log.e(TAG, "Failed to list files at $path")
				plugin.emitGodotSignal("storage_list_task_completed", createResultDict(false, path, e.message))
			}
	}
}
