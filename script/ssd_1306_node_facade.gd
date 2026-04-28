class_name SSD1306NodeFacade
extends Node


@export var boolean_state:SSD1306SetGetScreenStateInterfaceWithCPU

func fill_and_draw(): boolean_state.fill_and_emit()
func flush_and_draw(): boolean_state.flush_and_emit()
func draw(): boolean_state.emit_boolean_array_as_updated()

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
