class_name Logger


# Public methods

static func debug(message: String) -> void:
	print_debug("[DBG] %s" % message)


static func info(message: String) -> void:
	print("[INF] %s" % message)


static func warn(message: String) -> void:
	push_warning("[WRN] %s" % message)


static func error(message: String) -> void:
	push_error("[ERR] %s" % message)
