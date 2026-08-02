class_name SSD1306ListenToEscape
extends Node

signal on_escape_pressed()

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		notify_escape_pressed()
	if event is InputEventJoypadButton and event.pressed and event.button_index == JOY_BUTTON_B:
		notify_escape_pressed()
	if event is InputEventKey and event.pressed and event.keycode == KEY_BACK:
		notify_escape_pressed()

func notify_escape_pressed():
	on_escape_pressed.emit()
