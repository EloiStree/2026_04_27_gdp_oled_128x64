class_name SSD1306BooleanStateResource
extends Resource

const HEIGHT:int=128
const WIDTH:int=64
const PIXEL_COUNT_128x64:int = 8192

@export var boolean_state:Array[bool]=[PIXEL_COUNT_128x64]
func resize():
	if boolean_state==null:
		boolean_state = [PIXEL_COUNT_128x64]
	if boolean_state.size()!= PIXEL_COUNT_128x64:
		boolean_state.resize(PIXEL_COUNT_128x64)

func _check_array_size():
		resize()	
		
#region GET ARRAY



func get_array_as_reference()->Array[bool]:
	_check_array_size()
	return boolean_state

func get_array_as_copy()->Array[bool]:
	_check_array_size()
	var copy_array:Array[bool] = [PIXEL_COUNT_128x64]
	for i in range(PIXEL_COUNT_128x64):
		copy_array[i] = boolean_state[i]
	return copy_array

#endregion


#region BASIC GET SET
func get_value_at_index_1d(index:int)->bool:
	_check_array_size()
	return boolean_state[index]

func set_value_at_index_1d(index:int, value:bool):
	_check_array_size()
	boolean_state[index] = value

func get_value_at_lrtd_2d(x_left_right:int, y_top_down:int)->bool:
	_check_array_size()
	var index: int = y_top_down * WIDTH + x_left_right
	return boolean_state[index]

func set_value_at_lrtd_2d(x_left_right:int, y_top_down:int, value:bool):
	_check_array_size()
	var index: int = y_top_down * WIDTH + x_left_right
	boolean_state[index] = value

func get_value_at_lrdt_2d(x_left_right:int, y_down_top:int)->bool:
	_check_array_size()
	var yc = HEIGHT - 1 - y_down_top
	var index: int = yc * WIDTH + x_left_right
	return boolean_state[index]
		
func set_value_at_lrdt_2d(x_left_right:int, y_down_top:int, value:bool):
	_check_array_size()
	var yc = HEIGHT - 1 - y_down_top
	var index: int = yc * WIDTH + x_left_right
	boolean_state[index] = value
#endregion
