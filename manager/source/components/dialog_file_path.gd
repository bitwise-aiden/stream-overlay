class_name DialogFilePath extends FileDialog


# Lifecycle methods

func _ready() -> void:
	add_filter("*.json ; JSON file")
	set_access(FileDialog.ACCESS_FILESYSTEM)


# Public methods

func get_file_path(open: bool) -> String:
	if open:
		set_mode(FileDialog.MODE_OPEN_FILE)
	else:
		set_mode(FileDialog.MODE_SAVE_FILE)

	popup_centered()
#
	__wait_for_popup_hide()

	var file_path: String = yield(self, "file_selected")

	current_file = ""

	return file_path


# Private methods

func __wait_for_popup_hide() -> void:
	yield(self, "popup_hide")
	emit_signal("file_selected", "")
