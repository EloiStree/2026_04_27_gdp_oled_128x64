class_name SSD1306ModRefDrawOnDisplayFromSphere
extends Node

@export var display_facade: SSD1306NodeFacade
@export var tool_draw_quad_board_facade: SSD1306ToolDrawQuadBoardFacade
@export var is_drawer_active:bool= false





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_drawer_active:
		return

	var cursor_lrdt_percent_01: Vector2 = tool_draw_quad_board_facade.get_cursor_lrdt_percent_01()
	var cursor_radius_percent_01: float = tool_draw_quad_board_facade.get_cursor_radius_percent_01()
	var pression_percent_11: float = tool_draw_quad_board_facade.get_cursor_pression_percent_11()
	var contact_radius_percent:float = tool_draw_quad_board_facade.get_contact_radius_percent_01_from_width()

	if abs(pression_percent_11) > 0.001:
		
		display_facade.get_draw_interface().draw_bool_center_circle_v2i_lrdt(
			Vector2i(cursor_lrdt_percent_01.x * 127.0, cursor_lrdt_percent_01.y * 63.0),
			int(contact_radius_percent*64.0),
			true
		)
		
		
