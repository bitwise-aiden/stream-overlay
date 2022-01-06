extends PopupDialog


onready var input_code: TextEdit = $input_code

func _ready():
	connect("popup_hide", self, "__run")


const BASE_SOURCE_CODE = "func handle(state: Dictionary) -> void:\n\t%s"


func __reload_script(script: GDScript) -> int:
	return script.reload()


func __run() -> void:
	var raw_code: String = input_code.text.replace("\n", "\n\t")
	var code: String = BASE_SOURCE_CODE % raw_code

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
