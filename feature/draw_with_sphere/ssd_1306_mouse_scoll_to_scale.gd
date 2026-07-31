class_name SSD1306MouseScrollToScale
extends Node

signal on_scroll_up()
signal on_scroll_down()



@export var what_to_scale: Node3D
@export var scale_factor: float = 1.1

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
		on_scroll_up.emit()
		if what_to_scale:
			what_to_scale.scale *= scale_factor
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
		on_scroll_down.emit()
		if what_to_scale:
			what_to_scale.scale /= scale_factor
