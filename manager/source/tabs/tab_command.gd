extends Tabs


# Private constants

const __COMMAND = preload("res://source/components/command.tscn")
const __ERROR_TEXT = "A command with the name '%s' already exists."


# Private variables

onready var __button_add: Button = $_/container_add/button_add
onready var __container_content: VBoxContainer = $_/container_content/_/_
onready var __input_command: LineEdit = $_/container_add/input_command
onready var __label_error: Label = $_/container_add/label_error


# Lifecycle methods

func _ready() -> void:
	__button_add.connect("button_up", self, "__button_add_pressed")
	__input_command.connect("text_changed", self, "__input_command_text_changed")


# Private methods

func __button_add_pressed() -> void:
	var command_text: String = __input_command.text

	# TODO: Add handling for text not being formatted correctly

	for command in __container_content.get_children():
		if command_text == command.command:
			__button_add.disabled = true
			__label_error.text = __ERROR_TEXT % command_text
			__label_error.visible = true

			return

	__button_add.disabled = true
	__input_command.text = ""

	var instance: Command = __COMMAND.instance()
	instance.command = command_text

	__container_content.add_child(instance)


func __input_command_text_changed(text: String) -> void:
	__button_add.disabled = !text
	__label_error.visible = false
