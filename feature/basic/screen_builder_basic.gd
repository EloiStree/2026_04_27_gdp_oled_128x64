class_name ScreenBuilderBasic
extends Node

# --- 2D <-> 1D conversion ---
static func convert_2d_xy_to_1d(x_0_127: int, y_0_63: int) -> int:
	return y_0_63 * 128 + x_0_127

static func convert_2d_v2i_to_1d(point: Vector2i) -> int:
	return point.y * 128 + point.x

static func convert_1d_to_v2i_2d(index_0_8191: int) -> Vector2i:
	var x = index_0_8191 % 128
	var y = index_0_8191 / 128
	return Vector2i(x, y)

# --- Bounds checking ---
static func is_out_of_bound_1d_v2i(index_0_8191: int) -> bool:
	return index_0_8191 < 0 or index_0_8191 > 8191

static func is_out_of_bound_2d_v2i(point: Vector2i) -> bool:
	return point.x < 0 or point.y < 0 or point.x > 127 or point.y > 63

static func is_out_of_bound_2d_xy(x_0_127: int, y_0_63: int) -> bool:
	return x_0_127 < 0 or y_0_63 < 0 or x_0_127 > 127 or y_0_63 > 63


# --- 1D access ---
static func set_as_1d_to(array: Array[bool], index_0_8191: int, value: bool = true) -> void:
	if is_out_of_bound_1d_v2i(index_0_8191):
		return
	array[index_0_8191] = value

static func get_as_1d_to(array: Array[bool], index_0_8191: int) -> bool:
	if is_out_of_bound_1d_v2i(index_0_8191):
		return false
	return array[index_0_8191]

# --- 2D XY access ---
static func set_as_xy_to(array: Array[bool], x_0_127: int, y_0_63: int, value: bool = true) -> void:
	if is_out_of_bound_2d_xy(x_0_127, y_0_63):
		return
	array[convert_2d_xy_to_1d(x_0_127, y_0_63)] = value

static func get_as_xy_to(array: Array[bool], x_0_127: int, y_0_63: int) -> bool:
	if is_out_of_bound_2d_xy(x_0_127, y_0_63):
		return false
	return array[convert_2d_xy_to_1d(x_0_127, y_0_63)]

# --- Vector2i access ---
static func set_as_v2i_to(array: Array[bool], point: Vector2i, value: bool = true) -> void:
	if is_out_of_bound_2d_v2i(point):
		return
	array[convert_2d_v2i_to_1d(point)] = value

static func get_as_v2i_to(array: Array[bool], point: Vector2i) -> bool:
	if is_out_of_bound_2d_v2i(point):
		return false
	return array[convert_2d_v2i_to_1d(point)]

# --- Array manipulation ---
static func full(array: Array[bool]) -> void:
	array.fill(true)

static func clear(array: Array[bool]) -> void:
	array.fill(false)

static func inverse(array: Array[bool]) -> void:
	for i in range(array.size()):
		array[i] = not array[i]

static func draw_grid_1x1(array: Array[bool]) -> void:
	for x in range(128):
		for y in range(64):
			var is_on: bool = x % 2 == 0
			if y % 2 == 0:
				is_on = not is_on
			array[convert_2d_xy_to_1d(x, y)] = is_on
			
			
			
			
