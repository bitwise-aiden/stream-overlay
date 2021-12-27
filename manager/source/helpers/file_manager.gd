class_name FileManager


# Public methods

static func file_exists(path: String) -> bool:
	var file: File = File.new()

	return file.file_exists("user://%s" % path)


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
