extends Node

signal upload_task_completed(result: Dictionary)
signal download_task_completed(result: Dictionary)
signal delete_task_completed(result: Dictionary)
signal list_task_completed(result: Dictionary)

var _plugin_singleton: Object

func _connect_signals():
	if not _plugin_singleton:
		return
	_plugin_singleton.connect("storage_upload_task_completed", upload_task_completed.emit)
	_plugin_singleton.connect("storage_download_task_completed", download_task_completed.emit)
	_plugin_singleton.connect("storage_delete_task_completed", delete_task_completed.emit)
	_plugin_singleton.connect("storage_list_task_completed", list_task_completed.emit)

func upload_file(path: String, localFilePath: String) -> void:
	if _plugin_singleton:
		_plugin_singleton.storageUploadFile(path, localFilePath)

func download_file(path: String, destinationPath: String) -> void:
	if _plugin_singleton:
		_plugin_singleton.storageDownloadFile(path, destinationPath)

func get_download_url(path: String) -> void:
	if _plugin_singleton:
		_plugin_singleton.storageGetDownloadUrl(path)

func get_metadata(path: String) -> void:
	if _plugin_singleton:
		_plugin_singleton.storageGetMetadata(path)

func delete_file(path: String) -> void:
		if _plugin_singleton:
			_plugin_singleton.storageDeleteFile(path)

func list_files(path: String) -> void:
	if _plugin_singleton:
		_plugin_singleton.storageListFiles(path)
