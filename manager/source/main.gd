extends Control


# Private constants

const __OVERLAY_DIR: String = "C:\\Users\\velop\\Documents\\_important\\stream-overlay\\build\\overlay\\"
const __PORT: int = 8080


# Private variables

var __server: HTTPServer = null


# Lifecylce methods

func _ready() -> void:
	print("starting server")
	__server = HTTPServer.new()

	__server.endpoint(
		HTTPServer.Method.GET,
		"/overlay",
		funcref(self, "__overlay")
	)

	__server.fallback(
		funcref(self, "__fallback")
	)

	__server.listen(__PORT)


func _process(_delta: float) -> void:
	__server.process_connection()


# Private methods

func __fallback(request: HTTPServer.Request, response: HTTPServer.Response) -> void:
	var endpoint: String = request.endpoint()
	var type: int = request.type()

	if !endpoint.begins_with("/stream-overlay") || type != HTTPServer.Method.GET:
		response.status(HTTPServer.Status.NOT_FOUND)

	endpoint.erase(0, 1)

	__serve_overlay_file(endpoint, response)


func __overlay(request: HTTPServer.Request, response: HTTPServer.Response) -> void:
	__serve_overlay_file("stream-overlay.html", response)


func __serve_overlay_file(path: String, response: HTTPServer.Response) -> void:
	var file: File = File.new()

	if file.open("%s%s" % [__OVERLAY_DIR, path], File.READ) != OK:
		response.status(HTTPServer.Status.NOT_FOUND)
		return

	response.file(file)
