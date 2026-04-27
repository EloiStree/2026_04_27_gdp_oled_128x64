class_name SensorTestDisplay128x64CPU
extends Node

@export var screen: SSD1306SetGetScreenStateInterfaceWithCPU
@export var use_test :bool =false
@export var label_for_debug:Label3D

func wait_one_second() -> void:
	await get_tree().create_timer(1.0).timeout

func wait_seconds(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func wait_next_frame() -> void:
	await get_tree().process_frame

func d_print(text:String):
	if label_for_debug:
		label_for_debug.text = text

func _ready():
	if not use_test:
		return 
	
	await wait_seconds(0.001)
	d_print("Start")
	screen.set_boolean_array_to_clear()
	screen.emit_boolean_array_as_updated()

	screen.set_boolean_with_1d(0, true)


	for i in range(100):
		screen.shift_1d_by_steps_right(1)
		screen.emit_boolean_array_as_updated()
		await wait_seconds(0.05)

	for i in range(100):
		screen.shift_1d_by_steps_left(1)
		screen.emit_boolean_array_as_updated()
		await wait_seconds(0.05)

	#await wait_seconds(10)


	d_print("Start")
	screen.set_all_to_random()
	screen.emit()
	# await wait_seconds(5)
	
	# screen.set_boolean_array_to_clear()
	# screen.emit_boolean_array_as_updated()


	# var center = Vector2i(SensorModelBoolDisplay128x64CPU.SCREEN_WIDTH / 2, SensorModelBoolDisplay128x64CPU.SCREEN_HEIGHT / 2)
	# await wait_seconds(5)

	# screen.set_boolean_array_to_clear()
	# screen.draw_bool_center_circle_v2i_lrdt(center, 4, true,false)
	# screen.emit_boolean_array_as_updated()
	# await wait_seconds(5)
	# screen.set_boolean_array_to_clear()
	# screen.draw_bool_center_circle_v2i_lrdt(center, 4, true, true)
	# screen.emit_boolean_array_as_updated()
	# await wait_seconds(5)


	# screen.set_boolean_array_to_clear()
	# screen.draw_bool_center_diamond_v2i_lrdt(center, 2, true)
	# screen.emit_boolean_array_as_updated()
	# await wait_seconds(5)

	# screen.set_boolean_array_to_clear()
	# screen.draw_bool_center_square_v2i_lrdt(center, 2, true)
	# screen.emit_boolean_array_as_updated()
	# await wait_seconds(5)

	screen.set_boolean_array_to_clear()
	screen.emit_boolean_array_as_updated()

	for i in range(5):
		var start = screen.get_random_point_2d_lrdt()
		var end = screen.get_random_point_2d_lrdt()
		screen.draw_bool_line_v2i_lrdt(start, end, true)
		screen.emit_boolean_array_as_updated()
		await wait_seconds(1)

	for i in range(5):
		var start = screen.get_random_point_2d_lrdt()
		var end = screen.get_random_point_2d_lrdt()
		screen.draw_bool_line_radius_v2i_lrdt(start, end, true, 3)
		screen.emit_boolean_array_as_updated()
		await wait_seconds(1)
			


	for y in range(0, SSD1306.SCREEN_HEIGHT, 20):
		for x in range(0, SSD1306.SCREEN_WIDTH, 20):
			#screen.set_boolean_with_2d_lrdt(x, y, true)
			screen.toggle_2d_lrdt_value(x, y)
			screen.emit_boolean_array_as_updated()
			await wait_next_frame()

	await wait_seconds(5)

	for i in range(20):
		screen.toggle_all()
		screen.emit_boolean_array_as_updated()
		await wait_seconds(0.1)
	
	await wait_seconds(5)

	for i in range(20):
		screen.set_boolean_array_to_clear()
		screen.emit_boolean_array_as_updated()
		await wait_seconds(0.1)
		screen.set_boolean_array_to_full()
		screen.emit_boolean_array_as_updated()
		await wait_seconds(0.1)


	screen.toggle_1d_value(0)
	screen.toggle_2d_lrdt_value(0, 0)
	screen.toggle_2d_lrtd_value(0, 0)
	# screen.emit_boolean_array_as_updated()
	# await wait_one_second()
	# screen.set_boolean_column_left_right(0, true)
	# screen.emit_boolean_array_as_updated()
	# await wait_one_second()
	# screen.set_boolean_column_right_left(0, true)
	# screen.emit_boolean_array_as_updated()

	# await wait_one_second()
	# screen.set_boolean_line_down_top(0, true)
	# screen.emit_boolean_array_as_updated()

	# await wait_one_second()
	# screen.set_boolean_line_top_down(0, true)
	# screen.emit_boolean_array_as_updated()
