package org.godotengine.plugin.firebase

import android.util.Log
import com.google.firebase.Firebase
import com.google.firebase.firestore.DocumentSnapshot
import com.google.firebase.firestore.ListenerRegistration
import com.google.firebase.firestore.SetOptions
import com.google.firebase.firestore.firestore
import org.godotengine.godot.Dictionary
import org.godotengine.godot.plugin.SignalInfo

class Firestore(private val plugin: FirebasePlugin) {
	companion object {
		private const val TAG = "GodotFirestore"
	}

	private val firestore = Firebase.firestore
	private val documentListeners: MutableMap<String, ListenerRegistration> = mutableMapOf()

	fun firestoreSignals(): MutableSet<SignalInfo> {
		val signals: MutableSet<SignalInfo> = mutableSetOf()
		signals.add(SignalInfo("firestore_write_task_completed", Dictionary::class.java))
		signals.add(SignalInfo("firestore_get_task_completed", Dictionary::class.java))
		signals.add(SignalInfo("firestore_update_task_completed", Dictionary::class.java))
		signals.add(SignalInfo("firestore_delete_task_completed", Dictionary::class.java))
		signals.add(SignalInfo("firestore_document_changed", String::class.java, Dictionary::class.java))
		return signals
	}

	private fun createResultDict(
		status: Boolean,
		docID: String? = null,
		error: String? = null,
		data: Dictionary? = null
	): Dictionary {
		val result = Dictionary()
		result["status"] = status
		if (docID != null) result["docID"] = docID
		if (error != null) result["error"] = error
		if (data != null) result["data"] = data
		return result
	}

	fun addDocument(collection: String, data: Dictionary) {
		val map = data.toMap()

		firestore.collection(collection).add(map)
			.addOnSuccessListener { documentRef ->
				val docId = documentRef.id
				Log.d(TAG, "Document added with ID: $docId")
				plugin.emitGodotSignal("firestore_write_task_completed", createResultDict(true, docId))
			}
			.addOnFailureListener { e ->
				Log.e(TAG, "Error adding document:", e)
				plugin.emitGodotSignal("firestore_write_task_completed", createResultDict(false, error = e.message))
			}
	}

	fun setDocument(collection: String, documentId: String, data: Dictionary, merge: Boolean = false) {
		val map = data.toMap()
		val docRef = firestore.collection(collection).document(documentId)
		val task = if (merge) docRef.set(map, SetOptions.merge()) else docRef.set(map)

		task.addOnSuccessListener {
			Log.d(TAG, "Document $documentId set successfully (merge=$merge)")
			plugin.emitGodotSignal("firestore_write_task_completed", createResultDict(true, documentId))
		}.addOnFailureListener { e ->
			Log.e(TAG, "Error setting document:", e)
			plugin.emitGodotSignal("firestore_write_task_completed", createResultDict(false, documentId, e.message))
		}
	}

	fun getDocumentsInCollection(collection: String) {
		firestore.collection(collection).get()
			.addOnSuccessListener { querySnapshot ->
				val resultData = Dictionary()
				for (doc in querySnapshot.documents) {
					val dict = Dictionary()
					doc.data?.forEach { (key, value) -> dict[key] = value }
					resultData[doc.id] = dict
				}
				Log.d(TAG, "Documents retrieved successfully from $collection")
				plugin.emitGodotSignal("firestore_get_task_completed", createResultDict(true, data = resultData))
			}
			.addOnFailureListener { e ->
				Log.e(TAG, "Error getting documents from collection:", e)
				plugin.emitGodotSignal("firestore_get_task_completed", createResultDict(false, error = e.message))
			}
	}

	fun getDocument(collection: String, documentId: String) {
		firestore.collection(collection).document(documentId).get()
			.addOnSuccessListener { documentSnapshot ->
				if (documentSnapshot.exists()) {
					val data = snapshotToDictionary(documentSnapshot)
					Log.d(TAG, "Document $documentId retrieved successfully")
					plugin.emitGodotSignal("firestore_get_task_completed", createResultDict(true, documentId, data = data))
				} else {
					Log.e(TAG, "Document $documentId does not exist")
					plugin.emitGodotSignal("firestore_get_task_completed", createResultDict(false, documentId, "Document does not exist"))
				}
			}
			.addOnFailureListener { e ->
				Log.e(TAG, "Error getting document:", e)
				plugin.emitGodotSignal("firestore_get_task_completed", createResultDict(false, documentId, e.message))
			}
	}

	fun updateDocument(collection: String, documentId: String, data: Dictionary) {
		val map = data.toMap()
		firestore.collection(collection).document(documentId).update(map)
			.addOnSuccessListener {
				Log.d(TAG, "Document $documentId updated successfully")
				plugin.emitGodotSignal("firestore_update_task_completed", createResultDict(true, documentId))
			}
			.addOnFailureListener { e ->
				Log.e(TAG, "Error updating document:", e)
				plugin.emitGodotSignal("firestore_update_task_completed", createResultDict(false, documentId, e.message))
			}
	}

	fun deleteDocument(collection: String, documentId: String) {
		firestore.collection(collection).document(documentId).delete()
			.addOnSuccessListener {
				Log.d(TAG, "Document $documentId deleted successfully")
				plugin.emitGodotSignal("firestore_delete_task_completed", createResultDict(true, documentId))
			}
			.addOnFailureListener { e ->
				Log.e(TAG, "Error deleting document:", e)
				plugin.emitGodotSignal("firestore_delete_task_completed", createResultDict(false, documentId, e.message))
			}
	}

	fun listenToDocument(documentPath: String) {
		val docRef = firestore.document(documentPath)
		val listener = docRef.addSnapshotListener { snapshot, error ->
			if (error != null) {
				Log.e(TAG, "Listen failed for document $documentPath", error)
				return@addSnapshotListener
			}
			if (snapshot != null && snapshot.exists()) {
				val data = snapshotToDictionary(snapshot)
				Log.d(TAG, "Document changed at $documentPath")
				plugin.emitGodotSignal("firestore_document_changed", documentPath, data)
			}
		}
		documentListeners[documentPath] = listener
	}

	fun stopListeningToDocument(documentPath: String) {
		documentListeners[documentPath]?.remove()
		documentListeners.remove(documentPath)
		Log.d(TAG, "Stopped listening to document $documentPath")
	}


	private fun snapshotToDictionary(snapshot: DocumentSnapshot): Dictionary {
		val dict = Dictionary()
		if (snapshot.exists()) {
			val dataMap = snapshot.data
			if (dataMap != null) {
				val converted = convertValueToGodotType(dataMap)
				if (converted is Dictionary) {
					return converted
				}
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
