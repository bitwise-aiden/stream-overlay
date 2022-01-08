extends TextEdit

# Private constants

const __BASE_SOURCE_CODE = "func handle(state: Dictionary) -> void:\n\t%s"


# Private variables

var __timer_debounce: Timer = null


# Lifecycle methods

func _init() -> void:
	pass

func _ready():
	__timer_debounce = Timer.new()
	__timer_debounce.one_shot = true
	__timer_debounce.connect("timeout", self, "__check_code")
	add_child(__timer_debounce)

	connect("text_changed", self, "__input_code_text_changed")


# Private methods

func __check_code() -> void:
	var raw_code: String = text.replace("\n", "\n\t")
	var code: String = __BASE_SOURCE_CODE % raw_code

	var script: GDScript = GDScript.new()
	script.set_source_code(code)

	var thread: Thread = Thread.new()
	thread.start(self, "__reload_script", script)

	var error: int = thread.wait_to_finish()


func __input_code_text_changed() -> void:
	self.__timer_debounce.start(0.5)


func __reload_script(script: GDScript) -> int:
	return script.reload()
