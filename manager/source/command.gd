class_name Command extends Panel


# Signals

signal deleted()



# Private variables

onready var __access: OptionButton = $container/access
onready var __code: TextEdit = $code_popup/code_content
onready var __command: LineEdit = $container/command_content
onready var __delete: TextureButton = $container/delete
onready var __enabled: CheckBox = $container/enabled
onready var __open_code: Button = $container/code
onready var __popup: PopupDialog = $code_popup
onready var __response: LineEdit = $container/response_content
onready var __type: OptionButton = $container/type


# Lifecycle methods

func _ready() -> void:
	__type.connect("item_selected", self, "__type_changed")
	__open_code.connect("button_up", __popup, "popup_centered")
	__delete.connect("button_up", self, "emit_signal", ["deleted"])


# Private methods

func __type_changed(value: int) -> void:
	__response.visible = value == 0
	__open_code.visible = value == 1
