class_name SSD1306GiveBrushPositionAndSizeFrom
extends Node

@export var _drawer:SSD1306ToolDrawQuadBoardFacade
@export var _size_of_brush_in_percent:float =0.1
@export var _what_to_mirror:Node3D

func _process(delta: float) -> void:
	_drawer.set_brush_size_with_local_from_percent_01(_size_of_brush_in_percent)
	_drawer.set_brush_global_position(_what_to_mirror.global_position)
