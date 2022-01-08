class_name CommandAction extends Control


# Signals

signal deleted()


# Private variables

onready var __button_code: Button = $container_action/button_code
onready var __button_delete: TextureButton = $container_action/button_delete
onready var __input_code: TextEdit = $popup_code/input_code
onready var __input_signal: LineEdit = $container_action/input_signal
onready var __input_static: LineEdit = $container_action/input_static
onready var __option_type: OptionButton = $container_action/option_type
onready var __popup_code: PopupDialog = $popup_code # TODO: Swap - drusiform

onready var __type_inputs: Array = [
	__input_static,
	__button_code,
	__input_signal,
]

var __data: DataCommandAction = null

# I've hidden a cake somewhere in your code. - Lil'Oni
# Lifecycle methods

func _ready() -> void:
	__button_delete.connect("button_up", self, "emit_signal", ["deleted"])
	__button_code.connect("button_up", __popup_code, "popup_centered")
	__option_type.connect("item_selected", self, "__option_type_item_selected")


# Public methods

func set_data(data: DataCommandAction) -> void:
	__data = data

	__input_code.text = data.action_code

	__input_signal.text = data.action_signal
	__input_static.text = data.action_static
	__option_type.selected = data.type


# Private methods

func __option_type_item_selected(value: int) -> void:
	for index in __type_inputs.size():
		__type_inputs[index].visible = index == value

