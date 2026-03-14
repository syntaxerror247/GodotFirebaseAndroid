extends Node

signal fetch_completed(result: Dictionary)

var _plugin_singleton: Object

func _connect_signals():
	if not _plugin_singleton:
		return
	_plugin_singleton.connect("remote_config_fetch_completed", fetch_completed.emit)

func initialize() -> void:
	if _plugin_singleton:
		_plugin_singleton.remoteConfigInitialize()

func set_defaults(defaults: Dictionary) -> void:
	if _plugin_singleton:
		_plugin_singleton.remoteConfigSetDefaults(defaults)

func fetch_and_activate() -> void:
	if _plugin_singleton:
		_plugin_singleton.remoteConfigFetchAndActivate()

func get_string(key: String) -> String:
	var value := ""
	if _plugin_singleton:
		value = _plugin_singleton.remoteConfigGetString(key)
	return value

func get_bool(key: String) -> bool:
	var value := false
	if _plugin_singleton:
		value = _plugin_singleton.remoteConfigGetBoolean(key)
	return value

func get_int(key: String) -> int:
	var value := 0
	if _plugin_singleton:
		value = _plugin_singleton.remoteConfigGetLong(key)
	return value

func get_float(key: String) -> float:
	var value := 0.0
	if _plugin_singleton:
		value = _plugin_singleton.remoteConfigGetDouble(key)
	return value
