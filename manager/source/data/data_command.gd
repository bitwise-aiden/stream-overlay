class_name DataCommand extends Data


# Public variables

var access_type: int = 0
var actions: Array = []
var argument_count: int = 0
var collapsed: bool = false
var text: String = ""
var enabled: bool = true
var execution_type: int = 0
var tags: Array = []


# Public methods

func copy(other: Data) -> void:
	access_type = other.access_type
	argument_count = other.argument_count
	collapsed = other.collapsed
	text = other.text
	enabled = other.enabled
	execution_type = other.execution_type
	tags = other.tags

	actions = []
	for action in other.actions:
		var new_action: DataCommandAction = DataCommandAction.new()
		new_action.copy(action)

		actions.append(new_action)
