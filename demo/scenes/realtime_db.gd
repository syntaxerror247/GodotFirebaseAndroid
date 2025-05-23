extends Control

@onready var path = $MarginContainer/VBoxContainer/HBoxContainer/path
@onready var pair_container = $ManageDataPanel/VBoxContainer/ScrollContainer/key_value_pair_container

func _ready() -> void:
	Firebase.realtimeDB.write_task_completed.connect(print_output.bind("write_task_completed"))
	Firebase.realtimeDB.get_task_completed.connect(print_output.bind("get_task_completed"))
	Firebase.realtimeDB.update_task_completed.connect(print_output.bind("update_task_completed"))
	Firebase.realtimeDB.delete_task_completed.connect(print_output.bind("delete_task_completed"))
	Firebase.realtimeDB.db_value_changed.connect(print_listner_output.bind("db_value_changed"))

func get_dictionary_from_inputs() -> Dictionary:
	var data_dict := Dictionary()
	for pair in pair_container.get_children():
		if pair.name == "sample_pair":
			continue
		var key = pair.get_child(0).text
		var value = pair.get_child(1).text
		if pair.get_child(2).button_pressed:
			value = int(value)
		data_dict[key] = value
	return data_dict

func print_output(arg, context: String):
	$MarginContainer/VBoxContainer/OutputPanel.text += context + ": " +str(arg) + "\n"

func print_listner_output(arg, arg2, context: String):
	$MarginContainer/VBoxContainer/OutputPanel.text += context + ": " +str(arg) + " -|- " +str(arg2) + "\n"


func _on_set_value_pressed() -> void:
	Firebase.realtimeDB.set_value(path.text, get_dictionary_from_inputs())


func _on_get_value_pressed() -> void:
	Firebase.realtimeDB.get_value(path.text)


func _on_update_value_pressed() -> void:
	Firebase.realtimeDB.update_value(path.text, get_dictionary_from_inputs())


func _on_delete_value_pressed() -> void:
	Firebase.realtimeDB.delete_value(path.text)


func _on_listen_to_path_pressed() -> void:
	Firebase.realtimeDB.listen_to_path(path.text)


func _on_stop_listening_pressed() -> void:
	Firebase.realtimeDB.stop_listening(path.text)



func _on_manage_data_pressed() -> void:
	$ManageDataPanel.show()


func _on_add_pair_pressed() -> void:
	var new_pair = $ManageDataPanel/VBoxContainer/ScrollContainer/key_value_pair_container/sample_pair.duplicate()
	new_pair.show()
	pair_container.add_child(new_pair)


func _on_close_pressed() -> void:
	$ManageDataPanel.hide()
