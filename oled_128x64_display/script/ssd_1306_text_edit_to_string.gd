class_name SSD1306TextEditToString
extends Node

signal on_text_changed(text:String)
@export var text_editor:TextEdit

func _ready() -> void:
	if text_editor:
		text_editor.text_changed.connect(_push)

func _push():
	if text_editor:
		on_text_changed.emit(text_editor.text)
