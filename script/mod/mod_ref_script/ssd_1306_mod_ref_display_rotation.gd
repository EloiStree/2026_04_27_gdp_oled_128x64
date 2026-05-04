class_name SSD1306ModRefDisplayRotation
extends Node

@export var facade: SSD1306NodeFacade

@export var use:bool= false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not use:
		return
		
	facade.flush_and_draw()
	var compass:float = facade.get_compass_rotation_to_godot_center_in_degrees_left_right()
	var wheel:float = facade.get_wheel_rotation_in_degrees()
	var tilt:float = facade.get_tilt_rotation_in_degrees_percent_11()
	var raw:float = facade.get_raw_rotation_in_degrees_percent_11()
	var text = "\n".join([ "Compass: "+str(int(compass)) , "Wheel: "+str(int(wheel)) , "Tilt: "+str(int(tilt*100.0)) , "Raw: "+str(int(raw*100.0)) ])
	facade.get_draw_interface().draw_bool_line_characters_6x8_lrtd(5,5,text)

	var draw := facade.get_draw_interface()
	draw.draw_bool_fill_rectangle_lrdt_from_to_vectori(Vector2i(99,61),Vector2i(121,54),true)
	draw.draw_bool_fill_rectangle_lrdt_from_to_vectori(Vector2i(100,60),Vector2i(120,55),false)
	draw.draw_bool_progress_bar_horizontal_from_to_lrdt_vectori_percent_11(Vector2i(100,55),Vector2i(120,60),compass/180.0)


	if wheel >= 0.0:
		draw.draw_bool_progress_bar_from_to_lrdt_vectori(Vector2i(110,50),Vector2i(120,45),wheel/90.0)
	else:	
		draw.draw_bool_progress_bar_from_to_lrdt_vectori(Vector2i(110,50),Vector2i(100,45),-wheel/90.0)

	if tilt >= 0.0:
		draw.draw_bool_progress_bar_from_to_lrdt_vectori(Vector2i(110,40),Vector2i(120,35),tilt)
	else:
		draw.draw_bool_progress_bar_from_to_lrdt_vectori(Vector2i(110,40),Vector2i(100,35),-tilt)

	if raw >= 0.0:
		draw.draw_bool_progress_bar_from_to_lrdt_vectori(Vector2i(110,30),Vector2i(120,25),raw)
	else:
		draw.draw_bool_progress_bar_from_to_lrdt_vectori(Vector2i(110,30),Vector2i(100,25),-raw)



	
	# if tilt >= 0.0:
	# 	draw.draw_bool_progress_bar_from_to_lrdt_vectori(Vector2i(122,32),Vector2i(124,63),tilt)
	# else:
	# 	draw.draw_bool_progress_bar_from_to_lrdt_vectori(Vector2i(122,32),Vector2i(124,0),-tilt)
	draw.draw_bool_progress_bar_vertical_from_to_lrdt_vectori_percent_11(Vector2i(122,0),Vector2i(124,63),tilt,true)

	facade.draw()
