@tool
extends EditorPlugin

var export_plugin : AndroidExportPlugin

# Firebase plugin lines to inject into Gradle files
const BUILD_GRADLE_PLUGIN_LINE := "id 'com.google.gms.google-services'"
const SETTINGS_GRADLE_PLUGIN_LINE := "id 'com.google.gms.google-services' version '4.4.2' apply false"

const DEPENDENCIES := [
	"com.google.firebase:firebase-auth:23.2.0",
	"com.google.android.gms:play-services-auth:21.3.0",
	"com.google.firebase:firebase-firestore:25.1.4",
	"com.google.firebase:firebase-database:21.0.0",
	"com.google.firebase:firebase-storage:21.0.1"
]

func _enter_tree():
	export_plugin = AndroidExportPlugin.new()
	add_export_plugin(export_plugin)

func _exit_tree():
	remove_export_plugin(export_plugin)
	export_plugin = null

func _enable_plugin() -> void:
	add_autoload_singleton("Firebase", "res://addons/GodotFirebaseAndroid/Firebase.gd")

func _disable_plugin() -> void:
	remove_autoload_singleton("Firebase")
	_cleanup_gradle_files()

func _cleanup_gradle_files() -> void:
	_clean_line_from_file("res://android/build/build.gradle", BUILD_GRADLE_PLUGIN_LINE)
	_clean_line_from_file("res://android/build/settings.gradle", SETTINGS_GRADLE_PLUGIN_LINE)

func _clean_line_from_file(file_path: String, line_to_remove: String) -> void:
	if FileAccess.file_exists(file_path):
		var text := FileAccess.open(file_path, FileAccess.READ).get_as_text()
		text = text.replace(line_to_remove, "")
		var file := FileAccess.open(file_path, FileAccess.WRITE)
		file.store_string(text)
		file.close()


class AndroidExportPlugin extends EditorExportPlugin:
	var _plugin_name = "GodotFirebaseAndroid"
	
	func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
		if not features.has("android"):
			return
		
		if (not get_option("gradle_build/use_gradle_build")) or (not FileAccess.file_exists("res://android/build/google-services.json")):
			_clean_line_from_file("res://android/build/build.gradle", BUILD_GRADLE_PLUGIN_LINE)
			_clean_line_from_file("res://android/build/settings.gradle", SETTINGS_GRADLE_PLUGIN_LINE)
			return
		
		# Modify build.gradle and settings.gradle
		_insert_line_if_missing("res://android/build/build.gradle", "id 'org.jetbrains.kotlin.android'", BUILD_GRADLE_PLUGIN_LINE)
		_insert_line_if_missing("res://android/build/settings.gradle", "id 'org.jetbrains.kotlin.android' version versions.kotlinVersion", SETTINGS_GRADLE_PLUGIN_LINE)

	func _insert_line_if_missing(file_path: String, after_line: String, insert_line: String) -> void:
		var text := FileAccess.open(file_path, FileAccess.READ).get_as_text()
		if text.contains(insert_line):
			return
		
		var lines := text.split("\n")
		var result := PackedStringArray()
		var inserted := false
		
		for line in lines:
			result.append(line)
			if not inserted and line.strip_edges() == after_line.strip_edges():
				var indent := ""
				for c in line:
					if c == " " or c == "\t":
						indent += c
					else:
						break
				result.append(indent + insert_line)
				inserted = true
		
		var file := FileAccess.open(file_path, FileAccess.WRITE)
		file.store_string("\n".join(result))
		file.close()

	func _clean_line_from_file(file_path: String, line_to_remove: String) -> void:
		if FileAccess.file_exists(file_path):
			var text := FileAccess.open(file_path, FileAccess.READ).get_as_text()
			text = text.replace(line_to_remove, "")
			var file := FileAccess.open(file_path, FileAccess.WRITE)
			file.store_string(text)
			file.close()

	func _supports_platform(platform):
		if platform is EditorExportPlatformAndroid:
			return true
		return false

	func _get_android_libraries(platform, debug):
		if debug:
			return PackedStringArray([_plugin_name + "/bin/debug/" + _plugin_name + "-debug.aar"])
		else:
			return PackedStringArray([_plugin_name + "/bin/release/" + _plugin_name + "-release.aar"])

	func _get_android_dependencies(platform, debug):
		if debug:
			return PackedStringArray(DEPENDENCIES)
		else:
			return PackedStringArray(DEPENDENCIES)

	func _get_name():
		return _plugin_name
