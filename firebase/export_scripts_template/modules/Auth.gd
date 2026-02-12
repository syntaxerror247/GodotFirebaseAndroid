extends Node

signal auth_success(current_user_data: Dictionary)
signal auth_failure(error_message: String)
signal link_with_google_success(current_user_data: Dictionary)
signal link_with_google_failure(error_message: String)
signal sign_out_success(success: bool)
signal password_reset_sent(success: bool)
signal email_verification_sent(success: bool)
signal user_deleted(success: bool)

var _plugin_singleton: Object

func _connect_signals():
	if not _plugin_singleton:
		return
	_plugin_singleton.connect("auth_success", auth_success.emit)
	_plugin_singleton.connect("auth_failure", auth_failure.emit)
	_plugin_singleton.connect("link_with_google_success", link_with_google_success.emit)
	_plugin_singleton.connect("link_with_google_failure", link_with_google_failure.emit)
	_plugin_singleton.connect("sign_out_success", sign_out_success.emit)
	_plugin_singleton.connect("password_reset_sent", password_reset_sent.emit)
	_plugin_singleton.connect("email_verification_sent", email_verification_sent.emit)
	_plugin_singleton.connect("user_deleted", user_deleted.emit)

func sign_in_anonymously() -> void:
	if _plugin_singleton:
		_plugin_singleton.signInAnonymously()

func create_user_with_email_password(email: String, password: String) -> void:
		if _plugin_singleton:
			_plugin_singleton.createUserWithEmailPassword(email, password)

func sign_in_with_email_password(email: String, password: String) -> void:
	if _plugin_singleton:
		_plugin_singleton.signInWithEmailPassword(email, password)

func send_password_reset_email(email: String) -> void:
	if _plugin_singleton:
		_plugin_singleton.sendPasswordResetEmail(email)

func send_email_verification() -> void:
	if _plugin_singleton:
		_plugin_singleton.sendEmailVerification()

func sign_in_with_google() -> void:
	if _plugin_singleton:
		_plugin_singleton.signInWithGoogle()

func link_anonymous_with_google() -> void:
	if _plugin_singleton:
		_plugin_singleton.linkAnonymousWithGoogle()

func get_current_user_data() -> Dictionary:
	var user_data: Dictionary
	if _plugin_singleton:
		user_data = _plugin_singleton.getCurrentUser()
	return user_data

func delete_current_user() -> void:
	if _plugin_singleton:
		_plugin_singleton.deleteUser()

func is_signed_in() -> bool:
	var status := false
	if _plugin_singleton:
		status = _plugin_singleton.isSignedIn()
	return status

func sign_out() -> void:
	if _plugin_singleton:
		_plugin_singleton.signOut()
