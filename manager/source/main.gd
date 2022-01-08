extends VBoxContainer


# Private variables

onready var __tab_command: TabCommand = $tabs_content/Command

var __data: DataApplication = DataApplication.new()


# Lifecycle methods

func _ready() -> void:
	var result = FileManager.load_file("test_settings")
	__data = str2var(result)

	__tab_command.set_data(__data.command)


func _exit_tree() -> void:
	FileManager.save_file("test_settings", var2str(__data))
