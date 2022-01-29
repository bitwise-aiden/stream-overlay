class_name FileManager


# Public methods

static func delete_file(path: String) -> void:
	var directory: Directory = Directory.new()
	var error = directory.remove("user://%s" % path)
	print(error)


static func file_exists(path: String) -> bool:
	var file: File = File.new()

	return file.file_exists("user://%s" % path)


static func files_in_directory(path: String) -> Array:
	var directory: Directory = Directory.new()

	if !directory.dir_exists("user://%s" %path):
		directory.make_dir("user://%s" %path)
		return []

	directory.open("user://%s" % path)
	directory.list_dir_begin(true, false)

	var files: Array = []

	var file: String = directory.get_next()
	while file != "":
		if directory.file_exists(file):
			files.append(file)

		file = directory.get_next()

	return files


static func load_file(path: String) -> String:
	var file: File = File.new()

	file.open("user://%s" % path, File.READ)
	var content: String = file.get_as_text()
	file.close()

	return content


static func load_json(path: String): # -> Variant
	return JSON.parse(load_file(path)).result


static func save_file(path: String, content: String) -> void:
	var file: File = File.new()

	file.open("user://%s" % path, File.WRITE)
	file.store_string(content)
	file.close()


static func save_json(path: String, content) -> void:
	save_file(path, JSON.print(content))
