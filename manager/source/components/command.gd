class_name Command extends VBoxContainer


# Signals

signal deleted()


# Private constants

const __COMMAND_ACTION = preload("res://source/components/command_action.tscn")


# Public variables

var command: String = "" setget __command_set, __command_get


# Private variables

onready var __button_add: TextureButton = $container_command/container_actions/button_add
onready var __button_collapse: TextureButton = $container_command/container_command/_/button_collapse
onready var __button_delete: TextureButton = $container_command/container_actions/button_delete
onready var __button_tags: Button = $container_command/container_command/_/button_tags
onready var __check_enabled: CheckBox = $container_command/container_command/_/check_enabled
onready var __container_command_actions:VBoxContainer = $container_command_actions
onready var __input_arguments: SpinBox = $container_command/container_command/_/input_arguments
onready var __label_command: Label = $container_command/container_command/_/label_command
onready var __option_access: OptionButton = $container_command/container_command/_/option_access
onready var __option_type: OptionButton = $container_command/container_command/_/option_type


# Lifecycle methods

func _ready() -> void:
	self.command = command

	__button_add.connect("button_up", self, "__button_add_pressed")
	__button_collapse.connect("button_up", self, "__button_collapse_pressed")
	__button_delete.connect("button_up", self, "__button_delete_pressed")


# Private methods

func __button_add_pressed() -> void:
	# TODO: Command buffer

	var instance: CommandAction = __COMMAND_ACTION.instance()
	instance.connect("deleted", self, "__callback_command_action_deleted", [instance])

	__container_command_actions.add_child(instance)

	__button_delete.visible = false


func __button_collapse_pressed() -> void:
	__container_command_actions.visible = !__container_command_actions.visible

	var rotation: float = 0.0
	if !__container_command_actions.visible:
		rotation = -90.0

	__button_collapse.rect_rotation = rotation


func __button_delete_pressed() -> void:
	# TODO: Command buffer

	emit_signal("deleted")

	queue_free()


func __callback_command_action_deleted(command_action: CommandAction) -> void:
	# TODO: Command buffer

	__container_command_actions.remove_child(command_action)

	if __container_command_actions.get_child_count() == 0:
		__button_delete.visible = true

	command_action.queue_free()


func __command_get() -> String:
	return command
# MY errors are pretty badass - Lil'Oni


func __command_set(value: String) -> void:
	command = value

	if __label_command:
		__label_command.text = value
