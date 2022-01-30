class_name Action


# Private methods

var __metadata: Object
var __perform: FuncRef
var __perform_args: Array
var __undo: FuncRef
var __undo_args


# Lifecycle

func _init(perform: FuncRef, perform_args: Array, undo: FuncRef, undo_args: Array, metadata: Object = null) -> void:
	__metadata = metadata
	__perform = perform
	__perform_args = perform_args
	__undo = undo
	__undo_args = undo_args


# Public methods

func perform() -> bool:
#	if !__perform.is_valid():
#		return false

	__perform.call_funcv(__perform_args)
	return true


func undo() -> bool:
	if !__undo.is_valid():
		return false

	__undo.call_funcv(__undo_args)
	return true
