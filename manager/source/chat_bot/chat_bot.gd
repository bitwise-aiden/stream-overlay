extends Node

# Private constants

const __FUNCTION_SIGNATURE: String = "func handle(client: Gift, user: String, params: Array) -> void"

# Private variable

var __twitch: Gift
var __command_data: Array = []
var __code_runner: CodeRunner = CodeRunner.new(__FUNCTION_SIGNATURE)


# Lifecycle methods

func _process(delta: float) -> void:
	if __twitch:
		__twitch.process(delta)


# Public method

func start() -> bool:
	__twitch = Gift.new()

	var channel = OS.get_environment("VELOPBOT_CHANNEL")
	var token = OS.get_environment("VELOPBOT_TOKEN")

	__twitch.connect("chat_message", self, "__chat_message")

	__twitch.connect_to_twitch()
	yield(__twitch, "twitch_connected")

	__twitch.authenticate_oauth("TheYagich", token)
	if(yield(__twitch, "login_attempt") == false):
		print("Invalid token.") # TODO: Update to logger
		return false
	__twitch.join_channel(channel)

	return true


func set_command_data(data: Array) -> void:
	self.__command_data = data


# Private methods

func __chat_message(sender: SenderData, message: String, channel: String) -> void:
	print(sender.tags)

	# TODO: Update case for when someone sends a message
	if !message.begins_with("!"):
		return

	var message_parts: PoolStringArray = message.split(" ")
	var incoming_command: String = message_parts[0]
	message_parts.remove(0)

	for command_data in __command_data:
		if command_data.text == incoming_command && command_data.enabled:
			if __has_permission(sender, command_data):
				__handle_command(command_data, sender.user, message_parts)
			break


func __handle_action(action_data: DataCommandAction, user: String, params: Array) -> void:
	match action_data.type:
		0:
			# TODO: Add regex for any {__VALUE__} params
			__twitch.chat(action_data.action_static.replace("{user}", user))
		1:
			var code: Reference = __code_runner.compile(action_data.action_code)
			if !code:
				return

			code.handle(__twitch, user, params)


func __handle_command(command_data: DataCommand, user: String, params: Array) -> void:
	match command_data.execution_type:
		0:
			for action_data in command_data.actions:
				__handle_action(action_data, user, params)
		1:
			var action_index: int = randi() % command_data.actions.size()
			var action_data: DataCommandAction = command_data.actions[action_index]
			__handle_action(action_data, user, params)


func __has_permission(sender: SenderData, command_data: DataCommand) -> bool:
	# TODO: Don't hardcode streamer
	if sender.user == "velopman":
		return true

	match command_data.access_type:
		0: # All
			return true
		1: # Subscriber
			return sender.tags["subscriber"] == "1"
		2: # Moderator
			return sender.tags["mod"] == "1"

	return false

