extends Control

var auth = load("res://scenes/authentication.tscn")
var firestore = load("res://scenes/firestore.tscn")
var realtimeDB = load("res://scenes/realtime_db.tscn")
var storage = load("res://scenes/storage.tscn")

func _on_auth_pressed() -> void:
	get_tree().change_scene_to_packed(auth)


func _on_firestore_pressed() -> void:
	get_tree().change_scene_to_packed(firestore)


func _on_realtime_db_pressed() -> void:
	get_tree().change_scene_to_packed(realtimeDB)


func _on_storage_pressed() -> void:
	get_tree().change_scene_to_packed(storage)
