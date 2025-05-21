extends Node

signal write_task_completed(result: Dictionary)
signal get_task_completed(result: Dictionary)
signal update_task_completed(result: Dictionary)
signal delete_task_completed(result: Dictionary)
signal db_value_changed(path: String, data: Dictionary)

var _plugin_singleton: Object

func _connect_signals():
	if not _plugin_singleton:
		return
	_plugin_singleton.connect("realtime_write_task_completed", write_task_completed.emit)
	_plugin_singleton.connect("realtime_get_task_completed", get_task_completed.emit)
	_plugin_singleton.connect("realtime_update_task_completed", update_task_completed.emit)
	_plugin_singleton.connect("realtime_delete_task_completed", delete_task_completed.emit)
	_plugin_singleton.connect("realtime_db_value_changed", db_value_changed.emit)

func set_value(path: String, data: Dictionary) -> void:
	if _plugin_singleton:
		_plugin_singleton.rtdbSetValue(path, data)

func get_value(path: String) -> void:
	if _plugin_singleton:
		_plugin_singleton.rtdbGetValue(path)

func update_value(path: String, data: Dictionary) -> void:
		if _plugin_singleton:
			_plugin_singleton.rtdbUpdateValue(path, data)

func delete_value(path: String) -> void:
	if _plugin_singleton:
		_plugin_singleton.rtdbDeleteValue(path)

func listen_to_path(path: String) -> void:
	if _plugin_singleton:
		_plugin_singleton.rtdbListenToPath(path)

func stop_listening(path: String) -> void:
	if _plugin_singleton:
		_plugin_singleton.rtdbStopListening(path)
