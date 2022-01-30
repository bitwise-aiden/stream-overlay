# Autoload DataLinker
extends Node


# Public methods

func link(control: Control, data: Data, field: String) -> void:
	if control is CheckBox:
		__link(control, data, "pressed", field, "button_up", false)
	elif control is LineEdit:
		__link(control, data, "text", field, "text_changed", true)
	elif control is OptionButton:
		__link(control, data, "selected", field, "item_selected", true)
	elif control is SpinBox:
		__link(control, data, "value", field, "value_changed", true)
	elif control is TextEdit:
		__link(control, data, "text", field, "text_changed", false)
	elif control is Label:
		control.set("text", data.get(field))


# Private methods

func __handle_change(control: Control, data: Data, from: String, to: String) -> void:
	var value_control = control.get(from)
	var value_data = data.get(to)

	ActionBuffer.add(
		funcref(self, "__update"),
		[control, data, from, to, value_control],
		funcref(self, "__update"),
		[control, data, from, to, value_data]
	)


func __handle_change_param(_param, control: Control, data: Data, from: String, to: String) -> void:
	__handle_change(control, data, from, to)


func __link(control: Control, data: Data, from: String, to: String, event: String, param: bool) -> void:
	control.set(from, data.get(to))

	if param:
		control.emit_signal(event, control.get(from))
		control.connect(event, self, "__handle_change_param", [control, data, from, to])
	else:
		control.emit_signal(event)
		control.connect(event, self, "__handle_change", [control, data, from, to])


func __update(control: Control, data: Data, from: String, to: String, value) -> void:
	control.set(from, value)
	data.set(to, value)

	Event.emit_signal("data_changed")

