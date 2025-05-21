extends Node

var auth = preload("res://addons/GodotFirebaseAndroid/modules/Auth.gd").new()
var firestore = preload("res://addons/GodotFirebaseAndroid/modules/Firestore.gd").new()
var realtimeDB = preload("res://addons/GodotFirebaseAndroid/modules/RealtimeDB.gd").new()
var storage = preload("res://addons/GodotFirebaseAndroid/modules/Storage.gd").new()

func _ready() -> void:
	if Engine.has_singleton("GodotFirebaseAndroid"):
		var _plugin_singleton = Engine.get_singleton("GodotFirebaseAndroid")
	
		auth._plugin_singleton = _plugin_singleton
		auth._connect_signals()
		
		firestore._plugin_singleton = _plugin_singleton
		firestore._connect_signals()
		
		realtimeDB._plugin_singleton = _plugin_singleton
		realtimeDB._connect_signals()
		
		storage._plugin_singleton = _plugin_singleton
		storage._connect_signals()
	else:
		if not OS.has_feature("editor"):
			printerr("GodotFirebaseAndroid singleton not found!")
		return
	
