class_name SSD1306ToolDrawQuadBoardFacade
extends Node


@export var tool_quad_and_brush:SSD1306ToolDrawWithSphere
@export var texture_quad: SSD1306SetMeshInstanceTexture
@export var texture_brush: SSD1306SetMeshInstanceTexture



func set_texture_quad(texture:Texture2D):
	texture_quad.set_texture(texture)

func set_texture_brush(texture:Texture2D):
	texture_brush.set_texture(texture)


func get_cursor_lrdt_percent_01() -> Vector2:
	return tool_quad_and_brush.get_cursor_lrdt_percent_01()
func get_cursor_radius_percent_01() -> float:
	return tool_quad_and_brush.get_cursor_radius_percent_01()
func get_cursor_pression_percent_11() -> float:
	return tool_quad_and_brush.get_cursor_up_pression_percent_11()

func get_contact_radius_percent_01_from_width() -> float:
	return tool_quad_and_brush.get_contact_radius_percent_01_from_width()

	
