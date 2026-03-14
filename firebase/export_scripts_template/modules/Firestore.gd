extends Node

signal write_task_completed(result: Dictionary)
signal get_task_completed(result: Dictionary)
signal update_task_completed(result: Dictionary)
signal delete_task_completed(result: Dictionary)
signal document_changed(document_path: String, data: Dictionary)
signal query_task_completed(result: Dictionary)

var _plugin_singleton: Object

func _connect_signals():
	if not _plugin_singleton:
		return
	_plugin_singleton.connect("firestore_write_task_completed", write_task_completed.emit)
	_plugin_singleton.connect("firestore_get_task_completed", get_task_completed.emit)
	_plugin_singleton.connect("firestore_update_task_completed", update_task_completed.emit)
	_plugin_singleton.connect("firestore_delete_task_completed", delete_task_completed.emit)
	_plugin_singleton.connect("firestore_document_changed", document_changed.emit)
	_plugin_singleton.connect("firestore_query_task_completed", query_task_completed.emit)

func add_document(collection: String, data: Dictionary) -> void:
	if _plugin_singleton:
		_plugin_singleton.firestoreAddDocument(collection, data)

func set_document(collection: String, documentId: String, data: Dictionary, merge: bool = false) -> void:
	if _plugin_singleton:
		_plugin_singleton.firestoreSetDocument(collection, documentId, data, merge)

func get_document(collection: String, documentId: String) -> void:
	if _plugin_singleton:
		_plugin_singleton.firestoreGetDocument(collection, documentId)

func get_documents_in_collection(collection: String) -> void:
	if _plugin_singleton:
		_plugin_singleton.firestoreGetDocumentsInCollection(collection)

func update_document(collection: String, documentId: String, data: Dictionary) -> void:
		if _plugin_singleton:
			_plugin_singleton.firestoreUpdateDocument(collection, documentId, data)

func delete_document(collection: String, documentId: String) -> void:
	if _plugin_singleton:
		_plugin_singleton.firestoreDeleteDocument(collection, documentId)

func listen_to_document(documentPath: String) -> void:
	if _plugin_singleton:
		_plugin_singleton.firestoreListenToDocument(documentPath)

func query_documents(collection: String, filters: Array = [], order_by: String = "", order_descending: bool = false, limit_count: int = 0) -> void:
	if _plugin_singleton:
		_plugin_singleton.firestoreQueryDocuments(collection, filters, order_by, order_descending, limit_count)

func stop_listening_to_document(documentPath: String) -> void:
	if _plugin_singleton:
		_plugin_singleton.firestoreStopListeningToDocument(documentPath)
