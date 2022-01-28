class_name DataTabCommand extends Data


# Public variables

var commands: Array = []


# Public methods

func copy(other: Data) -> void:
	commands = []
	for command in other.commands:
		var new_command: DataCommand = DataCommand.new()
		new_command.copy(command)

		commands.append(new_command)
