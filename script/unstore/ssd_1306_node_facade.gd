class_name SSD1306NodeFacade
extends Node


@export var boolean_state:SSD1306SetGetScreenStateInterfaceWithCPU

@export var exporter:SSD1306Exporter


@export var code_creator:SSD1306ModCreateCodeNode


@export var wheel_rotation:SSD1306RotationWheelFaceForward
@export var tilt_raw_rotation:SSD1306RotationTiltRawFaceUp
@export var compass_rotation:SSD1306RotationCompassFaceUp

@export var texture_builder:SSD1306BoolArrayToTexture

#region UNSTORE


func inverse_display_texture_colors():
	texture_builder.inverse_color_true_false()

func set_texture_color_true_color(true_color:Color):
	texture_builder.set_color_on(true_color)

func set_texture_color_false_color(false_color:Color):
	texture_builder.set_color_off(false_color)

func set_texture_color_gameboy():
	texture_builder.set_color_style_as_gameboy_on_light()
func set_texture_color_black_and_white():
	texture_builder.set_color_style_as_white_true_on_black_false()
func set_texture_color_oled_blue_sh1106():
	texture_builder.set_color_style_as_sh1106_oled_blue_screen()
func set_texture_color_oled_blue_ssd1306():
	texture_builder.set_color_style_as_ssd1306_black_white_blue()
func set_texture_color_e_ink():
	texture_builder.set_color_style_as_e_ink_screen()


 

 


#endregion


func get_wheel_rotation_in_degrees() -> float:
	return wheel_rotation.get_wheel_rotation_in_degrees_left_right()

func get_tilt_rotation_in_degrees_percent_11() -> float:
	return tilt_raw_rotation.percent_tilt_front_11

func get_raw_rotation_in_degrees_percent_11() -> float:
	return tilt_raw_rotation.percent_raw_right_11

func get_compass_rotation_to_godot_center_in_degrees_left_right() -> float:
	return compass_rotation.get_compass_rotation_to_godot_center_in_degrees_left_right()


#region ONLY ALLOWED IF YOU ARE LEARNING FROM THE SSD 1306
func set_value_at_index_1d(index_0_8191:int, is_on:bool):
	# Replace set_boolean_with_1d byb set_value_at_index_1d 
	boolean_state.set_value_at_index_1d(index_0_8191, is_on)
	
func get_value_at_index_1d(index_0_8191:int)->bool:
	var is_on := boolean_state.get_value_at_index_1d(index_0_8191)
	return is_on

func set_value_with_1d_array(array:Array[bool]):
	boolean_state.override_array_with_boolean_array(array)
	
func get_value_as_1d_array_reference()->Array[bool]:
	return boolean_state.get_value_as_1d_array_reference()
	
func get_value_as_1d_array_copy()->Array[bool]:
	return boolean_state.get_value_as_1d_array_copy()
	
func draw():
	boolean_state.emit_boolean_array_as_updated()

func push_code_to_execute(text:String):
	code_creator.try_to_execute_code(text)

func remove_code_to_execute():
	push_code_to_execute("extends Node")
	
#endregion




#region ONLY ALLOWED IF YOU LEARNED TO USE 1D INDEX AS TOP DOWN / DOWN TOP
func set_value_at_x_y_lrtd(x_left_right:int,y_top_down:int, is_on:bool):
	boolean_state.set_value_at_x_y_lrtd(x_left_right,y_top_down,is_on)

func get_value_at_x_y_lrtd(x_left_right:int,y_top_down:int)->bool:
	return boolean_state.get_value_at_x_y_lrtd(x_left_right,y_top_down)

func set_value_at_x_y_lrdt(x_left_right:int,y_top_down:int, is_on:bool):
	boolean_state.set_value_at_x_y_lrdt(x_left_right,y_top_down,is_on)

func get_value_at_x_y_lrdt(x_left_right:int,y_top_down:int)->bool:	
	return boolean_state.get_value_at_x_y_lrdt(x_left_right,y_top_down)

#endregion


#region COMPARE

func compare_with_1d_array(array:Array[bool])->bool:
	return boolean_state.compare_is_equals_to_boolean_1d_array(array)

func compare_is_equals_to_image_text_at_lrtd_zero(text:String)->bool:
	return boolean_state.compare_is_equals_to_image_text_at_lrtd_at_zero(text)

#endregion


func get_draw_interface()-> SSD1306SetGetScreenStateInterfaceWithCPU: 
	return boolean_state

func fill_and_draw(): boolean_state.fill_and_emit()
func flush_and_draw(): boolean_state.flush_and_emit()

func bit_shift_1d_right(): boolean_state.shift_1d_by_steps_right(1)
func bit_shift_1d_left(): boolean_state.shift_1d_by_steps_left(1)
	
func bit_shift_2d_left(): boolean_state.shift_2d_boolean_array_left()
func bit_shift_2d_right():boolean_state.shift_2d_boolean_array_right()
func bit_shift_2d_up(): boolean_state.shift_2d_boolean_array_up()
func bit_shift_2d_down(): boolean_state.shift_2d_boolean_array_down()

func bit_shift_2d_up_left(): pass
func bit_shift_2d_up_right(): pass
func bit_shift_2d_down_left(): pass
func bit_shift_2d_down_right(): pass
	
func draw_grid_1x1(): boolean_state.set_boolean_as_1x1_grid(true)
func draw_chess_full(): boolean_state.draw_bool_chressboard_full_screen()
func draw_chess_centered(): boolean_state.draw_bool_chressboard_centered()
func draw_border(pixel_count:int): boolean_state.draw_bool_border_count(pixel_count)

func draw_page(page_index_0_7:int, bytes_0_127: PackedByteArray): boolean_state.draw_page(page_index_0_7, bytes_0_127) 

func draw_text_image_at_zero(text:String): boolean_state.draw_from_text_image_lrtd_at_zero(text)

func trigger_export_events(): exporter.export_from_inspector_target()

func import_state_as_image_from_clipboard():
	draw_text_image_at_zero(DisplayServer.clipboard_get())

func export_state_as_image_in_clipboard():
	var image :=get_export_as_text_image()
	DisplayServer.clipboard_set(image)
	
func get_export_as_text_image()->String:
	var array:= boolean_state.get_value_as_1d_array_reference()
	var text = SSD1306Exporter.convert_booleans_to_text_image(array)
	return text
	
	
	
#region UDP DEBUG SENDER

@export var udp_sender: SSD1306UdpSendToSingleTarget	
func start_sending_display_to_target(ip, port, timing):
	if udp_sender:
		udp_sender.set_target_ip(ip)
		udp_sender.set_target_port(port)
		udp_sender.set_time_between_sends(timing)
		udp_sender.start_timer_pushing_bytes()

func stop_sending_display_to_target():
	if udp_sender:
		udp_sender.stop_timer_pushing_bytes()

func send_1d_boolean_array_to_udp_target(array:Array[bool]):
	if udp_sender:
		SSD1306UdpSendToSingleTarget.send_1d_boolean_array_to_target(udp_sender.target_ip, udp_sender.target_port, array)

func send_pack_bytes_to_udp_target(array:PackedByteArray):
	if udp_sender:
		SSD1306UdpSendToSingleTarget.send_1d_packed_boolean_array_to_target(udp_sender.target_ip, udp_sender.target_port, array)

func send_integer_to_udp_target(value:int):
	if udp_sender:
		SSD1306UdpSendToSingleTarget.send_integer_little_endian_to_target(udp_sender.target_ip, udp_sender.target_port, value)

#endregion
