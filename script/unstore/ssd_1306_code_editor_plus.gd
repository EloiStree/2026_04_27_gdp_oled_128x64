
class_name SSD1306CodeEditorPlus
extends Node


@export var _code_edit: CodeEdit


func zoom_in_code_edit():
	_code_edit.add_theme_font_size_override("font_size", _code_edit.get_theme_font_size("font_size") + 1)

func zoom_out_code_edit():
	_code_edit.add_theme_font_size_override("font_size", _code_edit.get_theme_font_size("font_size") - 1)
