class_name TabCommand extends Tabs


# Private constants

const __COMMAND = preload("res://source/components/command.tscn")
const __ERROR_TEXT = "A command with the name '%s' already exists."


# Private variables

onready var __button_add: Button = $_/container_add/button_add
onready var __container_commands: VBoxContainer = $_/container_commands/_/_
onready var __input_command: LineEdit = $_/container_add/input_command
onready var __label_error: Label = $_/container_add/label_error

var __data: DataTabCommand = null


# Lifecycle methods

func _ready() -> void:
	__button_add.connect("button_up", self, "__button_add_pressed")
	__input_command.connect("text_changed", self, "__input_command_text_changed")


# Public methods

func set_data(data: DataTabCommand) -> void:
	__data = data

	for command in data.commands:
		__command_add(command, true)


# Private methods

func __command_add(command: DataCommand, loading: bool = false) -> void:
	var instance: Command = __COMMAND.instance()
	instance.connect("deleted", self, "__command_remove", [instance])

	__container_commands.add_child(instance)

	if !loading:
		__data.commands.append(command)

	yield(get_tree(), "idle_frame") # TODO: Test if this is needed

	instance.set_data(command)


func __command_remove(command: Command) -> void:
	# TODO: Command buffer

	__container_commands.remove_child(command)

	var index: int = __data.commands.find(command.__data)
	if index != -1:
		__data.commands.remove(index)

	command.queue_free()


func __button_add_pressed() -> void:
	# TODO: Command buffer

	var command_new: DataCommand = DataCommand.new()
	command_new.text = __input_command.text

	# TODO: Add handling for text not being formatted correctly

	for command in __data.commands:
		if command.text == command_new.text:
			__button_add.disabled = true
			__label_error.text = __ERROR_TEXT % command_new.text
			__label_error.visible = true

			return

	__command_add(command_new)

	__button_add.disabled = true
	__input_command.text = ""


func __input_command_text_changed(text: String) -> void:
	__button_add.disabled = !text
	__label_error.visible = false

