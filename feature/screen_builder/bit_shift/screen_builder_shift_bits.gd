class_name ScreenBuilderShiftBits
extends Node

const SCREEN_SIZE = 128 * 64
const SCREEN_WIDTH = 128
const SCREEN_HEIGHT = 64

static func shift_2d_up_left(array: Array[bool], loop_border: bool = true):
	var temp_storage: Array[bool] = []
	
	# Store the diagonal elements that will wrap around
	if loop_border:
		var diagonal_length = min(SCREEN_WIDTH, SCREEN_HEIGHT)
		for i in range(diagonal_length):
			temp_storage.append(array[xy_lrtd_to_index(i, i)])
	
	# Shift each row left and up
	for y in range(SCREEN_HEIGHT):
		for x in range(SCREEN_WIDTH):
			var next_x = x + 1
			var next_y = y + 1
			if next_x < SCREEN_WIDTH and next_y < SCREEN_HEIGHT:
				array[xy_lrtd_to_index(x, y)] = array[xy_lrtd_to_index(next_x, next_y)]
	
	# Handle wrap-around
	if loop_border:
		var diagonal_length = min(SCREEN_WIDTH, SCREEN_HEIGHT)
		for i in range(diagonal_length):
			var last_x = SCREEN_WIDTH - diagonal_length + i
			var last_y = SCREEN_HEIGHT - diagonal_length + i
			if last_x < SCREEN_WIDTH and last_y < SCREEN_HEIGHT:
				array[xy_lrtd_to_index(last_x, last_y)] = temp_storage[i]
	else:
		# Fill edges with false
		for y in range(SCREEN_HEIGHT):
			array[xy_lrtd_to_index(SCREEN_WIDTH - 1, y)] = false
		for x in range(SCREEN_WIDTH):
			array[xy_lrtd_to_index(x, SCREEN_HEIGHT - 1)] = false

static func shift_2d_up_right(array: Array[bool], loop_border: bool = true):
	var temp_storage: Array[bool] = []
	
	# Store the diagonal elements that will wrap around
	if loop_border:
		var diagonal_length = min(SCREEN_WIDTH, SCREEN_HEIGHT)
		for i in range(diagonal_length):
			temp_storage.append(array[xy_lrtd_to_index(SCREEN_WIDTH - 1 - i, i)])
	
	# Shift each row right and up
	for y in range(SCREEN_HEIGHT):
		for x in range(SCREEN_WIDTH - 1, -1, -1):
			var next_x = x - 1
			var next_y = y + 1
			if next_x >= 0 and next_y < SCREEN_HEIGHT:
				array[xy_lrtd_to_index(x, y)] = array[xy_lrtd_to_index(next_x, next_y)]
	
	# Handle wrap-around
	if loop_border:
		var diagonal_length = min(SCREEN_WIDTH, SCREEN_HEIGHT)
		for i in range(diagonal_length):
			var last_x = diagonal_length - 1 - i
			var last_y = SCREEN_HEIGHT - diagonal_length + i
			if last_x >= 0 and last_y < SCREEN_HEIGHT:
				array[xy_lrtd_to_index(last_x, last_y)] = temp_storage[i]
	else:
		# Fill edges with false
		for y in range(SCREEN_HEIGHT):
			array[xy_lrtd_to_index(0, y)] = false
		for x in range(SCREEN_WIDTH):
			array[xy_lrtd_to_index(x, SCREEN_HEIGHT - 1)] = false

static func shift_2d_down_left(array: Array[bool], loop_border: bool = true):
	var temp_storage: Array[bool] = []
	
	# Store the diagonal elements that will wrap around
	if loop_border:
		var diagonal_length = min(SCREEN_WIDTH, SCREEN_HEIGHT)
		for i in range(diagonal_length):
			temp_storage.append(array[xy_lrtd_to_index(i, SCREEN_HEIGHT - 1 - i)])
	
	# Shift each row left and down
	for y in range(SCREEN_HEIGHT - 1, -1, -1):
		for x in range(SCREEN_WIDTH):
			var next_x = x + 1
			var next_y = y - 1
			if next_x < SCREEN_WIDTH and next_y >= 0:
				array[xy_lrtd_to_index(x, y)] = array[xy_lrtd_to_index(next_x, next_y)]
	
	# Handle wrap-around
	if loop_border:
		var diagonal_length = min(SCREEN_WIDTH, SCREEN_HEIGHT)
		for i in range(diagonal_length):
			var last_x = SCREEN_WIDTH - diagonal_length + i
			var last_y = i
			if last_x < SCREEN_WIDTH and last_y >= 0:
				array[xy_lrtd_to_index(last_x, last_y)] = temp_storage[i]
	else:
		# Fill edges with false
		for y in range(SCREEN_HEIGHT):
			array[xy_lrtd_to_index(SCREEN_WIDTH - 1, y)] = false
		for x in range(SCREEN_WIDTH):
			array[xy_lrtd_to_index(x, 0)] = false

static func shift_2d_down_right(array: Array[bool], loop_border: bool = true):
	var temp_storage: Array[bool] = []
	
	# Store the diagonal elements that will wrap around
	if loop_border:
		var diagonal_length = min(SCREEN_WIDTH, SCREEN_HEIGHT)
		for i in range(diagonal_length):
			temp_storage.append(array[xy_lrtd_to_index(SCREEN_WIDTH - 1 - i, SCREEN_HEIGHT - 1 - i)])
	
	# Shift each row right and down
	for y in range(SCREEN_HEIGHT - 1, -1, -1):
		for x in range(SCREEN_WIDTH - 1, -1, -1):
			var next_x = x - 1
			var next_y = y - 1
			if next_x >= 0 and next_y >= 0:
				array[xy_lrtd_to_index(x, y)] = array[xy_lrtd_to_index(next_x, next_y)]
	
	# Handle wrap-around
	if loop_border:
		var diagonal_length = min(SCREEN_WIDTH, SCREEN_HEIGHT)
		for i in range(diagonal_length):
			var last_x = i
			var last_y = i
			if last_x < SCREEN_WIDTH and last_y < SCREEN_HEIGHT:
				array[xy_lrtd_to_index(last_x, last_y)] = temp_storage[i]
	else:
		# Fill edges with false
		for y in range(SCREEN_HEIGHT):
			array[xy_lrtd_to_index(0, y)] = false
		for x in range(SCREEN_WIDTH):
			array[xy_lrtd_to_index(x, 0)] = false

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
