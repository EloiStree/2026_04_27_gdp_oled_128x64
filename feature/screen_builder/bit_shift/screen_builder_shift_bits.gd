class_name ScreenBuilderShiftBits
extends Node
const SCREEN_HEIGHT = 64
const SCREEN_WIDTH = 128
const SCREEN_SIZE = 128 * 64

static func xy_to_index(x: int, y: int) -> int:
	return y * SCREEN_WIDTH + x

# Helper to get source position with optional wrap
static func get_source_pos(x: int, y: int, dx: int, dy: int, loop: bool) -> Vector2i:
	var src_x = x + dx
	var src_y = y + dy
	
	if loop:
		src_x = (src_x + SCREEN_WIDTH) % SCREEN_WIDTH
		src_y = (src_y + SCREEN_HEIGHT) % SCREEN_HEIGHT
	else:
		if src_x < 0 or src_x >= SCREEN_WIDTH or src_y < 0 or src_y >= SCREEN_HEIGHT:
			return Vector2i(-1, -1)  # invalid = use false
	
	return Vector2i(src_x, src_y)

# Generic diagonal shift
static func shift_2d_diagonal(array: Array[bool], dx: int, dy: int, loop_border: bool = true):
	var new_array: Array[bool] = array.duplicate()
	
	for y in range(SCREEN_HEIGHT):
		for x in range(SCREEN_WIDTH):
			var src = get_source_pos(x, y, dx, dy, loop_border)
			
			if src.x == -1:
				array[xy_to_index(x, y)] = false
			else:
				array[xy_to_index(x, y)] = new_array[xy_to_index(src.x, src.y)]
	
static func shift_2d_up_left(array: Array[bool], loop_border: bool = true):
	shift_2d_diagonal(array, 1, 1, loop_border)   # Pattern moves up-left


static func shift_2d_up_right(array: Array[bool], loop_border: bool = true):
	shift_2d_diagonal(array, -1, 1, loop_border)  # Pattern moves up-right


static func shift_2d_down_left(array: Array[bool], loop_border: bool = true):
	shift_2d_diagonal(array, 1, -1, loop_border)  # Pattern moves down-left


static func shift_2d_down_right(array: Array[bool], loop_border: bool = true):
	shift_2d_diagonal(array, -1, -1, loop_border) # Pattern moves down-right


















static func shift_1d_right(array: Array[bool], loop_border: bool = true):
	var first_value = array[0]
	for j in range(SCREEN_SIZE - 1):
		array[j] = array[j + 1]
	array[SCREEN_SIZE - 1] = first_value if loop_border else false

static func shift_1d_left(array: Array[bool], loop_border: bool = true):
	var last_value = array[SCREEN_SIZE - 1]
	for j in range(SCREEN_SIZE - 1, 0, -1):
		array[j] = array[j - 1]
	array[0] = last_value if loop_border else false

static func xy_lrtd_to_index(x: int, y: int) -> int:
	return y * SCREEN_WIDTH + x

static func shift_2d_down(array: Array[bool], loop_border: bool = true):
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

static func shift_2d_left(array: Array[bool], loop_border: bool = true):
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

static func shift_2d_right(array: Array[bool], loop_border: bool = true):
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

static func shift_2d_up(array: Array[bool], loop_border: bool = true):
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
