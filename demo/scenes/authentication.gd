extends Control

@onready var output_panel = $MarginContainer/VBoxContainer/OutputPanel

@onready var email = $MarginContainer/VBoxContainer/LineEdit
@onready var password = $MarginContainer/VBoxContainer/LineEdit2

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().change_scene_to_packed(load("res://main.tscn"))


func _ready() -> void:
	Firebase.auth.auth_success.connect(print_output.bind("auth_success"))
	Firebase.auth.auth_failure.connect(print_output.bind("auth_failure"))
	Firebase.auth.sign_out_success.connect(print_output.bind("sign_out_success"))

func print_output(arg, context: String):
	output_panel.text += context + ": " +str(arg) + "\n"


func _on_anonymous_sign_in_pressed() -> void:
	Firebase.auth.sign_in_anonymously()


func _on_email_sign_up_pressed() -> void:
	Firebase.auth.create_user_with_email_password(email.text, password.text)


func _on_email_sign_in_pressed() -> void:
	Firebase.auth.sign_in_with_email_password(email.text, password.text)


func _on_google_sign_in_pressed() -> void:
	Firebase.auth.sign_in_with_google()


func _on_get_user_data_pressed() -> void:
	print_output(Firebase.auth.get_current_user_data(), "Current User Data")


func _on_is_signed_in_pressed() -> void:
	print_output(Firebase.auth.is_signed_in(),"Is SignedIn")


func _on_sign_out_pressed() -> void:
	Firebase.auth.sign_out()


func _on_delete_user_pressed() -> void:
	Firebase.auth.delete_current_user()
