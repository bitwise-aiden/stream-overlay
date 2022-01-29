extends Control


# Private constants

const __PATH_SETTING: String = "setting"


# Private variables

onready var __dialog_file_path: FileDialog = $dialog_file_path
onready var __dialog_profile_name: ConfirmationDialog = $dialog_profile_name
onready var __menu_file: PopupMenu = $container_content/container_menu/file.get_popup()
onready var __menu_profile: PopupMenu = $container_content/container_menu/profile.get_popup()
onready var __tab_command: TabCommand = $container_content/tabs_content/Command

var __data_application: DataApplication
var __data_profile: DataProfile
var __profile_names: Array = []


# Lifecycle methods

func _ready() -> void:
	__data_application = __load_application()
	__data_profile = ProfileManager.load_profile(__data_application.profile)
	__profile_names = FileManager.files_in_directory("profiles")

	if __data_application.profile != __data_profile.name:
		# TODO: Show error as profile is missing

		__data_application.profile = __data_profile.name
		__save_application()

	__tab_command.set_data(__data_profile.tab_command)

	ChatBot.set_command_data(__data_profile.tab_command.commands)

	Event.connect("data_changed", self, "__data_changed")

	__menu_profile.connect("id_pressed", self, "__button_profile_pressed")



func _exit_tree() -> void:
	__save_application()
	ProfileManager.save_profile(__data_profile)


# Private methods

func __button_profile_pressed(id: int) -> void:
	var load_profile: DataProfile = null

	ProfileManager.save_profile(__data_profile)

	match id:
		0, 1, 2:
			var profile_name: String = yield(__dialog_profile_name.get_profile_name(), "completed")

			# TODO: Handle existing file names
			if !profile_name:
				return

			match id:
				0:
					load_profile = ProfileManager.create_profile(profile_name)
				1:
					load_profile = ProfileManager.duplicate_profile(profile_name, __data_profile)
				2:
					ProfileManager.rename_profile(profile_name, __data_profile)
					load_profile = __data_profile
		3:
			ProfileManager.delete_profile(__data_profile)
			load_profile = ProfileManager.load_profile("default")
		4, 5:
			var file_path: String = yield(__dialog_file_path.get_file_path(id == 4), "completed")

			# TODO: Handle if file isn't json
			if !file_path:
				return

			match id:
				4:
					var json: Dictionary = FileManager.load_json(file_path)
					Data.from_json(json)
				5:
					var json: Dictionary = __data_profile.json()
					FileManager.save_json(file_path, json)
		6:
			pass # ignore
		7:
			pass

	if !load_profile:
		return

	__data_profile = load_profile
	__data_application.profile = load_profile.name

	get_tree().reload_current_scene()


func __data_changed() -> void:
	ProfileManager.save_profile(__data_profile)

	ChatBot.set_command_data(__data_profile.tab_command.commands)


func __load_application() -> DataApplication:
	if FileManager.file_exists(__PATH_SETTING):
		var result = FileManager.load_file(__PATH_SETTING)
		return str2var(result)

	return DataApplication.new()


func __save_application() -> void:
	FileManager.save_file(__PATH_SETTING, var2str(__data_application))

