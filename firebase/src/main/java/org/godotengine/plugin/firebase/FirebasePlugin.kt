package org.godotengine.plugin.firebase

import android.app.Activity
import android.content.Intent
import android.view.View
import org.godotengine.godot.Dictionary
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.GodotPlugin
import org.godotengine.godot.plugin.SignalInfo
import org.godotengine.godot.plugin.UsedByGodot

class FirebasePlugin(godot: Godot) : GodotPlugin(godot) {
	override fun getPluginName(): String = "GodotFirebaseAndroid"

	private val auth = Authentication(this)
	private val firestore = Firestore(this)
	private val storage = CloudStorage(this)
	private val realtimeDatabase = RealtimeDatabase(this)

	override fun onMainCreate(activity: Activity?): View? {
		activity?.let { auth.init(it) }
		return super.onMainCreate(activity)
	}

	override fun onMainActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
		auth.handleActivityResult(requestCode, resultCode, data)
	}

	override fun getPluginSignals(): MutableSet<SignalInfo> {
		val signals: MutableSet<SignalInfo> = mutableSetOf()
		signals.addAll(auth.authSignals())
		signals.addAll(firestore.firestoreSignals())
		signals.addAll(realtimeDatabase.realtimeDbSignals())
		signals.addAll(storage.storageSignals())
		return signals
	}

	fun emitGodotSignal(signalName: String, arg1: Any?, arg2: Any? = null) {
		if (arg2 != null) {
			emitSignal(signalName, arg1, arg2)
		} else {
			emitSignal(signalName, arg1)
		}
	}

	/**
	 * Authentication
	 */
	@UsedByGodot
	fun signInAnonymously() = auth.signInAnonymously()

	@UsedByGodot
	fun createUserWithEmailPassword(email: String, password: String) = auth.createUserWithEmailPassword(email, password)

	@UsedByGodot
	fun signInWithEmailPassword(email: String, password: String) = auth.signInWithEmailPassword(email, password)

	@UsedByGodot
	fun sendEmailVerification() = auth.sendEmailVerification()

	@UsedByGodot
	fun sendPasswordResetEmail(email: String) = auth.sendPasswordResetEmail(email)

	@UsedByGodot
	fun signInWithGoogle() = auth.signInWithGoogle()

	@UsedByGodot
	fun getCurrentUser() = auth.getCurrentUser()

	@UsedByGodot
	fun isSignedIn() = auth.isSignedIn()

	@UsedByGodot
	fun signOut() = auth.signOut()

	@UsedByGodot
	fun deleteUser() = auth.deleteUser()

	/**
	 * Firestore
	 */

	@UsedByGodot
	fun firestoreAddDocument(collection: String, data: Dictionary) = firestore.addDocument(collection, data)

	@UsedByGodot
	fun firestoreSetDocument(collection: String, documentId: String, data: Dictionary, merge: Boolean = false) = firestore.setDocument(collection, documentId, data, merge)

	@UsedByGodot
	fun firestoreGetDocument(collection: String, documentId: String) = firestore.getDocument(collection, documentId)

	@UsedByGodot
	fun firestoreUpdateDocument(collection: String, documentId: String, data: Dictionary) = firestore.updateDocument(collection, documentId, data)

	@UsedByGodot
	fun firestoreDeleteDocument(collection: String, documentId: String) = firestore.deleteDocument(collection, documentId)

	@UsedByGodot
	fun firestoreGetDocumentsInCollection(collection: String) = firestore.getDocumentsInCollection(collection)

	@UsedByGodot
	fun firestoreListenToDocument(documentPath: String) = firestore.listenToDocument(documentPath)

	@UsedByGodot
	fun firestoreStopListeningToDocument(documentPath: String) = firestore.stopListeningToDocument(documentPath)

	/**
	 * Cloud Storage
	 */

	@UsedByGodot
	fun storageUploadFile(path: String, localFilePath: String) = storage.uploadFile(path, localFilePath)

	@UsedByGodot
	fun storageDownloadFile(path: String, destinationPath: String) = storage.downloadFile(path, destinationPath)

	@UsedByGodot
	fun storageGetMetadata(path: String) = storage.getMetadata(path)

	@UsedByGodot
	fun storageDeleteFile(path: String) = storage.deleteFile(path)

	@UsedByGodot
	fun storageListFiles(path: String) = storage.listFiles(path)

	/**
	 * Realtime Database
	 */

	@UsedByGodot
	fun rtdbSetValue(path: String, data: Dictionary) = realtimeDatabase.setValue(path, data)

	@UsedByGodot
	fun rtdbGetValue(path: String) = realtimeDatabase.getValue(path)

	@UsedByGodot
	fun rtdbUpdateValue(path: String, data: Dictionary) = realtimeDatabase.updateValue(path, data)

	@UsedByGodot
	fun rtdbDeleteValue(path: String) = realtimeDatabase.deleteValue(path)

	@UsedByGodot
	fun rtdbListenToPath(path: String) = realtimeDatabase.listenToPath(path)

	@UsedByGodot
	fun rtdbStopListening(path: String) = realtimeDatabase.stopListening(path)
}
