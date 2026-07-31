extends Node


@export var _code_edit:CodeEdit
#region HIGHLIGHT COLOR

func _ready() -> void:
	load_text_color_style()
	
func load_text_color_style():
	var highlighter := CodeHighlighter.new()
	# Keywords
	highlighter.keyword_colors = {
		"if": Color("ff7085"),
		"elif": Color("ff7085"),
		"else": Color("ff7085"),
		"for": Color("ff7085"),
		"while": Color("ff7085"),
		"match": Color("ff7085"),
		"break": Color("ff7085"),
		"continue": Color("ff7085"),
		"pass": Color("ff7085"),
		"return": Color("ff7085"),
		"class": Color("ff7085"),
		"class_name": Color("ff7085"),
		"extends": Color("ff7085"),
		"func": Color("ff7085"),
		"static": Color("ff7085"),
		"const": Color("ff7085"),
		"var": Color("ff7085"),
		"enum": Color("ff7085"),
		"signal": Color("ff7085"),
		"await": Color("ff7085"),
		"yield": Color("ff7085"),
		"assert": Color("ff7085")
	}

	# Built-in types
	highlighter.member_keyword_colors = {
		"int": Color("42ffc2"),
		"float": Color("42ffc2"),
		"bool": Color("42ffc2"),
		"String": Color("42ffc2"),
		"Array": Color("42ffc2"),
		"Dictionary": Color("42ffc2"),
		"Vector2": Color("42ffc2"),
		"Vector3": Color("42ffc2"),
		"Color": Color("42ffc2"),
		"Node": Color("42ffc2"),
		"Object": Color("42ffc2")
	}

	# General token colors
	highlighter.number_color = Color("a1ffe0")
	highlighter.symbol_color = Color("abc9ff")
	highlighter.function_color = Color("57b3ff")
	highlighter.member_variable_color = Color("c6a0ff")

	# Regions
	highlighter.add_color_region("\"", "\"", Color("ffd942"), false)
	highlighter.add_color_region("'", "'", Color("ffd942"), false)
	highlighter.add_color_region("#", "", Color("7a7a7a"), true)


	_code_edit.syntax_highlighter = highlighter
		


	#
