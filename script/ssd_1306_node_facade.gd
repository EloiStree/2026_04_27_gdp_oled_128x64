class_name SSD1306NodeFacade
extends Node


@export var boolean_state:SSD1306SetGetScreenStateInterfaceWithCPU

@export var exporter:SSD1306Exporter

@export var code_creator:SSD1306ModCreateCodeNode

#region ONLY ALLOWED IF YOU ARE LEARNING FROM THE SSD 1306
func set_value_at_index_1d(index_0_8191:int, is_on:bool):
	# Replace set_boolean_with_1d byb set_value_at_index_1d 
	boolean_state.set_value_at_index_1d(index_0_8191, is_on)
	
func get_value_at_index_1d(index_0_8191:int)->bool:
	var is_on := boolean_state.get_value_at_index_1d(index_0_8191)
	return is_on

func set_value_with_1d_array(array:Array[bool]):
	boolean_state.set_boolean_with_1d()
	
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
	
