class_name FileManager


# Public methods

static func delete_file(path: String, relative: bool = true) -> void:
	var directory: Directory = Directory.new()
	var error = directory.remove(__qualify_path(path, relative))
	print(error)


static func file_exists(path: String, relative: bool = true) -> bool:
	var file: File = File.new()

	return file.file_exists(__qualify_path(path, relative))


static func files_in_directory(path: String, relative: bool = true) -> Array:
	var directory: Directory = Directory.new()

	var qualified_path: String = __qualify_path(path, relative)

	if !directory.dir_exists(qualified_path):
		directory.make_dir(qualified_path)
		return []

	directory.open(qualified_path)
	directory.list_dir_begin(true, false)

	var files: Array = []

	var file: String = directory.get_next()
	while file != "":
		if directory.file_exists(file):
			files.append(file)

		file = directory.get_next()

	return files


static func load_file(path: String, relative: bool = true) -> String:
	var file: File = File.new()

	file.open(__qualify_path(path, relative), File.READ)
	var content: String = file.get_as_text()
	file.close()

	return content


static func load_json(path: String, relative: bool = true): # -> Variant
	var result: JSONParseResult = JSON.parse(load_file(path, relative))
	if result.error:
		return null
	else:
		return result.get_result()


static func save_file(path: String, content: String, relative: bool = true) -> void:
	var file: File = File.new()

	file.open(__qualify_path(path, relative), File.WRITE)
	file.store_string(content)
	file.close()


static func save_json(path: String, content, relative: bool = true) -> void:
	save_file(path, JSON.print(content), relative)


# Private methods

static func __qualify_path(path: String, relative: bool) -> String:
	if relative:
		return "user://%s" % path
	else:
		return path
