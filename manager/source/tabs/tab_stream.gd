extends Tabs


# Private variables

onready var __button_start: Button = $container_stream/container_controls/button_start
onready var __edit_channel: LineEdit = $container_stream/container_controls/edit_channel
onready var __edit_token: LineEdit = $container_stream/container_controls/edit_token


# Lifecycle methods

func _ready() -> void:
	__button_start.connect("button_up", self, "__button_start_pressed")


# Private methods

func __button_start_pressed() -> void:
	var channel: String = __edit_channel.text
	var token: String = __edit_token.text
	
	ChatBot.start(
		channel,
		token
	)
