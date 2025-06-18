extends Control

@onready var output_panel = $MarginContainer/VBoxContainer/OutputPanel

@onready var download_path = $MarginContainer/VBoxContainer/LineEdit2
@onready var cloud_storage_path = $MarginContainer/VBoxContainer/LineEdit3

var selected_image_path: String

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().change_scene_to_packed(load("res://main.tscn"))

func _ready() -> void:
	Firebase.storage.upload_task_completed.connect(print_output.bind("upload_task_completed"))
	Firebase.storage.download_task_completed.connect(print_output.bind("download_task_completed"))
	Firebase.storage.delete_task_completed.connect(print_output.bind("delete_task_completed"))
	Firebase.storage.list_task_completed.connect(print_output.bind("list_task_completed"))
	OS.request_permissions()

func _on_get_image_path_pressed() -> void:
	$FileDialog.popup()

func print_output(arg, context: String):
	$MarginContainer/VBoxContainer/OutputPanel.text += context + ": " +str(arg) + "\n"


func _on_upload_file_pressed() -> void:
	Firebase.storage.upload_file(cloud_storage_path.text, selected_image_path)


func _on_download_file_pressed() -> void:
	Firebase.storage.download_file(cloud_storage_path.text, ProjectSettings.globalize_path(download_path.text))


func _on_get_metadata_pressed() -> void:
	Firebase.storage.get_metadata(cloud_storage_path.text)


func _on_delete_file_pressed() -> void:
	Firebase.storage.delete_file(cloud_storage_path.text)


func _on_list_files_pressed() -> void:
	Firebase.storage.list_files(cloud_storage_path.text)


func _on_file_dialog_file_selected(path: String) -> void:
	print(path)
	selected_image_path = path


func _on_download_url_pressed() -> void:
	Firebase.storage.get_download_url(cloud_storage_path.text)
