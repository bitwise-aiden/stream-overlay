extends Tabs


# Private variables

onready var __button_start: Button = $container_stream/button_start


# Lifecycle methods

func _ready() -> void:
	__button_start.connect("button_up", self, "__button_start_pressed")


# Private methods

func __button_start_pressed() -> void:
	ChatBot.start()
