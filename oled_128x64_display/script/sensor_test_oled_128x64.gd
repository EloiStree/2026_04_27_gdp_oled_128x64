class_name SensorTestDisplay128x64CPU
extends Node


@export var sensor_model: SensorModelBoolDisplay128x64CPU

@export var use_test :bool =false

func wait_one_second() -> void:
	await get_tree().create_timer(1.0).timeout

func wait_seconds(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func wait_next_frame() -> void:
	await get_tree().process_frame


func _ready():
	if not use_test:
		return 
	await wait_seconds(0.001)
	sensor_model.set_boolean_array_to_clear()
	sensor_model.emit_boolean_array_as_updated()
	#await wait_seconds(10)


	# sensor_model.set_all_to_random()
	# sensor_model.emit_boolean_array_as_updated()
	# await wait_seconds(5)
	
	# sensor_model.set_boolean_array_to_clear()
	# sensor_model.emit_boolean_array_as_updated()


	# var center = Vector2i(SensorModelBoolDisplay128x64CPU.SCREEN_WIDTH / 2, SensorModelBoolDisplay128x64CPU.SCREEN_HEIGHT / 2)
	# await wait_seconds(5)

	# sensor_model.set_boolean_array_to_clear()
	# sensor_model.draw_bool_center_circle_v2i_lrdt(center, 4, true,false)
	# sensor_model.emit_boolean_array_as_updated()
	# await wait_seconds(5)
	# sensor_model.set_boolean_array_to_clear()
	# sensor_model.draw_bool_center_circle_v2i_lrdt(center, 4, true, true)
	# sensor_model.emit_boolean_array_as_updated()
	# await wait_seconds(5)


	# sensor_model.set_boolean_array_to_clear()
	# sensor_model.draw_bool_center_diamond_v2i_lrdt(center, 2, true)
	# sensor_model.emit_boolean_array_as_updated()
	# await wait_seconds(5)

	# sensor_model.set_boolean_array_to_clear()
	# sensor_model.draw_bool_center_square_v2i_lrdt(center, 2, true)
	# sensor_model.emit_boolean_array_as_updated()
	# await wait_seconds(5)

	sensor_model.set_boolean_array_to_clear()
	sensor_model.emit_boolean_array_as_updated()

	for i in range(5):
		var start = sensor_model.get_random_point_2d_lrdt()
		var end = sensor_model.get_random_point_2d_lrdt()
		sensor_model.draw_bool_line_v2i_lrdt(start, end, true)
		sensor_model.emit_boolean_array_as_updated()
		await wait_seconds(1)

	for i in range(5):
		var start = sensor_model.get_random_point_2d_lrdt()
		var end = sensor_model.get_random_point_2d_lrdt()
		sensor_model.draw_bool_line_radius_v2i_lrdt(start, end, true, 3)
		sensor_model.emit_boolean_array_as_updated()
		await wait_seconds(1)
			


	for y in range(0, SensorModelBoolDisplay128x64CPU.SCREEN_HEIGHT, 20):
		for x in range(0, SensorModelBoolDisplay128x64CPU.SCREEN_WIDTH, 20):
			#sensor_model.set_boolean_with_2d_lrdt(x, y, true)
			sensor_model.toggle_2d_lrdt_value(x, y)
			sensor_model.emit_boolean_array_as_updated()
			await wait_next_frame()

	await wait_seconds(5)

	for i in range(20):
		sensor_model.toggle_all()
		sensor_model.emit_boolean_array_as_updated()
		await wait_seconds(0.1)
	
	await wait_seconds(5)

	for i in range(20):
		sensor_model.set_boolean_array_to_clear()
		sensor_model.emit_boolean_array_as_updated()
		await wait_seconds(0.1)
		sensor_model.set_boolean_array_to_full()
		sensor_model.emit_boolean_array_as_updated()
		await wait_seconds(0.1)


	sensor_model.toggle_1d_value(0)
	sensor_model.toggle_2d_lrdt_value(0, 0)
	sensor_model.toggle_2d_lrtd_value(0, 0)
	# sensor_model.emit_boolean_array_as_updated()
	# await wait_one_second()
	# sensor_model.set_boolean_column_left_right(0, true)
	# sensor_model.emit_boolean_array_as_updated()
	# await wait_one_second()
	# sensor_model.set_boolean_column_right_left(0, true)
	# sensor_model.emit_boolean_array_as_updated()

	# await wait_one_second()
	# sensor_model.set_boolean_line_down_top(0, true)
	# sensor_model.emit_boolean_array_as_updated()

	# await wait_one_second()
	# sensor_model.set_boolean_line_top_down(0, true)
	# sensor_model.emit_boolean_array_as_updated()
