extends Tabs


# Private constants

const __COMMAND_INSTANCE = preload("res://source/command.tscn")


# Private variables

onready var __commands: VBoxContainer = $container/scroll/commands
onready var __new: Button = $container/new
onready var __scroll: ScrollContainer = $container/scroll


# Lifecycle methods

func _ready() -> void:
	__new.connect("button_up", self, "__new_command")


# Private methods

func __new_command() -> void:
	var instance: Command = __COMMAND_INSTANCE.instance()
	instance.connect("deleted", __commands, "remove_child", [instance])

	__commands.add_child(instance)

	yield(get_tree(), "idle_frame")
	__scroll.ensure_control_visible(instance)
