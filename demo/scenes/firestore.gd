extends Control

@onready var collection = $MarginContainer/VBoxContainer/HBoxContainer/collection
@onready var docID = $MarginContainer/VBoxContainer/HBoxContainer/docID
@onready var pair_container = $ManageDataPanel/VBoxContainer/ScrollContainer/key_value_pair_container

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().change_scene_to_packed(load("res://main.tscn"))


func _ready() -> void:
	Firebase.firestore.write_task_completed.connect(print_output.bind("write_task_completed"))
	Firebase.firestore.get_task_completed.connect(print_output.bind("get_task_completed"))
	Firebase.firestore.update_task_completed.connect(print_output.bind("update_task_completed"))
	Firebase.firestore.delete_task_completed.connect(print_output.bind("delete_task_completed"))
	Firebase.firestore.document_changed.connect(print_listner_output.bind("document_changed"))


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


func _on_add_document_pressed() -> void:
	Firebase.firestore.add_document(collection.text, get_dictionary_from_inputs())


func _on_set_document_pressed() -> void:
	Firebase.firestore.set_document(collection.text, docID.text, get_dictionary_from_inputs(), $MarginContainer/VBoxContainer/HBoxContainer2/merge.button_pressed)


func _on_get_document_pressed() -> void:
	Firebase.firestore.get_document(collection.text, docID.text)


func _on_get_documents_in_collection_pressed() -> void:
	Firebase.firestore.get_documents_in_collection(collection.text)


func _on_update_document_pressed() -> void:
	Firebase.firestore.update_document(collection.text, docID.text, get_dictionary_from_inputs())


func _on_delete_document_pressed() -> void:
	Firebase.firestore.delete_document(collection.text, docID.text)


func _on_listen_to_document_pressed() -> void:
	Firebase.firestore.listen_to_document(collection.text+"/"+docID.text)


func _on_stop_listening_to_document_pressed() -> void:
	Firebase.firestore.stop_listening_to_document(collection.text+"/"+docID.text)



func _on_manage_data_pressed() -> void:
	$ManageDataPanel.show()


func _on_add_pair_pressed() -> void:
	var new_pair = $ManageDataPanel/VBoxContainer/ScrollContainer/key_value_pair_container/sample_pair.duplicate()
	new_pair.show()
	pair_container.add_child(new_pair)
	pass


func _on_close_pressed() -> void:
	$ManageDataPanel.hide()
