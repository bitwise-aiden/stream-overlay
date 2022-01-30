extends Node


# Private variables

var __commands: Array = []
var __index: int = -1


# Lifecycle methods

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("redo"):
		print("redo")
		__redo()

	if Input.is_action_just_pressed("undo"):
		print("undo")
		__undo()


# Public methods

func add(perform: FuncRef, perform_args: Array, undo: FuncRef, undo_args: Array, metadata: Object = null) -> void:
	print(__commands.size())
	__clear_from(__index)
	print(__commands.size())

	var action: Action = Action.new(perform, perform_args, undo, undo_args, metadata)
	action.perform()

	__commands.append(action)

	__index += 1
	print(__index)


func clear() -> void:
	__commands.clear()
	__index = -1


# Private methods

func __clear_from(index: int) -> void:
	__commands.slice(0, index)
	__index = index


func __redo() -> void:
	var next_index: int = __index + 1

	if next_index >= __commands.size():
		__index = __commands.size() - 1
		return

	__index = next_index

	if !__commands[__index].perform():
		__clear_from(__index - 1)


func __undo() -> void:
	if __index < 0:
		__index = -1
		return

	if __commands[__index].undo():
		__index -= 1
	else:
		clear()
