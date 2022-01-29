class_name Command extends VBoxContainer


# Signals

signal deleted()


# Private constants

const __COMMAND_ACTION = preload("res://source/components/command_action.tscn")

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
onready var __option_execution: OptionButton = $container_command/container_command/_/option_execution

var __data: DataCommand = null


# Lifecycle methods

func _ready() -> void:
	__button_add.connect("button_up", self, "__button_add_pressed")
	__button_collapse.connect("button_up", self, "__button_collapse_pressed")
	__button_delete.connect("button_up", self, "__button_delete_pressed")


# Public methods

func set_data(data: DataCommand) -> void:
	__data = data

	# Nuts - c_onvulse
	DataLinker.link(__check_enabled, data, "enabled")
	DataLinker.link(__input_arguments, data, "argument_count")
	DataLinker.link(__label_command, data, "text")
	# I must go take a sh*t, i'll be back - c_onvulse
	DataLinker.link(__option_access, data, "access_type")
	# all this censorship is just like that book i never read, 1975 by jordan orwelp. f*ck! - TheYagich
	DataLinker.link(__option_execution, data, "execution_type")

	# TODO: Add tags

	for action in data.actions:
		__action_add(action, true)


# Private methods

func __action_add(action: DataCommandAction, loading: bool = false) -> void:
	var instance: CommandAction = __COMMAND_ACTION.instance()
	instance.connect("deleted", self, "__action_remove", [instance])

	__container_command_actions.add_child(instance)

	if !loading:
		__data.actions.append(action)
		Event.emit_signal("data_changed")

	__button_delete.visible = false

	yield(get_tree(), "idle_frame")

	instance.set_data(action)


func __action_remove(action: CommandAction) -> void:
	# TODO: Command buffer

	__container_command_actions.remove_child(action)

	var index: int = __data.actions.find(action.__data)
	if index != -1:
		__data.actions.remove(index)

	Event.emit_signal("data_changed")

	if __container_command_actions.get_child_count() == 0:
		__button_delete.visible = true

	action.queue_free()


func __button_add_pressed() -> void:
	# TODO: Command buffer

	__action_add(DataCommandAction.new())


func __button_collapse_pressed() -> void:
	__container_command_actions.visible = !__container_command_actions.visible

	var rotation: float = 0.0
	if !__container_command_actions.visible:
		rotation = -90.0

	__button_collapse.rect_rotation = rotation


func __button_delete_pressed() -> void:
	# TODO: Command buffer

	emit_signal("deleted")

# MY errors are pretty badass - Lil'Oni
