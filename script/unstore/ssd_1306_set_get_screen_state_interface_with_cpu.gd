class_name SSD1306SetGetScreenStateInterfaceWithCPU
extends Node

enum QueenDirection {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	UP_LEFT,
	UP_RIGHT,
	DOWN_LEFT,
	DOWN_RIGHT
}

signal on_boolean_array_updated(display_as_boolean_array: Array[bool])
const SCREEN_WIDTH: int = 128
const SCREEN_HEIGHT: int = 64
const SCREEN_SIZE: int = SCREEN_WIDTH * SCREEN_HEIGHT
const SCREEN_SIZE_INDEX_MAX: int = SCREEN_SIZE - 1

@export var screen_state: SSD1306BooleanStateResource


#region TESTED CODE

## shortcut of emit_boolean_array_updated()
## it pushed the array state to the listeners.
func emit():
	emit_boolean_array_as_updated()

#endregion

#region UNTESTED CODE

#region STATIC 




static func index_to_xy_lrtd(index: int) -> Vector2i:
	var x: int = index % SCREEN_WIDTH
	var y: int = index / SCREEN_WIDTH
	return Vector2i(x, y)

static func index_to_xy_lrdt(index: int) -> Vector2i:
	var x: int = index % SCREEN_WIDTH
	var y: int = SCREEN_HEIGHT - 1 - (index / SCREEN_WIDTH)
	return Vector2i(x, y)

static func xy_lrtd_to_index(x: int, y: int) -> int:
	return y * SCREEN_WIDTH + x	

static func xy_lrdt_to_index(x: int, y: int) -> int:
	return (SCREEN_HEIGHT - 1 - y) * SCREEN_WIDTH + x


static func vectori_xy_lrtd_to_index(vec: Vector2i) -> int:
	return xy_lrtd_to_index(vec.x, vec.y)

static func vectori_xy_lrdt_to_index(vec: Vector2i) -> int:
	var y = vec.y
	if y < 0:
		y = 0
	if y >= SCREEN_HEIGHT:
		y = SCREEN_HEIGHT - 1	
	return xy_lrdt_to_index(vec.x, y)
#endregion

#region PRIVATE
func emit_boolean_array_as_updated():
	on_boolean_array_updated.emit(screen_state.boolean_state)	


#endregion

#region EASY CODED

func inverse_all_boolean_value():
	for i in range(SCREEN_SIZE):
		get_value_as_1d_array_reference()[i] = not get_value_as_1d_array_reference()[i]

func inverse_boolean_horizontally():
	var array:= get_value_as_1d_array_reference()
	for y in range(SCREEN_HEIGHT):
		for x in range(SCREEN_WIDTH / 2):
			var left_index: int = xy_lrtd_to_index(x, y)
			var right_index: int = xy_lrtd_to_index(SCREEN_WIDTH - 1 - x, y)
			var temp: bool = array[left_index]
			array[left_index] = array[right_index]
			array[right_index] = temp

func inverse_boolean_vertically():
	var array:= get_value_as_1d_array_reference()
	for x in range(SCREEN_WIDTH):
		for y in range(SCREEN_HEIGHT / 2):
			var top_index: int = xy_lrtd_to_index(x, y)
			var bottom_index: int = xy_lrtd_to_index(x, SCREEN_HEIGHT - 1 - y)
			var temp: bool = array[top_index]
			array[top_index] = array[bottom_index]
			array[bottom_index] = temp


func set_boolean_array_to_full():
	var array:= get_value_as_1d_array_reference()
	for i in range(SCREEN_SIZE):
		array[i] = true

func set_boolean_array_to_clear():
	var array:= get_value_as_1d_array_reference()
	for i in range(SCREEN_SIZE):
		array[i] = false

func set_boolean_line_top_down(line_index: int, is_on: bool = true):
	set_boolean_right_of(0, line_index, is_on)

func set_boolean_column_left_right(column_index: int, is_on: bool = true):
	set_boolean_down_of(column_index, 0, is_on)

func set_boolean_line_down_top(line_index: int, is_on: bool = true):
	set_boolean_left_of(SCREEN_WIDTH - 1, line_index, is_on)

func set_boolean_column_right_left(column_index: int, is_on: bool = true):
	set_boolean_up_of(column_index, SCREEN_HEIGHT - 1, is_on)


#endregion



#region COMPARE


func compare_is_equals_to_boolean_1d_array(source_array: Array[bool]) -> bool:
	var array := get_value_as_1d_array_reference()
	for i in range(SCREEN_SIZE):
		if i < source_array.size():
			if array[i] != source_array[i]:
				return false
		else:
			if array[i] != false:
				return false
	return true

func compare_is_equals_to_image_text(source_image_text: String) -> bool:
	# remove all characters except 0,1 and \n
	var cleaned_source: String = keep_only_01(replace_slash_per_line_return(source_image_text))
	var array: Array[bool] = []
	for c in cleaned_source:
		if c == "1":
			array.append(true)
		elif c == "0":
			array.append(false)
	return compare_is_equals_to_boolean_1d_array(array)

func compare_is_equals_to_image_text_at_lrtd_at_zero( source_image_text: String) -> bool:
	return compare_is_equals_to_image_text_at_lrtd(0, 0, source_image_text)

func compare_is_equals_to_image_text_at_lrtd(x_left_right: int, y_top_down: int, source_image_text: String) -> bool:
	# remove all characters except 0,1 and \n
	var array := get_value_as_1d_array_reference()
	var cleaned_source: String = source_image_text.replace(" ","").replace("\t","").replace("\r","").replace("\\","").replace("/","").replace("|","\n")
	var lines := cleaned_source.split("\n")
	## return false if any is wrong
	for y_offset in range(lines.size()):
		var line: String = lines[y_offset]
		for x_offset in range(line.length()):
			var char: String = line[x_offset]
			if char != "0" and char != "1":
				continue
			var is_on: bool = char == "1"
			var target_x: int = x_left_right + x_offset
			var target_y: int = y_top_down + y_offset
			if target_x < 0 or target_x >= SCREEN_WIDTH or target_y < 0 or target_y >= SCREEN_HEIGHT:
				continue
			if get_value_at_x_y_lrtd(target_x, target_y) != is_on:
				return false
	return true

#endregion



#region BASIC SHOULD NOT BE CHANGED


func set_value_at_index_1d(index_0_8191:int, is_on:bool):
	if index_0_8191 < 0 or index_0_8191 > SCREEN_SIZE_INDEX_MAX:
		return
	get_value_as_1d_array_reference()[index_0_8191] = is_on


func get_value_at_index_1d(index_0_8191:int)->bool:
	if index_0_8191 <0 or index_0_8191 > SCREEN_SIZE_INDEX_MAX:
		return false
	return get_value_as_1d_array_reference()[index_0_8191]

func set_value_with_1d_array(array:Array[bool]):
	for i in range(array.size()):
		set_value_at_index_1d(i, array[i])

func get_value_as_1d_array_reference()->Array[bool]:
	return screen_state.get_array_as_reference()

func get_value_as_1d_array_copy()->Array[bool]:
	var copy :Array[bool] = []
	for i in range(SCREEN_SIZE):
		copy.append(get_value_at_index_1d(i))
	return copy


func set_value_at_x_y_lrtd(x_left_right:int,y_top_down:int, is_on:bool):
	if x_left_right < 0 or x_left_right >= SCREEN_WIDTH:
		return
	if y_top_down < 0:
		y_top_down = 0
	if y_top_down >= SCREEN_HEIGHT:
		y_top_down = SCREEN_HEIGHT - 1

	var index: int = xy_lrtd_to_index(x_left_right, y_top_down)
	set_value_at_index_1d(index, is_on)

func set_value_at_x_y_lrdt(x_left_right:int,y_down_top:int, is_on:bool):
	if x_left_right < 0 or x_left_right >= SCREEN_WIDTH:
		return
	if y_down_top < 0 or y_down_top >= SCREEN_HEIGHT:
		return
	var index: int = xy_lrdt_to_index(x_left_right, y_down_top)
	set_value_at_index_1d(index, is_on)	


func get_value_at_x_y_lrtd(x_left_right:int,y_top_down:int)->bool:
	var index: int = xy_lrtd_to_index(x_left_right, y_top_down)
	return get_value_at_index_1d(index)
	

func get_value_at_x_y_lrdt(x_left_right:int,y_down_top:int)->bool:
	var index: int = xy_lrdt_to_index(x_left_right, y_down_top)
	return get_value_at_index_1d(index)


#endregion









#region GETTERS
func get_top_left_corner_index_2d_lrtd() -> Vector2i:
	return Vector2i(0, 0)
func get_top_right_corner_index_2d_lrtd() -> Vector2i:
	return Vector2i(SCREEN_WIDTH - 1, 0)
func get_bottom_left_corner_index_2d_lrtd() -> Vector2i:
	return Vector2i(0, SCREEN_HEIGHT - 1)
func get_bottom_right_corner_index_2d_lrtd() -> Vector2i:
	return Vector2i(SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1)

	
func get_top_left_corner_index_1d() -> int:
	return vectori_xy_lrtd_to_index(get_top_left_corner_index_2d_lrtd())
func get_top_right_corner_index_1d() -> int:
	return vectori_xy_lrtd_to_index(get_top_right_corner_index_2d_lrtd())
func get_bottom_left_corner_index_1d() -> int:
	return vectori_xy_lrtd_to_index(get_bottom_left_corner_index_2d_lrtd())
func get_bottom_right_corner_index_1d() -> int:
	return vectori_xy_lrtd_to_index(get_bottom_right_corner_index_2d_lrtd())

#endregion


func set_boolean_to_random_at_1d(index: int):
	if index < 0 or index > SCREEN_SIZE_INDEX_MAX:
		return
	get_value_as_1d_array_reference()[index] = randi() % 2 == 0

func set_all_to_random():
	for i in range(SCREEN_SIZE):
		set_boolean_to_random_at_1d(i)

func toggle_1d_value(index: int):
	if index < 0 or index > SCREEN_SIZE_INDEX_MAX:
		return
	get_value_as_1d_array_reference()[index] = not get_value_as_1d_array_reference()[index]

func toggle_2d_lrdt_value(x: int, y: int):
	if x < 0 or x >= SCREEN_WIDTH:
		return
	if y < 0 or y >= SCREEN_HEIGHT:
		return
	var index: int = xy_lrdt_to_index(x, y)
	toggle_1d_value(index)

func toggle_2d_lrtd_value(x: int, y: int):
	if x < 0 or x >= SCREEN_WIDTH:
		return
	if y < 0 or y >= SCREEN_HEIGHT:
		return
	var index: int = xy_lrtd_to_index(x, y)
	toggle_1d_value(index)

func toggle_all():
	for i in range(SCREEN_SIZE):
		toggle_1d_value(i)



func set_boolean_left_of(x: int, y: int, is_on: bool, step:int=128):
	set_boolean_diagonal_lrdt_of(x, y, is_on, QueenDirection.LEFT, step)

func set_boolean_right_of(x: int, y: int, is_on: bool, step:int=128):
	set_boolean_diagonal_lrdt_of(x, y, is_on, QueenDirection.RIGHT, step)

func set_boolean_up_of(x: int, y: int, is_on: bool, step:int=128):
	set_boolean_diagonal_lrdt_of(x, y, is_on, QueenDirection.UP, step)
func set_boolean_down_of(x: int, y: int, is_on: bool, step:int=128):
	set_boolean_diagonal_lrdt_of(x, y, is_on, QueenDirection.DOWN, step)

func set_boolean_diagonal_lrdt_of(x_left_right: int, y_down_top: int, is_on: bool, direction: QueenDirection, step:int=128):
	var step_x: int = 0
	var step_y: int = 0
	match direction:
		QueenDirection.UP_LEFT:
			step_x = -step
			step_y = -step
		QueenDirection.UP_RIGHT:
			step_x = step
			step_y = -step
		QueenDirection.DOWN_LEFT:
			step_x = -step
			step_y = step
		QueenDirection.DOWN_RIGHT:
			step_x = step
			step_y = step	
		QueenDirection.UP:
			step_y = -step
		QueenDirection.DOWN:
			step_y = step
		QueenDirection.LEFT:
			step_x = -step
		QueenDirection.RIGHT:
			step_x = step

	for i in range(max(SCREEN_WIDTH, SCREEN_HEIGHT)):
		var target_x: int = x_left_right + step_x * (i + 1)
		var target_y: int = y_down_top + step_y * (i + 1)
		if target_x < 0 or target_x >= SCREEN_WIDTH:
			break
		if target_y < 0 or target_y >= SCREEN_HEIGHT:
			break
		set_value_at_x_y_lrtd(target_x, target_y, is_on)


#region BIT OPERATIONS


func _init() -> void:
	if screen_state==null:
		screen_state = SSD1306BooleanStateResource.new()
	screen_state.resize()
	set_boolean_array_to_clear()
		
func override_array_with_boolean_array(source_array: Array[bool]):
	var array := get_value_as_1d_array_reference()
	for i in range(SCREEN_SIZE):
		if i < source_array.size():
			array[i] = source_array[i]
		else:
			array[i] = false

func override_array_with_boolean_array_and_emit(source_array: Array[bool]):
	override_array_with_boolean_array(source_array)
	emit_boolean_array_as_updated()

## Move To right

func shift_1d_by_steps_left(steps: int, loop_border: bool = true):
	var new_array: Array[bool] = []
	var array := get_value_as_1d_array_reference()
	for i in range(steps):
		var first_value = array[0]
		var last_value = array[SCREEN_SIZE - 1]
		for j in range(SCREEN_SIZE - 1):
			array[j] = array[j + 1]
		array[SCREEN_SIZE - 1] = first_value if loop_border else false

func shift_1d_by_steps_right(steps: int, loop_border: bool = true):
	var new_array: Array[bool] = []
	var array := get_value_as_1d_array_reference()
	for i in range(steps):
		var first_value = array[0]
		var last_value = array[SCREEN_SIZE - 1]
		for j in range(SCREEN_SIZE - 1, 0, -1):
			array[j] = array[j - 1]
		array[0] = last_value if loop_border else false

func set_boolean_as_1x1_grid(is_on: bool = true):
	draw_bool_chessboard(0, 0, 1)

func set_boolean_as_2x2_grid(is_on: bool = true):
	draw_bool_chessboard(0, 0, 2)

func set_boolean_as_3x3_grid(is_on: bool = true):
	draw_bool_chessboard(0, 0, 3)

func set_boolean_as_4x4_grid(is_on: bool = true):
	draw_bool_chessboard(0, 0, 4)

func set_boolean_as_8x8_grid(is_on: bool = true):
	draw_bool_chessboard(0, 0, 8)

func set_boolean_as_16x16_grid(is_on: bool = true):
	draw_bool_chessboard(0, 0, 16)

func set_boolean_as_32x32_grid(is_on: bool = true):
	draw_bool_chessboard(0, 0, 32)

func draw_bool_chessboard(start_x: int, start_y: int, square_size: int):
	var row_count = SCREEN_HEIGHT / square_size
	var col_count = SCREEN_WIDTH / square_size
	for row in range(row_count+1):
		for col in range(col_count+1):
			var x = start_x + col * square_size
			var y = start_y + row * square_size
			var is_on = (row + col) % 2 == 0			
			draw_bool_fill_square_lrtd(x, y, square_size, is_on)

func draw_bool_chressboard_full_screen():
	draw_bool_chessboard(0, 0, SCREEN_HEIGHT / 8)

func draw_bool_chressboard_centered():
	draw_bool_chressboard_full_screen()
	draw_bool_fill_rectangle_lrtd(0,0,32,64, false)
	draw_bool_fill_rectangle_lrtd(96,0,32,64, false)

func draw_bool_fill_rectangle_lrtd(x_left_right: int, y_top_down: int, width: int, height: int, is_on: bool = true):
	for j in range(x_left_right, x_left_right+width):
		for i in range(y_top_down, y_top_down+height):
			if j < SCREEN_WIDTH and i < SCREEN_HEIGHT:
				set_value_at_x_y_lrtd(j, i, is_on)


func draw_bool_line_percent01_right(percent01:float):
	percent01 = clamp(percent01, 0.0, 1.0)
	var pixel_height: int = int((percent01) * SCREEN_HEIGHT)
	draw_bool_line_up_lrdt(SCREEN_WIDTH-1, 0 , SCREEN_HEIGHT , false)
	draw_bool_line_up_lrdt(SCREEN_WIDTH-1, 0 , pixel_height  ,  true)

	# var inverse_pixel_height: int = SCREEN_HEIGHT - pixel_height
	# draw_bool_fill_rectangle_lrtd(SCREEN_WIDTH - 2, 0, 1, SCREEN_HEIGHT, false)
	# draw_bool_fill_rectangle_lrtd(SCREEN_WIDTH - 2, pixel_height, 1, inverse_pixel_height, true)
	

func draw_bool_line_percent11_right(percent11:float):
	draw_bool_line_up_lrdt(SCREEN_WIDTH-1, 0, SCREEN_HEIGHT, false)
	var half_height: int = int(SCREEN_HEIGHT / 2.0)
	percent11 = clamp(percent11, -1.0, 1.0)
	if percent11 >= 0:
		draw_bool_line_up_lrdt(SCREEN_WIDTH-1, 32,half_height * percent11, true)
	else :
		draw_bool_line_down_lrdt(SCREEN_WIDTH-1, 32, half_height * -percent11, true)
			

func draw_bool_line_up_lrdt(x_left_right: int, y_down_top: int, pixel: int, is_on: bool = true):
	for i in range(pixel + 1):

		set_value_at_x_y_lrdt(x_left_right, y_down_top + i, is_on)

func draw_bool_line_right_lrdt(x_left_right: int, y_down_top: int, pixel: int, is_on: bool = true):
	for i in range(pixel + 1):
		set_value_at_x_y_lrdt(x_left_right + i, y_down_top, is_on)

func draw_bool_line_left_lrdt(x_left_right: int, y_down_top: int, pixel: int, is_on: bool = true):
	for i in range(pixel + 1):
		set_value_at_x_y_lrdt(x_left_right - i, y_down_top, is_on)

func draw_bool_line_down_lrdt(x_left_right: int, y_down_top: int, pixel: int, is_on: bool = true):
	for i in range(pixel + 1):
		set_value_at_x_y_lrdt(x_left_right, y_down_top - i, is_on)

func draw_bool_line_left_lrtd(x_left_right: int, y_down_top: int, pixel: int, is_on: bool = true):
	var x = x_left_right;
	for i in range(0,pixel+1):
		set_value_at_x_y_lrtd(x-i, y_down_top, is_on)

func draw_bool_line_right_lrtd(x_left_right: int, y_down_top: int, pixel: int, is_on: bool = true):
	var x = x_left_right;
	for i in range(0,pixel+1):
		set_value_at_x_y_lrtd(x+i, y_down_top, is_on)

func draw_bool_line_up_lrtd(x_left_right: int, y_down_top: int, pixel: int, is_on: bool = true):
	var y = y_down_top;
	for i in range(0,pixel+1):
		set_value_at_x_y_lrtd(x_left_right, y-i, is_on)

func draw_bool_line_down_lrtd(x_left_right: int, y_down_top: int, pixel: int, is_on: bool = true):
	var y = y_down_top;
	for i in range(0,pixel+1):
		set_value_at_x_y_lrtd(x_left_right, y+i, is_on)




func draw_bool_border_count(pixel_count: int, is_on: bool = true):
	for i in range(pixel_count):
		draw_bool_line_up_lrdt(i, 0, SCREEN_HEIGHT, is_on)
		draw_bool_line_up_lrdt(SCREEN_WIDTH - 1 - i, 0, SCREEN_HEIGHT, is_on)
		draw_bool_line_right_lrdt(0, i, SCREEN_WIDTH, is_on)
		draw_bool_line_right_lrdt(0, SCREEN_HEIGHT - 1 - i, SCREEN_WIDTH, is_on)



func draw_bool_byte_line_down_lrtd(x_left_right: int, y_down_top: int, byte_as_int: int):
	##TODO: TEST LATER
	for i in range(8):
		var bit_is_on: bool = (byte_as_int & (1 << i)) != 0
		set_value_at_x_y_lrtd(x_left_right, y_down_top + i, bit_is_on)


func draw_page(page_index_0_7:int, bytes_0_127: PackedByteArray): 
	##TODO: TEST LATER
	if page_index_0_7 < 0 or page_index_0_7 > 7:
		return
	var line_index_y_down_top: int = page_index_0_7 * 8
	for x in range(SCREEN_WIDTH):
		var byte_as_int: int = bytes_0_127[x]
		draw_bool_byte_line_down_lrtd(x, line_index_y_down_top, byte_as_int)

func draw_pages_with_one_packed_byte_array(bytes_0_1023: PackedByteArray):
	##TODO: TEST LATER
	for i in range(bytes_0_1023.size()):
		var x_top_down: int = i % SCREEN_WIDTH
		var page_index_0_7: int = i / SCREEN_WIDTH
		var line_index_y_down_top: int = page_index_0_7 * 8
		var byte_as_int: int = bytes_0_1023[i]
		draw_bool_byte_line_down_lrtd(x_top_down, line_index_y_down_top, byte_as_int)



func replace_slash_per_line_return(text:String)->String:
	return text.replace("/","\n").replace("\\","\n").replace("|","\n") 

func keep_only_01(text:String)->String:
	var result: String = ""
	for char in text:
		if char == "0" or char == "1" or char == "\n":
			result += char
	return result



func draw_from_text_image_lrtd_at_zero(text:String):	
	draw_from_text_image_lrtd(0,0,text)
	
func draw_from_text_image_lrtd_at_zero_inversed(text:String):
	push_error("Not implemented exception")
	pass
	

func draw_bool_image_from_1d_array_lrtd_at_zero(width: int, boolean_array: Array[bool]):
	draw_bool_image_from_1d_array_lrtd(0, 0, width, boolean_array)

func draw_bool_image_from_1d_array_lrtd_at_zero_inversed(width: int, boolean_array: Array[bool]):
	draw_bool_image_from_1d_array_lrtd(0, 0, width, boolean_array, true)

func draw_bool_image_from_1d_array_lrtd(x_left_right: int, y_down_top: int, width: int, boolean_array: Array[bool], inverse: bool = false):
	for i in range(boolean_array.size()):
		var is_on: bool = boolean_array[i]
		if inverse:
			is_on = not is_on
		var x_offset: int = i % width
		var y_offset: int = i / width
		set_value_at_x_y_lrtd(x_left_right + x_offset, y_down_top + y_offset, is_on)


func draw_bool_character_6x8_lrtd(x_left_right: int, y_down_top: int, char: String, is_on: bool = true):
	var image :String=get_text_image_of_font_character(char)
	draw_from_text_image_lrtd(x_left_right, y_down_top, image)

func draw_bool_line_characters_6x8_lrtd(x_left_right: int, y_down_top: int, char: String, is_on: bool = true):
	var right_offset: int = 6
	var down_offset: int = 8
	var line_count: int = 0
	var char_count: int = 0

	for c in char:
		if c == "\n":
			line_count += 1
			char_count = 0
			continue
		var image :String=get_text_image_of_font_character(c)
		draw_from_text_image_lrtd(x_left_right + char_count * right_offset, y_down_top + line_count * down_offset, image)
		char_count += 1


func draw_bool_border_rectangle_lrtd_from_to(sx:int,sy:int,ex:int,ey:int, is_on: bool = true):
	draw_bool_border_rectangle_lrtd_from_to_vectori(Vector2i(sx,sy), Vector2i(ex,ey), is_on)

func draw_bool_border_rectangle_lrtd_from_to_vectori(start:Vector2i, end:Vector2i, is_on: bool = true):
	draw_bool_line_down_lrtd(start.x, start.y, (end.y - start.y), is_on)
	draw_bool_line_up_lrtd(end.x, end.y, ( start.y - end.y), is_on)
	draw_bool_line_right_lrtd(start.x, start.y, (end.x - start.x), is_on)
	draw_bool_line_left_lrtd(end.x, end.y, (start.x - end.x), is_on)	


func draw_bool_fill_rectangle_lrtd_from_to(sx:int,sy:int,ex:int,ey:int, is_on: bool = true):
	draw_bool_fill_rectangle_lrtd_from_to_vectori(Vector2i(sx,sy), Vector2i(ex,ey), is_on)


func draw_bool_fill_rectangle_lrtd_from_to_vectori(start:Vector2i, end:Vector2i, is_on: bool = true):
	for x in range(start.x, end.x+1):
		for y in range(start.y, end.y+1):
			if x < SCREEN_WIDTH and y < SCREEN_HEIGHT:
				set_value_at_x_y_lrtd(x, y, is_on)
	

func draw_from_text_image_lrtd( x_left_right: int, y_down_top: int, text_image:String):
	
	var text_cleaned: String = keep_only_01(replace_slash_per_line_return(text_image))
	var lines:= text_cleaned.split("\n")
	var start_x = x_left_right
	var start_y = y_down_top

	var x_counter: int = 0
	var y_counter: int = 0
	
	for line in lines:
		for char in line:
			if char != "0" and char != "1":
				continue
			var is_on: bool = char == "1"
			set_value_at_x_y_lrtd(start_x + x_counter, start_y + y_counter, is_on)
			x_counter += 1
		y_counter += 1
		x_counter = 0
	
		

func draw_bool_progress_bar_from_to_lrdt_vectori(start_lrdt:Vector2i, end_lrdt:Vector2i, percent01:float, inversed_direction: bool = false, border: bool = true):
	
	var start_lrtd = Vector2i(start_lrdt.x,SCREEN_HEIGHT - 1 - start_lrdt.y)
	var end_lrtd = Vector2i(end_lrdt.x, SCREEN_HEIGHT - 1 - end_lrdt.y)


	var clamped_percent01: float = clamp(percent01, 0.0, 1.0)
	var direction_horizontal: int = end_lrtd.x - start_lrtd.x 
	var direction_vertical: int= end_lrtd.y - start_lrtd.y
	var is_up: bool = direction_vertical < 0
	var is_right: bool = direction_horizontal > 0
	var is_down: bool = direction_vertical > 0
	var is_left: bool = direction_horizontal < 0

	if is_right:
		#draw_bool_border_rectangle_lrtd_from_to_vectori(start_lrtd, end_lrtd, border)
		draw_bool_fill_rectangle_lrtd_from_to_vectori(start_lrtd, end_lrtd, true)
		# var pixel_length: int = abs(direction_horizontal)
		# var filled_pixel_length: int = int(pixel_length * clamped_percent01)
		# if inversed_direction:
		# 	filled_pixel_length = pixel_length - filled_pixel_length
		# var fill_end_x: int = start_lrtd.x + (filled_pixel_length if is_right else -filled_pixel_length)
		# draw_bool_fill_rectangle_lrtd_from_to_vectori(start_lrtd, Vector2i(fill_end_x, end_lrtd.y), true)

	# if not border:
	# 	draw_bool_fill_rectangle_lrtd_from_to_vectori(start_lrtd, end_lrtd, false)
	# 	draw_bool_fill_rectangle_lrtd_from_to_vectori(start_lrtd, start_to_direction_vector, true)
		
	# # if border:
	# draw_bool_fill_rectangle_lrtd_from_to_vectori(start_lrtd, end_lrtd, false)
	# draw_bool_fill_rectangle_lrtd_from_to_vectori(start_lrtd, start_to_direction_vector, true)
	# draw_bool_border_rectangle_lrtd_from_to_vectori(start_lrtd, end_lrtd, true)
	

	
func flush():
	set_boolean_array_to_clear()

func flush_and_emit():
	set_boolean_array_to_clear()
	emit_boolean_array_as_updated()

func fill():
	set_boolean_array_to_full()

func fill_and_emit():
	set_boolean_array_to_full()
	emit_boolean_array_as_updated()

func draw_bool_four_center_points(is_on: bool = true):
	var x: int = SCREEN_WIDTH / 2
	var y: int = SCREEN_HEIGHT / 2
	draw_bool_fill_square_lrtd(x , y , 2, is_on)
	
func draw_bool_fill_square_lrtd(x_left_right: int, y_top_down: int, square_width: int, is_on: bool = true):
	for j in range(x_left_right, x_left_right+square_width):
		for i in range(y_top_down, y_top_down+square_width):
			if j < SCREEN_WIDTH and i < SCREEN_HEIGHT:
				set_value_at_x_y_lrtd(j, i, is_on)

func shift_2d_boolean_array_down(loop_border: bool = true):
	var array := get_value_as_1d_array_reference()
	var line_save: Array[bool] = []

	if loop_border:
		for x in range(SCREEN_WIDTH):
			line_save.append(array[xy_lrtd_to_index(x, SCREEN_HEIGHT - 1)])
	
	for x in range(SCREEN_WIDTH):
		for y in range(SCREEN_HEIGHT - 1, 0, -1):
			var current_index: int = xy_lrtd_to_index(x, y)
			var previous_index: int = xy_lrtd_to_index(x, y - 1)
			array[current_index] = array[previous_index]
		

	if loop_border:
		for x in range(SCREEN_WIDTH):
			array[xy_lrtd_to_index(x, 0)] = line_save[x]
	else:
		for x in range(SCREEN_WIDTH):
			array[xy_lrtd_to_index(x, 0)] = false



func shift_2d_boolean_array_left(loop_border: bool = true):
	var array := get_value_as_1d_array_reference()
	var column_save: Array[bool] = []

	if loop_border:
		for y in range(SCREEN_HEIGHT):
			column_save.append(array[xy_lrtd_to_index(0, y)])
	
	for y in range(SCREEN_HEIGHT):
		for x in range(SCREEN_WIDTH - 1):
			var current_index: int = xy_lrtd_to_index(x, y)
			var next_index: int = xy_lrtd_to_index(x + 1, y)
			array[current_index] = array[next_index]
		

	if loop_border:
		for y in range(SCREEN_HEIGHT):
			array[xy_lrtd_to_index(SCREEN_WIDTH - 1, y)] = column_save[y]
	else:
		for y in range(SCREEN_HEIGHT):
			array[xy_lrtd_to_index(SCREEN_WIDTH - 1, y)] = false




func shift_2d_boolean_array_right(loop_border: bool = true):
	var array := get_value_as_1d_array_reference()
	var column_save: Array[bool] = []

	if loop_border:
		for y in range(SCREEN_HEIGHT):
			column_save.append(array[xy_lrtd_to_index(SCREEN_WIDTH - 1, y)])
	
	for y in range(SCREEN_HEIGHT):
		for x in range(SCREEN_WIDTH - 1, 0, -1):
			var current_index: int = xy_lrtd_to_index(x, y)
			var previous_index: int = xy_lrtd_to_index(x - 1, y)
			array[current_index] = array[previous_index]
		

	if loop_border:
		for y in range(SCREEN_HEIGHT):
			array[xy_lrtd_to_index(0, y)] = column_save[y]
	else:
		for y in range(SCREEN_HEIGHT):
			array[xy_lrtd_to_index(0, y)] = false


		
func shift_2d_boolean_array_up(loop_border: bool = true):
	var array := get_value_as_1d_array_reference()
	var line_save: Array[bool] = []

	if loop_border:
		for x in range(SCREEN_WIDTH):
			line_save.append(array[xy_lrtd_to_index(x, 0)])
	
	for x in range(SCREEN_WIDTH):
		for y in range(SCREEN_HEIGHT - 1):
			var current_index: int = xy_lrtd_to_index(x, y)
			var next_index: int = xy_lrtd_to_index(x, y + 1)
			array[current_index] = array[next_index]
		

	if loop_border:
		for x in range(SCREEN_WIDTH):
			array[xy_lrtd_to_index(x, SCREEN_HEIGHT - 1)] = line_save[x]
	else:
		for x in range(SCREEN_WIDTH):
			array[xy_lrtd_to_index(x, SCREEN_HEIGHT - 1)] = false





#region DRAWING

func draw_bool_center_diamond_v2i_lrdt(point: Vector2i, radius: int, is_on: bool = true):
	for y in range(SCREEN_HEIGHT):
		for x in range(SCREEN_WIDTH):
			var distance_squared: int = (x - point.x) * (x - point.x) + (y - point.y) * (y - point.y)
			if distance_squared <= radius * radius:
				set_value_at_x_y_lrtd(x, y, is_on)

func draw_bool_center_circle_v2i_lrdt(point: Vector2i, radius: int, is_on: bool = true, fill:bool=true):
	if fill:
		for y in range(point.y - radius, point.y + radius + 1):
			for x in range(point.x - radius, point.x + radius + 1):
				var distance_squared: int = (x - point.x) * (x - point.x) + (y - point.y) * (y - point.y)
				if distance_squared <= radius * radius:
					set_value_at_x_y_lrtd(x, y, is_on)
	
	for angle in range(0, 360):
		var rad: float = deg_to_rad(angle)
		var x: int = round(point.x + radius * cos(rad))
		var y: int = round(point.y + radius * sin(rad))
		set_value_at_x_y_lrtd(x, y, is_on)


func draw_bool_center_square_v2i_lrdt(point: Vector2i, half_size: int, is_on: bool = true):
	for y in range(SCREEN_HEIGHT):
		for x in range(SCREEN_WIDTH):
			if abs(x - point.x) <= half_size and abs(y - point.y) <= half_size:
				set_value_at_x_y_lrtd(x, y, is_on)

func draw_bool_line_v2i_lrdt(start: Vector2i, end: Vector2i, is_on: bool = true):
	
	## alorithm to draw line in 2d array pixel

	var points_on_line: Array[Vector2i] = []
	var magnitude: float = start.distance_to(end)
	if magnitude == 0:
		set_value_at_x_y_lrtd(start.x, start.y, is_on)
		return
	var direction: Vector2 = (end - start) / magnitude
	var current_point: Vector2 = start
	var traveled_distance: float = 0.0

	while traveled_distance <= magnitude:
		points_on_line.append(Vector2i(round(current_point.x), round(current_point.y)))
		current_point += direction
		traveled_distance += direction.length()
	
	for point in points_on_line:
		set_value_at_x_y_lrtd(point.x, point.y, is_on)

func draw_bool_line_radius_v2i_lrdt(start: Vector2i, end: Vector2i, is_on: bool = true, radius: int = 2):


	var points_on_line: Array[Vector2i] = []
	var magnitude: float = start.distance_to(end)
	if magnitude == 0:
		draw_bool_center_circle_v2i_lrdt(start, 2, is_on, true)
		return
	var direction: Vector2 = (end - start) / magnitude
	var current_point: Vector2 = start
	var traveled_distance: float = 0.0

	while traveled_distance <= magnitude:
		points_on_line.append(Vector2i(round(current_point.x), round(current_point.y)))
		current_point += direction
		traveled_distance += direction.length()

	for point in points_on_line:
		draw_bool_center_circle_v2i_lrdt(point, radius, is_on, true)



func draw_bool_vertical_line_left_right(left_right: int, is_on: bool = true):
	for y in range(SCREEN_HEIGHT):
		set_value_at_x_y_lrtd(left_right, y, is_on)


func draw_bool_horizontal_line_top_down(top_down: int, is_on: bool = true):
	for x in range(SCREEN_WIDTH):
		set_value_at_x_y_lrtd(x, top_down, is_on)

func draw_bool_vertical_line_right_left(right_left: int, is_on: bool = true):
	for y in range(SCREEN_HEIGHT):
		set_value_at_x_y_lrtd(right_left, y, is_on)

func draw_bool_horizontal_line_down_top(down_top: int, is_on: bool = true):
	for x in range(SCREEN_WIDTH):
		set_value_at_x_y_lrtd(x, down_top, is_on)

#endregion

func get_center_point_2d_lrtd() -> Vector2i:
	return Vector2i(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
	
func get_random_point_2d_lrdt() -> Vector2i:
	var x: int = randi() % SCREEN_WIDTH
	var y: int = randi() % SCREEN_HEIGHT
	return Vector2i(x, y)


func get_text_image_of_font_character(character: String) -> String:
	if FONT_DICO_SSD1306_6X8.has(character):
		var bytes: Array = FONT_DICO_SSD1306_6X8[character]
		var packed_bytes: PackedByteArray = PackedByteArray(bytes)
		return turn_6x8_to_text_image(packed_bytes)
	else:
		return ""

func turn_6x8_to_text_image(bytes:PackedByteArray)->String:

	var array_8x6:Array[String] = [
		"0","0","0","0","0","0","|",
		"0","0","0","0","0","0","|",
		"0","0","0","0","0","0","|",
		"0","0","0","0","0","0","|",
		"0","0","0","0","0","0","|",
		"0","0","0","0","0","0","|",
		"0","0","0","0","0","0","|",
		"0","0","0","0","0","0",
		]

	for x in range(6):
		var byte_as_int: int = bytes[x]
		for y in range(8):
			var bit_is_on: bool = (byte_as_int & (1 << y)) != 0
			array_8x6[y * 7 + x] = "1" if bit_is_on else "0"

	var text_image: String = "".join(array_8x6)
	return text_image

func get_all_char_in_font_dico_6x8() -> Array[String]:
	var characters: Array[String] = []
	for character in FONT_DICO_SSD1306_6X8.keys():
		characters.append(character)
	return characters


var FONT_DICO_SSD1306_6X8 := {
	' ': [0x00,0x00,0x00,0x00,0x00,0x00],
	'!': [0x00,0x00,0x00,0x2f,0x00,0x00],
	'"': [0x00,0x00,0x07,0x00,0x07,0x00],
	'#': [0x00,0x14,0x7f,0x14,0x7f,0x14],
	'$': [0x00,0x24,0x2a,0x7f,0x2a,0x12],
	'%': [0x00,0x23,0x13,0x08,0x64,0x62],
	'&': [0x00,0x36,0x49,0x55,0x22,0x50],
	"'": [0x00,0x00,0x05,0x03,0x00,0x00],
	'(': [0x00,0x00,0x1c,0x22,0x41,0x00],
	')': [0x00,0x00,0x41,0x22,0x1c,0x00],
	'*': [0x00,0x14,0x08,0x3E,0x08,0x14],
	'+': [0x00,0x08,0x08,0x3E,0x08,0x08],
	',': [0x00,0x00,0x00,0xA0,0x60,0x00],
	'-': [0x00,0x08,0x08,0x08,0x08,0x08],
	'.': [0x00,0x00,0x60,0x60,0x00,0x00],
	'/': [0x00,0x20,0x10,0x08,0x04,0x02],
	'0': [0x00,0x3E,0x51,0x49,0x45,0x3E],
	'1': [0x00,0x00,0x42,0x7F,0x40,0x00],
	'2': [0x00,0x42,0x61,0x51,0x49,0x46],
	'3': [0x00,0x21,0x41,0x45,0x4B,0x31],
	'4': [0x00,0x18,0x14,0x12,0x7F,0x10],
	'5': [0x00,0x27,0x45,0x45,0x45,0x39],
	'6': [0x00,0x3C,0x4A,0x49,0x49,0x30],
	'7': [0x00,0x01,0x71,0x09,0x05,0x03],
	'8': [0x00,0x36,0x49,0x49,0x49,0x36],
	'9': [0x00,0x06,0x49,0x49,0x29,0x1E],
	':': [0x00,0x00,0x36,0x36,0x00,0x00],
	';': [0x00,0x00,0x56,0x36,0x00,0x00],
	'<': [0x00,0x08,0x14,0x22,0x41,0x00],
	'=': [0x00,0x14,0x14,0x14,0x14,0x14],
	'>': [0x00,0x00,0x41,0x22,0x14,0x08],
	'?': [0x00,0x02,0x01,0x51,0x09,0x06],
	'@': [0x00,0x32,0x49,0x59,0x51,0x3E],
	'A': [0x00,0x7C,0x12,0x11,0x12,0x7C],
	'B': [0x00,0x7F,0x49,0x49,0x49,0x36],
	'C': [0x00,0x3E,0x41,0x41,0x41,0x22],
	'D': [0x00,0x7F,0x41,0x41,0x22,0x1C],
	'E': [0x00,0x7F,0x49,0x49,0x49,0x41],
	'F': [0x00,0x7F,0x09,0x09,0x09,0x01],
	'G': [0x00,0x3E,0x41,0x49,0x49,0x7A],
	'H': [0x00,0x7F,0x08,0x08,0x08,0x7F],
	'I': [0x00,0x00,0x41,0x7F,0x41,0x00],
	'J': [0x00,0x20,0x40,0x41,0x3F,0x01],
	'K': [0x00,0x7F,0x08,0x14,0x22,0x41],
	'L': [0x00,0x7F,0x40,0x40,0x40,0x40],
	'M': [0x00,0x7F,0x02,0x0C,0x02,0x7F],
	'N': [0x00,0x7F,0x04,0x08,0x10,0x7F],
	'O': [0x00,0x3E,0x41,0x41,0x41,0x3E],
	'P': [0x00,0x7F,0x09,0x09,0x09,0x06],
	'Q': [0x00,0x3E,0x41,0x51,0x21,0x5E],
	'R': [0x00,0x7F,0x09,0x19,0x29,0x46],
	'S': [0x00,0x46,0x49,0x49,0x49,0x31],
	'T': [0x00,0x01,0x01,0x7F,0x01,0x01],
	'U': [0x00,0x3F,0x40,0x40,0x40,0x3F],
	'V': [0x00,0x1F,0x20,0x40,0x20,0x1F],
	'W': [0x00,0x3F,0x40,0x38,0x40,0x3F],
	'X': [0x00,0x63,0x14,0x08,0x14,0x63],
	'Y': [0x00,0x07,0x08,0x70,0x08,0x07],
	'Z': [0x00,0x61,0x51,0x49,0x45,0x43],
	'[': [0x00,0x00,0x7F,0x41,0x41,0x00],
	'\\': [0x00,0x55,0x2A,0x55,0x2A,0x55],
	']': [0x00,0x00,0x41,0x41,0x7F,0x00],
	'^': [0x00,0x04,0x02,0x01,0x02,0x04],
	'_': [0x00,0x40,0x40,0x40,0x40,0x40],
	'`': [0x00,0x00,0x01,0x02,0x04,0x00],
	'a': [0x00,0x20,0x54,0x54,0x54,0x78],
	'b': [0x00,0x7F,0x48,0x44,0x44,0x38],
	'c': [0x00,0x38,0x44,0x44,0x44,0x20],
	'd': [0x00,0x38,0x44,0x44,0x48,0x7F],
	'e': [0x00,0x38,0x54,0x54,0x54,0x18],
	'f': [0x00,0x08,0x7E,0x09,0x01,0x02],
	'g': [0x00,0x18,0xA4,0xA4,0xA4,0x7C],
	'h': [0x00,0x7F,0x08,0x04,0x04,0x78],
	'i': [0x00,0x00,0x44,0x7D,0x40,0x00],
	'j': [0x00,0x40,0x80,0x84,0x7D,0x00],
	'k': [0x00,0x7F,0x10,0x28,0x44,0x00],
	'l': [0x00,0x00,0x41,0x7F,0x40,0x00],
	'm': [0x00,0x7C,0x04,0x18,0x04,0x78],
	'n': [0x00,0x7C,0x08,0x04,0x04,0x78],
	'o': [0x00,0x38,0x44,0x44,0x44,0x38],
	'p': [0x00,0xFC,0x24,0x24,0x24,0x18],
	'q': [0x00,0x18,0x24,0x24,0x18,0xFC],
	'r': [0x00,0x7C,0x08,0x04,0x04,0x08],
	's': [0x00,0x48,0x54,0x54,0x54,0x20],
	't': [0x00,0x04,0x3F,0x44,0x40,0x20],
	'u': [0x00,0x3C,0x40,0x40,0x20,0x7C],
	'v': [0x00,0x1C,0x20,0x40,0x20,0x1C],
	'w': [0x00,0x3C,0x40,0x30,0x40,0x3C],
	'x': [0x00,0x44,0x28,0x10,0x28,0x44],
	'y': [0x00,0x1C,0xA0,0xA0,0xA0,0x7C],
	'z': [0x00,0x44,0x64,0x54,0x4C,0x44],
	'{': [0x00,0x00,0x08,0x77,0x00,0x00],
	'|': [0x00,0x00,0x00,0x7F,0x00,0x00],
	'}': [0x00,0x00,0x77,0x08,0x00,0x00],
	'~': [0x00,0x10,0x08,0x10,0x08,0x00],
	'DEL': [0x14,0x14,0x14,0x14,0x14,0x14]
}





# func draw_frame():
# 	for i in range(SCREEN_SIZE):
# 		var is_on: bool = display_as_boolean_array[i]
# 		texture_2d_data[i] = color_on if is_on else color_off
	
# 	var image := Image.create(SCREEN_WIDTH, SCREEN_HEIGHT, use_mipmaps, Image.FORMAT_RGBA8)
# 	image.lock()
# 	for i in range(SCREEN_SIZE):
# 		var pos := index_to_xy(i)
# 		image.set_pixel(pos.x, pos.y, texture_2d_data[i])
# 	image.unlock()
	
# 	texture_2d.set_image(image)

# func draw_frame_and_emit():
# 	draw_frame()
# 	on_texture_updated.emit(texture_2d)
# 	on_texture_material_updated.emit(0, null)  # material_surface is not used in this example, so we pass null

# # -------------------------
# # Conversion helpers
# # -------------------------
	
# func index_to_xy(index: int) -> Vector2i:
# 	var x: int = index % SCREEN_WIDTH
# 	var y: int = index / SCREEN_WIDTH
# 	return Vector2i(x, y)


# func xy_to_index(x: int, y: int) -> int:
# 	return y * SCREEN_WIDTH + x


# # -------------------------
# # Pixel control
# # -------------------------

# func set_boolean_of_pixel(index: int, is_on: bool):
# 	if index < 0 or index > SCREEN_SIZE_INDEX_MAX:
# 		return
# 	display_as_boolean_array[index] = is_on


# func set_boolean_of_pixel_xy(x: int, y: int, is_on: bool):
# 	if x < 0 or x >= SCREEN_WIDTH:
# 		return
# 	if y < 0 or y >= SCREEN_HEIGHT:
# 		return
	
# 	var index: int = xy_to_index(x, y)
# 	set_boolean_of_pixel(index, is_on)





# func clear_and_emit():
# 	for i in range(SCREEN_SIZE):
# 		display_as_boolean_array[i] = false
# 		texture_2d_data[i] = color_off
# 	on_texture_updated.emit(texture_2d)


# func fill_and_emit():
# 	for i in range(SCREEN_SIZE):
# 		display_as_boolean_array[i] = true
# 		texture_2d_data[i] = color_on	
# 	on_texture_updated.emit(texture_2d)



# func get_on_off_color(is_on:bool) -> Color:
# 	return color_on if is_on else color_off


# func set_boolean_of_vertical_line(x: int, is_on: bool = true):
# 	if x < 0 or x >= SCREEN_WIDTH:
# 		return
	
# 	for y in range(SCREEN_HEIGHT):
# 		set_boolean_of_pixel_xy(x, y, is_on)

# func set_boolean_of_horizontal_line(y: int, is_on: bool = true):
# 	if y < 0 or y >= SCREEN_HEIGHT:
# 		return
	
# 	for x in range(SCREEN_WIDTH):
# 		set_boolean_of_pixel_xy(x, y, is_on)

# func set_boolean_of_diagonal_line_left_to_right(x, y, is_on: bool = true):
# 	set_boolean_of_diagonal_line(x, y, true, is_on)

# func set_boolean_of_diagonal_line_right_to_left(x, y, is_on: bool = true):
# 	set_boolean_of_diagonal_line(x, y, false, is_on)

# func set_boolean_of_diagonal_line(x, y, left_to_right: bool = true, is_on: bool = true):
# 	if left_to_right:
# 		for i in range(SCREEN_HEIGHT):
# 			var px = x + i
# 			var py = y + i
# 			if px < 0 or px >= SCREEN_WIDTH:
# 				continue
# 			if py < 0 or py >= SCREEN_HEIGHT:
# 				continue
# 			set_boolean_of_pixel_xy(px, py, is_on)
# 		for i in range(SCREEN_HEIGHT):
# 			var px = x - i
# 			var py = y + i
# 			if px < 0 or px >= SCREEN_WIDTH:
# 				continue
# 			if py < 0 or py >= SCREEN_HEIGHT:
# 				continue
# 			set_boolean_of_pixel_xy(px, py, is_on)
# 	else:
# 		for i in range(SCREEN_HEIGHT):
# 			var px = x - i
# 			var py = y + i
# 			if px < 0 or px >= SCREEN_WIDTH:
# 				continue
# 			if py < 0 or py >= SCREEN_HEIGHT:
# 				continue
# 			set_boolean_of_pixel_xy(px, py, is_on)

# 		for i in range(SCREEN_HEIGHT):
# 			var px = x + i
# 			var py = y + i
# 			if px < 0 or px >= SCREEN_WIDTH:
# 				continue
# 			if py < 0 or py >= SCREEN_HEIGHT:
# 				continue
# 			set_boolean_of_pixel_xy(px, py, is_on)


# func shift_boolean_right(loop_border: bool = false):
# 	for y in range(SCREEN_HEIGHT):
# 		var last_value: bool = display_as_boolean_array[xy_to_index(SCREEN_WIDTH - 1, y)]
# 		for x in range(SCREEN_WIDTH - 1, 0, -1):
# 			var current_index: int = xy_to_index(x, y)
# 			var previous_index: int = xy_to_index(x - 1, y)
# 			display_as_boolean_array[current_index] = display_as_boolean_array[previous_index]
		
# 		display_as_boolean_array[xy_to_index(0, y)] = last_value if loop_border else false

# func shift_boolean_left(loop_border: bool = false):
# 	for y in range(SCREEN_HEIGHT):
# 		var first_value: bool = display_as_boolean_array[xy_to_index(0, y)]
# 		for x in range(SCREEN_WIDTH - 1):
# 			var current_index: int = xy_to_index(x, y)
# 			var next_index: int = xy_to_index(x + 1, y)
# 			display_as_boolean_array[current_index] = display_as_boolean_array[next_index]
		
# 		display_as_boolean_array[xy_to_index(SCREEN_WIDTH - 1, y)] = first_value if loop_border else false	

# func shift_boolean_down(loop_border: bool = false):
# 	for x in range(SCREEN_WIDTH):
# 		var last_value: bool = display_as_boolean_array[xy_to_index(x, SCREEN_HEIGHT - 1)]
# 		for y in range(SCREEN_HEIGHT - 1, 0, -1):
# 			var current_index: int = xy_to_index(x, y)
# 			var previous_index: int = xy_to_index(x, y - 1)
# 			display_as_boolean_array[current_index] = display_as_boolean_array[previous_index]
		
# 		display_as_boolean_array[xy_to_index(x, 0)] = last_value if loop_border else false

# func shift_boolean_up(loop_border: bool = false):
# 	for x in range(SCREEN_WIDTH):
# 		var first_value: bool = display_as_boolean_array[xy_to_index(x, 0)]
# 		for y in range(SCREEN_HEIGHT - 1):
# 			var current_index: int = xy_to_index(x, y)
# 			var next_index: int = xy_to_index(x, y + 1)
# 			display_as_boolean_array[current_index] = display_as_boolean_array[next_index]

# func shift_boolean_diagonal_up_right(loop_border: bool = false):
# 	for y in range(SCREEN_HEIGHT):
# 		var first_value: bool = display_as_boolean_array[xy_to_index(0, y)]
# 		for x in range(SCREEN_WIDTH - 1):
# 			var current_index: int = xy_to_index(x, y)
# 			var next_index: int = xy_to_index(x + 1, (y + 1) % SCREEN_HEIGHT)
# 			display_as_boolean_array[current_index] = display_as_boolean_array[next_index]
		
# 		display_as_boolean_array[xy_to_index(SCREEN_WIDTH - 1, y)] = first_value if loop_border else false


# func shift_boolean_diagonal_up_left(loop_border: bool = false):
# 	for y in range(SCREEN_HEIGHT):
# 		var first_value: bool = display_as_boolean_array[xy_to_index(SCREEN_WIDTH - 1, y)]
# 		for x in range(SCREEN_WIDTH - 1, 0, -1):
# 			var current_index: int = xy_to_index(x, y)
# 			var next_index: int = xy_to_index(x - 1, (y + 1) % SCREEN_HEIGHT)
# 			display_as_boolean_array[current_index] = display_as_boolean_array[next_index]
		
# 		display_as_boolean_array[xy_to_index(0, y)] = first_value if loop_border else false

# func shift_boolean_diagonal_down_right(loop_border: bool = false):
# 	for y in range(SCREEN_HEIGHT):
# 		var first_value: bool = display_as_boolean_array[xy_to_index(0, y)]
# 		for x in range(SCREEN_WIDTH - 1):
# 			var current_index: int = xy_to_index(x, y)
# 			var next_index: int = xy_to_index(x + 1, (y - 1 + SCREEN_HEIGHT) % SCREEN_HEIGHT)
# 			display_as_boolean_array[current_index] = display_as_boolean_array[next_index]
		
# 		display_as_boolean_array[xy_to_index(SCREEN_WIDTH - 1, y)] = first_value if loop_border else false

# func shift_boolean_diagonal_down_left(loop_border: bool = false):
# 	for y in range(SCREEN_HEIGHT):
# 		var first_value: bool = display_as_boolean_array[xy_to_index(SCREEN_WIDTH - 1, y)]
# 		for x in range(SCREEN_WIDTH - 1, 0, -1):
# 			var current_index: int = xy_to_index(x, y)
# 			var next_index: int = xy_to_index(x - 1, (y - 1 + SCREEN_HEIGHT) % SCREEN_HEIGHT)
# 			display_as_boolean_array[current_index] = display_as_boolean_array[next_index]	
# 		display_as_boolean_array[xy_to_index(0, y)] = first_value if loop_border else false

# # -------------------------
# # Bulk update (fast)
# # -------------------------

# func set_from_bool_array(data: Array):
# 	# expects width * height elements
# 	var max_size = min(data.size(), width * height)
	
# 	for i in range(max_size):
# 		var pos := index_to_xy(i)
# 		var is_on: bool = data[i]
# 		image.set_pixel(pos.x, pos.y, get_on_off_color(is_on))


# # -------------------------
# # Apply changes to GPU
# # -------------------------

# func update_texture():
# 	texture.update(image)
# 	on_texture_updated.emit(texture)
#endregion
