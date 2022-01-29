class_name ProfileManager


# Private constants

const __PATH_PROFILE = "profiles/%s"


# Public methods

static func create_profile(name: String) -> DataProfile:
	var new_profile: DataProfile = DataProfile.new()
	new_profile.name = name

	save_profile(new_profile)

	return new_profile


static func delete_profile(profile: DataProfile) -> void:
	FileManager.delete_file(__PATH_PROFILE % profile.name)


static func duplicate_profile(name: String, profile: DataProfile) -> DataProfile:
	var new_profile: DataProfile = DataProfile.new()
	new_profile.copy(profile)
	new_profile.name = name

	save_profile(new_profile)

	return new_profile


static func load_profile(name: String) -> DataProfile:
	var path: String = __PATH_PROFILE % name
	if FileManager.file_exists(path):
		var result = FileManager.load_file(path)
		return str2var(result)

	return DataProfile.new()


static func rename_profile(name: String, profile: DataProfile) -> void:
	delete_profile(profile)

	profile.name = name

	save_profile(profile)


static func save_profile(profile: DataProfile) -> void:
	FileManager.save_file(__PATH_PROFILE % profile.name, var2str(profile))
