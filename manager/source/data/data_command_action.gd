class_name DataCommandAction extends Data


# Public variables

var action_code: String = ""
var action_signal: String = ""
var action_static: String = ""
var type: int = 0


# Public methods

func copy(other: Data) -> void:
	action_code = other.action_code
	action_signal = other.action_signal
	action_static = other.action_static
	type = other.type
