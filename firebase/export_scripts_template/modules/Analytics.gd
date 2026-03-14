extends Node

var _plugin_singleton: Object

func _connect_signals():
	pass

func log_event(name: String, parameters: Dictionary) -> void:
	if _plugin_singleton:
		_plugin_singleton.analyticsLogEvent(name, parameters)

func set_user_property(name: String, value: String) -> void:
	if _plugin_singleton:
		_plugin_singleton.analyticsSetUserProperty(name, value)

func set_user_id(id: String) -> void:
	if _plugin_singleton:
		_plugin_singleton.analyticsSetUserId(id)

func set_analytics_collection_enabled(enabled: bool) -> void:
	if _plugin_singleton:
		_plugin_singleton.analyticsSetAnalyticsCollectionEnabled(enabled)

func reset_analytics_data() -> void:
	if _plugin_singleton:
		_plugin_singleton.analyticsResetAnalyticsData()
