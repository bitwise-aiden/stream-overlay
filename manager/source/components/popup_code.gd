extends PopupDialog

# Private constants

const __BASE_SOURCE_CODE = "func handle(state: Dictionary) -> void:\n\t%s"

# Private variables

onready var __input_code: TextEdit = $input_code

var __timer_debounce: Timer = null


# Lifecycle methods

func _ready():
	__timer_debounce = Timer.new()
	__timer_debounce.one_shot = true
	__timer_debounce.connect("timeout", self, "__check_code")
	add_child(__timer_debounce)

	__input_code.connect("text_changed", self, "__input_code_text_changed")
	connect("popup_hide", self, "__run")


# Private methods

func __check_code() -> void:
	var raw_code: String = __input_code.text.replace("\n", "\n\t")
	var code: String = __BASE_SOURCE_CODE % raw_code

	var script: GDScript = GDScript.new()
	script.set_source_code(code)

	var thread: Thread = Thread.new()
	thread.start(self, "__reload_script", script)

	var error: int = thread.wait_to_finish()
	print(error) # TODO: Show error to user


func __input_code_text_changed() -> void:
	self.__timer_debounce.start(0.5)


func __reload_script(script: GDScript) -> int:
	return script.reload()


func __run() -> void:
	var raw_code: String = __input_code.text.replace("\n", "\n\t")
	var code: String = __BASE_SOURCE_CODE % raw_code

	var script: GDScript = GDScript.new()
	script.set_source_code(code)

	var thread: Thread = Thread.new()
	thread.start(self, "__reload_script", script)

	var error: int = thread.wait_to_finish()
	if error != 0:
		print(error)
		return

	var resource: Resource = Resource.new()
	resource.set_script(script)

	resource.handle({"a": 1, "b": 2})
