class_name SSD1306ToolDrawQuadBoardFacade
extends Node


@export var tool_quad_and_brush:SSD1306ToolDrawWithSphere
@export var texture_quad: SSD1306SetMeshInstanceTexture
@export var texture_brush: SSD1306SetMeshInstanceTexture

@export var quad_drawer:SSD1306ModRefDrawOnDisplayFromSphere


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

func set_brush_size_with_local_from_percent_01(percent_01:float):
	tool_quad_and_brush.set_brush_size_with_local_from_percent_01(percent_01)

func set_pen_as_active(is_active:bool):
	quad_drawer.set_pen_as_active(is_active)

func set_pen_drawing_value_as(use_true_value:bool):
	quad_drawer.set_pen_drawing_value_as(use_true_value)
	
func toggle_pen_drawing_value():
	quad_drawer.toggle_pen_drawing_value()

func toggle_pen_active_state():
	quad_drawer.toggle_pen_active_state()


func _on_check_button_pen_is_active_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.
