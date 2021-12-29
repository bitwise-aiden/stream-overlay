extends Node

class Setting:
	# Public variables

	var path: String = ""
	var value = null setget __value_set, __value_get # variant


	# Lifecycle methods

	func _init(path, value) -> void:
		self.path = path
		self.value = value


	# Private methods

	func __value_get(): # variant
		return value


	func __value_set(value) -> void: # value: variant
		value = value


# Private constants

const __SETTINGS_PATH = "settings.json"


# Private variables

var __settings: Array = []
var __settings_default: Array = [
	{
		"name": "Default",
		"info": {
			"title": "",
			"notification": "",
			"category": "",
			"today": ""
		},
		"commands": [],
		"points": []
	}
]


# Lifecycle methods

func _ready() -> void:
	__settings = __settings_default

	if FileManager.file_exists(__SETTINGS_PATH):
		__settings = FileManager.load_json(__SETTINGS_PATH)
		Logger.info("Loading settings")
	else:
		FileManager.save_json(__SETTINGS_PATH, __settings)
		Logger.info("Creating settings")


# Public methods

func get_setting(name, default = null):
	var path: Array = name.split(".")
	var location: Array = __settings

	for index in range(path.size() - 1):
		var part: String = path[index]

		if location.has(part):
			location = location.get(part)
		else:
			Logger.warn("Could not get setting '%s'" % name)
			return default

	var setting_name: String = path[path.size() - 1]
	if location.has(setting_name):
		return location.get(setting_name)
	else:
		Logger.warn("Could not get setting '%s'" % name)
		return default


func save_settings() -> void:
	FileManager.save_json(__SETTINGS_PATH, __settings)


func set_setting(name: String, value, save: bool = false) -> void:
	__setting_changed(name, value)
	if save:
		save_settings()


# Private methods
func __setting_changed(name: String, value) -> void:
	var path: Array = name.split("/")
	var location: Dictionary = __settings

	for index in range(path.size() - 1):
		var part: String = path[index]

		if location.has(part):
			location = location.get(part)
		else:
			Logger.warn("Could not update setting '%s'" % name)
			return

	var setting_name: String = path[path.size() - 1]
	if location.has(setting_name):
		location[setting_name] = value
	else:
		Logger.warn("Could not update setting '%s'" % name)
		return
