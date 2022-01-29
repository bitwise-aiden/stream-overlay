class_name CodeRunner

# Private varaible

var __function_template: String = ""


# Lifecylce methods

func _init(function_signature: String) -> void: # Hi. I got cake. And everything except for water to drink.  - Lil'Oni
	__function_template = "%s:\n\t%%s" % function_signature


# Public methods

func compile(code: String) -> Reference:
	var formatted_code: String = code
	formatted_code = formatted_code.replace("\n", "\n\t")
	formatted_code = __function_template % formatted_code

	print(formatted_code)

	var script: GDScript = GDScript.new()
	script.set_source_code(formatted_code)
	script.reload()

	var thread: Thread = Thread.new()
	thread.start(self, "__reload_script", script)

	var error: int = thread.wait_to_finish()
	if error != 0:
		print("Couldn't load code!", error)
		return null

	var reference: Reference = Reference.new()
	reference.set_script(script)

	return reference


func __reload_script(script: GDScript) -> int:
	return script.reload()
