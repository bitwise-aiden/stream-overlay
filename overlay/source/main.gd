extends Node2D

# Const variables

const ALERT_REFERENCE = preload("res://source/alert.tscn")


# Private variables

var __alerts: Array = []


# Lifecycle methods

func _ready() -> void:
	get_tree().get_root().set_transparent_background(true)

	var timer: Timer = Timer.new()
	timer.one_shot = true
	add_child(timer)

	timer.start(2.0)
	yield(timer, "timeout")

	__alert("incompetent_ian", "subscribe")
	timer.start(0.5)
	yield(timer, "timeout")

	__alert("deschainxiv", "follow")
	timer.start(1.5)
	yield(timer, "timeout")

	__alert("Liioni", "subscribe")
	timer.start(0.5)
	yield(timer, "timeout")

	__alert("cavedens", "subscribe")
	timer.start(0.5)
	yield(timer, "timeout")

	__alert("TheYagich", "unfollow")
	__alert("Lumikkode", "loves")

	remove_child(timer)


# Private methods

func __alert(user: String, type: String) -> void:
	var instance: Alert = ALERT_REFERENCE.instance()
	instance.position = Vector2(-300.0, 80.0)
	instance.user = user
	instance.type = type

	add_child(instance)

	for alert in __alerts:
		alert.move_down()

	__alerts.append(instance)

	yield(instance, "complete")

	var index: int = __alerts.find(instance)
	__alerts.remove(index)

	remove_child(instance)
