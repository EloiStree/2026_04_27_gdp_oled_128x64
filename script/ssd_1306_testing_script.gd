class_name SensorTestDisplay128x64CPU
extends Node

@export var screen: SSD1306SetGetScreenStateInterfaceWithCPU
@export var use_test :bool =false
@export var label_for_debug:Label3D

@export var frame_refresh: SSD1306FrameRefresher

func wait_one_second() -> void:
	await get_tree().create_timer(1.0).timeout

func wait_seconds(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func wait_next_frame() -> void:
	await get_tree().process_frame

func d_print(text:String):
	if label_for_debug:
		label_for_debug.text = text

func wait_led_frame() -> void:
	await frame_refresh.on_after_frame_refresh

func _ready():
	if not use_test:
		return 
	
	await wait_seconds(0.001)
	d_print("Start")

	screen.set_boolean_array_to_clear()
	await wait_led_frame()

#region DRAWING CHESSBOARD GRIDS
	#screen.flush()
	#await wait_seconds(1)
	#screen.set_boolean_as_4x4_grid()
	#await wait_seconds(1)
	#screen.set_boolean_as_1x1_grid()
	#await wait_seconds(1)
	#screen.set_boolean_as_2x2_grid()
	#await wait_seconds(1)
	# screen.set_boolean_as_3x3_grid()
	# await wait_seconds(1)
	# screen.set_boolean_as_8x8_grid()
	# await wait_seconds(1)
	# screen.set_boolean_as_16x16_grid()
	# await wait_seconds(1)
	# screen.set_boolean_as_32x32_grid()
	# await wait_seconds(1)
#endregion

#region DRAWING CHESSBOARD FULL AND CENTERED
	# screen.flush()
	# screen.draw_bool_chressboard_full_screen()
	# await wait_seconds(1)
	# screen.draw_bool_chressboard_centered()
	# await wait_seconds(1)
#endregion


	screen.draw_bool_progress_bar_from_to_lrdt_vectori(Vector2i(3,3), Vector2i(100, 6), 0.5,false, true )



	var list :Array[String]=screen.get_all_char_in_font_dico_6x8()
	for character in list:
		var image_text:String = screen.get_text_image_of_font_character(character)
		screen.draw_from_text_image_lrtd(20, 20, image_text)
		await wait_seconds(1)


	await wait_seconds(2)

	screen.draw_bool_line_up_lrdt(50,50,1)
	await wait_seconds(1)
	screen.draw_bool_line_right_lrdt(50,50,1)
	await wait_seconds(1)
	screen.draw_bool_line_down_lrdt(50,50,1)
	await wait_seconds(1)
	screen.draw_bool_line_left_lrdt(50,50,1)	
	await wait_seconds(1)
	screen.draw_bool_line_up_lrtd(50,50,3)
	await wait_seconds(1)
	screen.draw_bool_line_right_lrtd(50,50,3)
	await wait_seconds(1)
	screen.draw_bool_line_down_lrtd(50,50,3)
	await wait_seconds(1)
	screen.draw_bool_line_left_lrtd(50,50,3)
	await wait_seconds(1)
	screen.draw_bool_border_rectangle_lrtd_from_to(1, 10, 20, 40, true)
	await wait_seconds(1)
	screen.draw_bool_fill_rectangle_lrtd_from_to( 1+2, 10+2, 20-2, 40-2, true)
	await wait_seconds(1)
	screen.draw_bool_border_rectangle_lrtd_from_to(50, 10, 55, 15, true)
	await wait_seconds(1)
	screen.draw_bool_fill_rectangle_lrtd_from_to( 60,10,65,15, true)
	await wait_seconds(1)



	screen.draw_bool_line_percent01_right(0)
	await wait_seconds(1)
	screen.draw_bool_line_percent01_right(1)
	await wait_seconds(1)



	var image:String="""00000/01010/00000/10001/01110"""
	screen.draw_from_text_image_lrtd(20, 20, image)

	await wait_seconds(2)



	# for i in range(3):
	# 	screen.draw_bool_border_count(i)
	# 	await wait_seconds(1)


	# var increment:float=1.0/128.0
	# var value :float= -1
	# for i in range(200):
	# 	screen.shift_2d_boolean_array_left(false)
	# 	screen.draw_bool_line_percent11_right(value)	
	# 	await wait_led_frame()
	# 	value += increment

		
	# value = 0
	# for i in range(200):
	# 	screen.shift_2d_boolean_array_left(false)
	# 	screen.draw_bool_line_percent01_right(value)	
	# 	await wait_led_frame()
	# 	value += increment

# 	screen.flush()
# 	screen.draw_bool_four_center_points(true)
# 	screen.draw_bool_fill_square_lrtd(0,0, 2, true)

# 	for i in range(10):
# 		screen.shift_1d_by_steps_left(1,true)
# 		await wait_led_frame()
# 		await wait_seconds(1)
# #
# 	for i in range(10):
# 		screen.shift_1d_by_steps_right(1,true)
# 		#await wait_led_frame()
# 		await wait_seconds(1)


	#for i in range(50):
		#screen.shift_2d_boolean_array_down()
		#await wait_led_frame()


	# screen.set_boolean_with_1d(0, true)
	# screen.draw_bool_vertical_line_left_right(0)
	# screen.draw_bool_vertical_line_right_left(0)

	# for i in range(50):
	# 	screen.shift_1d_by_steps_right(1)
	# 	await wait_led_frame()

	# for i in range(100):
	# 	screen.shift_1d_by_steps_left(1)
	# 	await wait_led_frame()

	# #await wait_seconds(10)


	# d_print("Start")
	# screen.set_all_to_random()
	# screen.emit()
	# # await wait_seconds(5)
	
	# # screen.set_boolean_array_to_clear()
	# # screen.emit_boolean_array_as_updated()


	# # var center = Vector2i(SensorModelBoolDisplay128x64CPU.SCREEN_WIDTH / 2, SensorModelBoolDisplay128x64CPU.SCREEN_HEIGHT / 2)
	# # await wait_seconds(5)

	# # screen.set_boolean_array_to_clear()
	# # screen.draw_bool_center_circle_v2i_lrdt(center, 4, true,false)
	# # screen.emit_boolean_array_as_updated()
	# # await wait_seconds(5)
	# # screen.set_boolean_array_to_clear()
	# # screen.draw_bool_center_circle_v2i_lrdt(center, 4, true, true)
	# # screen.emit_boolean_array_as_updated()
	# # await wait_seconds(5)


	# # screen.set_boolean_array_to_clear()
	# # screen.draw_bool_center_diamond_v2i_lrdt(center, 2, true)
	# # screen.emit_boolean_array_as_updated()
	# # await wait_seconds(5)

	# # screen.set_boolean_array_to_clear()
	# # screen.draw_bool_center_square_v2i_lrdt(center, 2, true)
	# # screen.emit_boolean_array_as_updated()
	# # await wait_seconds(5)

	# screen.set_boolean_array_to_clear()
	# screen.emit_boolean_array_as_updated()

	# for i in range(5):
	# 	var start = screen.get_random_point_2d_lrdt()
	# 	var end = screen.get_random_point_2d_lrdt()
	# 	screen.draw_bool_line_v2i_lrdt(start, end, true)
	# 	screen.emit_boolean_array_as_updated()
	# 	await wait_seconds(1)

	# for i in range(5):
	# 	var start = screen.get_random_point_2d_lrdt()
	# 	var end = screen.get_random_point_2d_lrdt()
	# 	screen.draw_bool_line_radius_v2i_lrdt(start, end, true, 3)
	# 	screen.emit_boolean_array_as_updated()
	# 	await wait_seconds(1)
			


	# for y in range(0, SSD1306.SCREEN_HEIGHT, 20):
	# 	for x in range(0, SSD1306.SCREEN_WIDTH, 20):
	# 		#screen.set_boolean_with_2d_lrdt(x, y, true)
	# 		screen.toggle_2d_lrdt_value(x, y)
	# 		screen.emit_boolean_array_as_updated()
	# 		await wait_next_frame()

	# await wait_seconds(5)

	# for i in range(20):
	# 	screen.toggle_all()
	# 	screen.emit_boolean_array_as_updated()
	# 	await wait_seconds(0.1)
	
	# await wait_seconds(5)

	# for i in range(20):
	# 	screen.set_boolean_array_to_clear()
	# 	screen.emit_boolean_array_as_updated()
	# 	await wait_seconds(0.1)
	# 	screen.set_boolean_array_to_full()
	# 	screen.emit_boolean_array_as_updated()
	# 	await wait_seconds(0.1)


	# screen.toggle_1d_value(0)
	# screen.toggle_2d_lrdt_value(0, 0)
	# screen.toggle_2d_lrtd_value(0, 0)
	# # screen.emit_boolean_array_as_updated()
	# # await wait_one_second()
	# # screen.set_boolean_column_left_right(0, true)
	# # screen.emit_boolean_array_as_updated()
	# # await wait_one_second()
	# # screen.set_boolean_column_right_left(0, true)
	# # screen.emit_boolean_array_as_updated()

	# # await wait_one_second()
	# # screen.set_boolean_line_down_top(0, true)
	# # screen.emit_boolean_array_as_updated()

	# # await wait_one_second()
	# # screen.set_boolean_line_top_down(0, true)
	# # screen.emit_boolean_array_as_updated()
