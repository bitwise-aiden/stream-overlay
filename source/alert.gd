class_name Alert extends Node2D


# Signals

signal complete()


# Private constants

const __DURATION: float = 4.0
const __TYPE_CONVERSION = {
	"follow": "followed",
	"subscribe": "subscribed",
}


# Public variable

var user: String = ""
var type: String = "" setget __type_set, __type_get


# Private variable

onready var __label: RichTextLabel = $label

var __desired_offset_y: float = 0.0
var __initial_y: float = 0.0

var __vertical_tween: Tween = null


# Lifecycle methods

func _ready() -> void:
	var initial_x: float = position.x
	__initial_y = position.y

	__update_text(false)

	var timer: Timer = Timer.new()
	timer.one_shot = true
	add_child(timer)

	var tween: Tween = Tween.new()
	add_child(tween)

	__vertical_tween = Tween.new()
	add_child(__vertical_tween)

	tween.interpolate_method(
		self,
		"__position_x",
		initial_x,
		0.0,
		1.0,
		Tween.TRANS_BOUNCE,
		Tween.EASE_OUT
	)
	tween.start()
	yield(tween, "tween_completed")

	var lower: bool = true
	var elapsed: float = 0.0

	while elapsed <= __DURATION:
		var timeout: float = 0.2 + randf() * 0.2

		timer.start(timeout)
		yield(timer, "timeout")

		__update_text(lower)

		lower = !lower
		elapsed += timeout

	tween.interpolate_method(
		self,
		"__position_x",
		0.0,
		initial_x,
		0.2,
		Tween.TRANS_BOUNCE,
		Tween.EASE_IN
	)
	tween.start()
	yield(tween, "tween_completed")

	remove_child(timer)
	remove_child(tween)
	remove_child(__vertical_tween)

	emit_signal("complete")


# Public methods

func move_down() -> void:
	__desired_offset_y += 110.0

	__vertical_tween.stop_all()

	var current_offset_y: float = position.y - __initial_y

	__vertical_tween.interpolate_method(
		self,
		"__position_y",
		current_offset_y,
		__desired_offset_y,
		0.2,
		Tween.TRANS_LINEAR
	)
	__vertical_tween.start()


# Private methods

func __position_x(x: float) -> void:
	position.x = x


func __position_y(y: float) -> void:
	position.y = __initial_y + y


func __type_get() -> String:
	return type


func __type_set(value: String) -> void:
	if __TYPE_CONVERSION.has(value):
		value = __TYPE_CONVERSION[value]

	type = value


func __update_text(lower: bool) -> void:
	var text: String = "%s\n%s!" % [user, type]

	if lower:
		text = text.to_lower()
	else:
		text = text.to_upper()

	__label.bbcode_text = "[center]%s[/center]" % text
