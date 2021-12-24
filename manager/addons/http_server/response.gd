# Public Constants

const Status = preload("res://addons/http_server/status.gd")
const FileStream = preload("res://addons/http_server/file_stream.gd")


# Private variables

var __data = "" # variant
var __file: File = null
var __headers: Dictionary = {
	# key: String, header name
	# value: Variant, header value
}
var __status: int = 200


# Public methods

func data(data) -> void: # data: Variant
	__data = data


func file(file: File) -> void:
#	header("connection", "close")
	header("content-length", file.get_len())
	header("content-type", __get_mime_type(file.get_path()))

	__file = file


func header(name: String, value) -> void: # value: Variant
	__headers[name.to_lower()] = value


func json(data) -> void: # data: Variant
	header("content-type", "application/json")

	__data = data


func status(status: int) -> void:
	__status = status


func to_stream() -> FileStream:
	return FileStream.new(__file)


func to_utf8() -> PoolByteArray:
	var content = PoolStringArray()

	content.append(Status.code_to_status_line(__status))

	var data = __data
	if !data && !__file:
		data = Status.code_to_description(__status)

	if __headers.get("content-type", "") == "application/json":
		data = JSON.print(data)

	if data:
		__headers["content-length"] = len(data)

	for header in __headers:
		content.append("%s: %s" % [header, String(__headers[header])])

	content.append("")

	if data:
		content.append(data)

	return content.join("\r\n").to_utf8()


# Private methods

func __get_mime_type(path: String) -> String:
	var ext: String = path.rsplit(".", true, 1)[1]

	match ext:
		"html":
			return "text/html"
		"js":
			return "text/javascript"
		"png":
			return "image/png"
		"wasm":
			return "application/wasm"

	return ""
