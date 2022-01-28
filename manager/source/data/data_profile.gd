class_name DataProfile extends Data


# Public variables

var name: String = "default"
var tab_command: DataTabCommand = DataTabCommand.new()


# Public methods

func copy(other: Data) -> void:
	name = other.name

	tab_command.copy(other.tab_command)
