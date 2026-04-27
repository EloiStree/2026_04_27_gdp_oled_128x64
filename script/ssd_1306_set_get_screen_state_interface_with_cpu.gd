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



static func vector_xy_lrtd_to_index(vec: Vector2i) -> int:
	return xy_lrtd_to_index(vec.x, vec.y)


static func vector_xy_lrdt_to_index(vec: Vector2i) -> int:
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

func get_bool_array()->Array[bool]:
	return screen_state.boolean_state

func inverse_all_boolean_value():
	for i in range(SCREEN_SIZE):
		get_bool_array()[i] = not get_bool_array()[i]

func inverse_boolean_horizontally():
	var array:= get_bool_array()
	for y in range(SCREEN_HEIGHT):
		for x in range(SCREEN_WIDTH / 2):
			var left_index: int = xy_lrtd_to_index(x, y)
			var right_index: int = xy_lrtd_to_index(SCREEN_WIDTH - 1 - x, y)
			var temp: bool = array[left_index]
			array[left_index] = array[right_index]
			array[right_index] = temp

func inverse_boolean_vertically():
	var array:= get_bool_array()
	for x in range(SCREEN_WIDTH):
		for y in range(SCREEN_HEIGHT / 2):
			var top_index: int = xy_lrtd_to_index(x, y)
			var bottom_index: int = xy_lrtd_to_index(x, SCREEN_HEIGHT - 1 - y)
			var temp: bool = array[top_index]
			array[top_index] = array[bottom_index]
			array[bottom_index] = temp


func set_boolean_array_to_full():
	var array:= get_bool_array()
	for i in range(SCREEN_SIZE):
		array[i] = true

func set_boolean_array_to_clear():
	var array:= get_bool_array()
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


#region SETTERS PIXEL PER PIXEL
func set_boolean_with_1d(index: int, is_on: bool):
	if index < 0 or index > SCREEN_SIZE_INDEX_MAX:
		return
	get_bool_array()[index] = is_on

func set_boolean_with_2d_lrtd(x: int, y: int, is_on: bool):
	if x < 0 or x >= SCREEN_WIDTH:
		return
	if y < 0:
		y = 0
	if y >= SCREEN_HEIGHT:
		y = SCREEN_HEIGHT - 1

	var index: int = xy_lrtd_to_index(x, y)
	set_boolean_with_1d(index, is_on)

func set_boolean_with_2d_lrdt(x: int, y: int, is_on: bool):
	if x < 0 or x >= SCREEN_WIDTH:
		return
	if y < 0 or y >= SCREEN_HEIGHT:
		return
	var index: int = xy_lrdt_to_index(x, y)
	set_boolean_with_1d(index, is_on)	

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
	return vector_xy_lrtd_to_index(get_top_left_corner_index_2d_lrtd())
func get_top_right_corner_index_1d() -> int:
	return vector_xy_lrtd_to_index(get_top_right_corner_index_2d_lrtd())
func get_bottom_left_corner_index_1d() -> int:
	return vector_xy_lrtd_to_index(get_bottom_left_corner_index_2d_lrtd())
func get_bottom_right_corner_index_1d() -> int:
	return vector_xy_lrtd_to_index(get_bottom_right_corner_index_2d_lrtd())

#endregion


func set_boolean_to_random_at_1d(index: int):
	if index < 0 or index > SCREEN_SIZE_INDEX_MAX:
		return
	get_bool_array()[index] = randi() % 2 == 0

func set_all_to_random():
	for i in range(SCREEN_SIZE):
		set_boolean_to_random_at_1d(i)

func toggle_1d_value(index: int):
	if index < 0 or index > SCREEN_SIZE_INDEX_MAX:
		return
	get_bool_array()[index] = not get_bool_array()[index]

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
		set_boolean_with_2d_lrtd(target_x, target_y, is_on)


#region BIT OPERATIONS


func _init() -> void:
	if screen_state==null:
		screen_state = SSD1306BooleanStateResource.new()
	screen_state.resize()
	set_boolean_array_to_clear()
		
func override_array_with_boolean_array(source_array: Array[bool]):
	var array := get_bool_array()
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
	var array := get_bool_array()

	new_array.resize(SCREEN_SIZE)
	if loop_border:
		for i in range(SCREEN_SIZE):
			var source_index: int = (i + steps) % SCREEN_SIZE
			new_array[i] = array[source_index]
	else:
		for i in range(SCREEN_SIZE):
			var source_index: int = i + steps
			new_array[i] = array[source_index] if source_index < SCREEN_SIZE else false
	override_array_with_boolean_array(new_array)

func shift_1d_by_steps_right(steps: int, loop_border: bool = true):
	var new_array: Array[bool] = []
	var array := get_bool_array()

	new_array.resize(SCREEN_SIZE)
	if loop_border:
		for i in range(SCREEN_SIZE):
			var source_index: int = (i - steps) % SCREEN_SIZE
			new_array[i] = array[source_index]
	else:
		for i in range(SCREEN_SIZE):
			var source_index: int = i - steps
			new_array[i] = array[source_index] if source_index >= 0 else false
	override_array_with_boolean_array(new_array)


func shift_boolean_array_right(loop_border: bool = true):
	var array := get_bool_array()

	for y in range(SCREEN_HEIGHT):
		var last_value: bool = array[xy_lrtd_to_index(SCREEN_WIDTH - 1, y)]
		for x in range(SCREEN_WIDTH - 1, 0, -1):
			var current_index: int = xy_lrtd_to_index(x, y)
			var previous_index: int = xy_lrtd_to_index(x - 1, y)
			array[current_index] = array[previous_index]		
		array[xy_lrtd_to_index(0, y)] = last_value if loop_border else false

func shift_boolean_array_left(loop_border: bool = true):
	var array := get_bool_array()

	for y in range(SCREEN_HEIGHT):
		var first_value: bool = array[xy_lrtd_to_index(0, y)]
		for x in range(SCREEN_WIDTH - 1):
			var current_index: int = xy_lrtd_to_index(x, y)
			var next_index: int = xy_lrtd_to_index(x + 1, y)
			array[current_index] = array[next_index]
		
		array[xy_lrtd_to_index(SCREEN_WIDTH - 1, y)] = first_value if loop_border else false

func shift_boolean_array_down(loop_border: bool = true):
	var array := get_bool_array()

	for x in range(SCREEN_WIDTH):
		var last_value: bool = 	array[xy_lrtd_to_index(x, SCREEN_HEIGHT - 1)]
		for y in range(SCREEN_HEIGHT - 1, -1, -1):
			var current_index: int = xy_lrtd_to_index(x, y)
			var previous_index: int = xy_lrtd_to_index(x, y - 1)
			array[current_index] = array[previous_index]		


func shift_boolean_array_up(loop_border: bool = true):
	var array := get_bool_array()	
	for x in range(SCREEN_WIDTH):
		var first_value: bool = array[xy_lrtd_to_index(x, 0)]
		for y in range(SCREEN_HEIGHT - 1):
			var current_index: int = xy_lrtd_to_index(x, y)
			var next_index: int = xy_lrtd_to_index(x, y + 1)
			array[current_index] = array[next_index]






#region DRAWING

func draw_bool_center_diamond_v2i_lrdt(point: Vector2i, radius: int, is_on: bool = true):
	for y in range(SCREEN_HEIGHT):
		for x in range(SCREEN_WIDTH):
			var distance_squared: int = (x - point.x) * (x - point.x) + (y - point.y) * (y - point.y)
			if distance_squared <= radius * radius:
				set_boolean_with_2d_lrtd(x, y, is_on)

func draw_bool_center_circle_v2i_lrdt(point: Vector2i, radius: int, is_on: bool = true, fill:bool=true):
	if fill:
		for y in range(point.y - radius, point.y + radius + 1):
			for x in range(point.x - radius, point.x + radius + 1):
				var distance_squared: int = (x - point.x) * (x - point.x) + (y - point.y) * (y - point.y)
				if distance_squared <= radius * radius:
					set_boolean_with_2d_lrtd(x, y, is_on)
	
	for angle in range(0, 360):
		var rad: float = deg_to_rad(angle)
		var x: int = round(point.x + radius * cos(rad))
		var y: int = round(point.y + radius * sin(rad))
		set_boolean_with_2d_lrtd(x, y, is_on)


func draw_bool_center_square_v2i_lrdt(point: Vector2i, half_size: int, is_on: bool = true):
	for y in range(SCREEN_HEIGHT):
		for x in range(SCREEN_WIDTH):
			if abs(x - point.x) <= half_size and abs(y - point.y) <= half_size:
				set_boolean_with_2d_lrtd(x, y, is_on)

func draw_bool_line_v2i_lrdt(start: Vector2i, end: Vector2i, is_on: bool = true):
	
	## alorithm to draw line in 2d array pixel

	var points_on_line: Array[Vector2i] = []
	var magnitude: float = start.distance_to(end)
	if magnitude == 0:
		set_boolean_with_2d_lrtd(start.x, start.y, is_on)
		return
	var direction: Vector2 = (end - start) / magnitude
	var current_point: Vector2 = start
	var traveled_distance: float = 0.0

	while traveled_distance <= magnitude:
		points_on_line.append(Vector2i(round(current_point.x), round(current_point.y)))
		current_point += direction
		traveled_distance += direction.length()
	
	for point in points_on_line:
		set_boolean_with_2d_lrtd(point.x, point.y, is_on)

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
		set_boolean_with_2d_lrtd(left_right, y, is_on)


func draw_bool_horizontal_line_top_down(top_down: int, is_on: bool = true):
	for x in range(SCREEN_WIDTH):
		set_boolean_with_2d_lrtd(x, top_down, is_on)

func draw_bool_vertical_line_right_left(right_left: int, is_on: bool = true):
	for y in range(SCREEN_HEIGHT):
		set_boolean_with_2d_lrtd(right_left, y, is_on)

func draw_bool_horizontal_line_down_top(down_top: int, is_on: bool = true):
	for x in range(SCREEN_WIDTH):
		set_boolean_with_2d_lrtd(x, down_top, is_on)



#endregion

func get_center_point_2d_lrtd() -> Vector2i:
	return Vector2i(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
	
func get_random_point_2d_lrdt() -> Vector2i:
	var x: int = randi() % SCREEN_WIDTH
	var y: int = randi() % SCREEN_HEIGHT
	return Vector2i(x, y)



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
