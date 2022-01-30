class_name DialogProfileName extends ConfirmationDialog


# Private variables

onready var __input_name: LineEdit = $input_name


# Lifecycle methods

func _ready() -> void:
	register_text_enter(__input_name)


# Public methods

func get_profile_name() -> String:
	popup_centered(rect_min_size)
	__input_name.grab_focus()

	yield(self, "popup_hide")

	# warning-ignore:function-may-yield
	var wait: GDScriptFunctionState = __wait_for_confirmed()

	yield(get_tree(), "idle_frame")

	if wait.is_valid():
		wait.resume()
		return ""

	var name: String = __input_name.text
	__input_name.text = ""

	return name


# Private methods

func __wait_for_confirmed() -> void:
	yield(self, "confirmed")
