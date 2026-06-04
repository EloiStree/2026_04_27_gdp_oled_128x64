class_name SSD1306NodeFacade
extends SSD1306NodeFacadeLite

@export var exporter:SSD1306Exporter
@export var code_creator:SSD1306ModCreateCodeNode
@export var wheel_rotation:SSD1306RotationWheelFaceForward
@export var tilt_raw_rotation:SSD1306RotationTiltRawFaceUp
@export var compass_rotation:SSD1306RotationCompassFaceUp



#region UNSTORE

func inverse_display_texture_colors():
	texture_builder.inverse_color_true_false()
func inverse_display_value():
	boolean_state.inverse_all_boolean_value()
	
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
func set_texture_color_black_green_matrix():
	texture_builder.set_color_style_as_black_green_matrix()
func set_texture_color_flipper_orange():
	texture_builder.set_color_style_as_flipper_orange()
 
#endregion

func get_wheel_rotation_in_degrees() -> float:
	return wheel_rotation.get_wheel_rotation_in_degrees_left_right()

func get_tilt_rotation_in_degrees_percent_11() -> float:
	return tilt_raw_rotation.percent_tilt_front_11

func get_raw_rotation_in_degrees_percent_11() -> float:
	return tilt_raw_rotation.percent_raw_right_11

func get_compass_rotation_to_godot_center_in_degrees_left_right() -> float:
	return compass_rotation.get_compass_rotation_to_godot_center_in_degrees_left_right()


func push_code_to_execute(text:String):
	code_creator.try_to_execute_code(text)

func remove_code_to_execute():
	push_code_to_execute("extends Node")
	
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



func get_array_ref()->Array[bool]:	return boolean_state.get_value_as_1d_array_reference()
func bit_shift_1d_right(loop:bool=true): ScreenBuilderShiftBits.shift_1d_left(get_array_ref(),loop)
func bit_shift_1d_left(loop:bool=true): ScreenBuilderShiftBits.shift_1d_right(get_array_ref(),loop)	
func bit_shift_2d_left(loop:bool=true): ScreenBuilderShiftBits.shift_2d_left(get_array_ref(),loop)
func bit_shift_2d_right(loop:bool=true):ScreenBuilderShiftBits.shift_2d_right(get_array_ref(),loop)
func bit_shift_2d_up(loop:bool=true): ScreenBuilderShiftBits.shift_2d_up(get_array_ref(),loop)
func bit_shift_2d_down(loop:bool=true): ScreenBuilderShiftBits.shift_2d_down(get_array_ref(),loop)
func bit_shift_2d_up_left(loop:bool=true): ScreenBuilderShiftBits.shift_2d_up_left(get_array_ref(),loop)
func bit_shift_2d_up_right(loop:bool=true):ScreenBuilderShiftBits.shift_2d_up_right(get_array_ref(),loop)
func bit_shift_2d_down_left(loop:bool=true): ScreenBuilderShiftBits.shift_2d_down_left(get_array_ref(),loop)
func bit_shift_2d_down_right(loop:bool=true): ScreenBuilderShiftBits.shift_2d_down_right(get_array_ref(),loop)
	
func draw_grid_1x1(): boolean_state.set_boolean_as_1x1_grid(true)
func draw_chess_full(): boolean_state.draw_bool_chressboard_full_screen()
func draw_chess_centered(): boolean_state.draw_bool_chressboard_centered()
func draw_border(pixel_count:int): boolean_state.draw_bool_border_count(pixel_count)

func draw_page(page_index_0_7:int, bytes_0_127: PackedByteArray): boolean_state.draw_page(page_index_0_7, bytes_0_127) 

func draw_text_image_at_zero(text:String): boolean_state.draw_from_text_image_lrtd_at_zero(text)

func trigger_export_events(): exporter.export_from_inspector_target()

func import_state_as_text_image_01_from_clipboard():
	draw_text_image_at_zero(DisplayServer.clipboard_get())

func export_state_as_text_image_01_in_clipboard():
	var image :=get_export_as_text_image_01()
	DisplayServer.clipboard_set(image)
	
func get_export_as_text_image_01()->String:
	var array:= boolean_state.get_value_as_1d_array_reference()
	var text = SSD1306Exporter.convert_booleans_to_text_image_01(array)
	return text

func get_array():
	return boolean_state.get_value_as_1d_array_reference()
func draw_six_objectifs_from_text(text:String):
	ScreenBuilderSixObjectifs.draw_title_with_six_objectifs_from_text(get_array(),text,true)

func draw_qr_code_from_text_at_center(text:String):
	push_error("No done")
func draw_qr_code_from_text_at_left_center(text:String):
	ScreenBuilderQrCode.draw_at_center(get_array(),text)
	


	
#region UDP DEBUG SENDER

@export var udp_sender: SSD1306UdpSendToSingleTarget	
func start_sending_display_to_target(ip, port, timing):
	if udp_sender:
		udp_sender.set_target_ip(ip)
		udp_sender.set_target_port(port)
		udp_sender.set_time_between_sends(timing)
		udp_sender.start_timer_pushing_bytes()
		
func set_udp_target_ipv4(ip:String):
	if udp_sender:
		udp_sender.set_target_ip(ip)
func set_udp_target_port_from_string(port:String):
	if udp_sender:
		udp_sender.set_target_port(int(port))
func set_udp_target_port(port:int):
	if udp_sender:
		udp_sender.set_target_port(port)

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
