class_name SensorViewDisplay128x64CPU
extends Node


signal on_texture_material_updated(index:int, material_surface:Material)
signal on_texture_updated(texture: Texture2D)

@export var color_on: Color = Color(0.0, 0.734, 0.699, 1.0)   # OLED green
@export var color_off: Color = Color(0, 0, 0, 1)  # background

const SCREEN_WIDTH: int = 128
const SCREEN_HEIGHT: int = 64
const SCREEN_SIZE: int = SCREEN_WIDTH * SCREEN_HEIGHT
const SCREEN_SIZE_INDEX_MAX: int = SCREEN_SIZE - 1

var texture_2d: Texture2D

@export var use_mipmaps: bool = false
@export var material_to_duplicate: StandardMaterial3D
@export var material_duplicated: StandardMaterial3D

var bool_array_clear: Array[bool] = []
var bool_array_full: Array[bool] = []

func _ready():
	bool_array_clear.resize(SCREEN_SIZE)
	bool_array_full.resize(SCREEN_SIZE)
	for i in range(SCREEN_SIZE):
		bool_array_clear[i] = false
		bool_array_full[i] = true

	material_duplicated = material_to_duplicate.duplicate() as StandardMaterial3D
	var image = Image.create(SCREEN_WIDTH, SCREEN_HEIGHT, false, Image.FORMAT_RGB8)
	texture_2d = ImageTexture.create_from_image(image)
	material_duplicated.albedo_texture = texture_2d
	
	set_texture_with_boolean_array(bool_array_clear)

func set_boolean_array_to_full():
	for i in range(SCREEN_SIZE):
		bool_array_full[i] = true

func set_boolean_array_to_clear():
	for i in range(SCREEN_SIZE):
		bool_array_clear[i] = false


func get_on_off_color(is_on: bool) -> Color:
	return color_on if is_on else color_off



func set_texture_with_boolean_array(display_as_boolean_array: Array[bool]):
	var image = Image.create(SCREEN_WIDTH, SCREEN_HEIGHT, false, Image.FORMAT_RGB8)
	for i in range(SCREEN_SIZE):
		var pos := index_to_xy(i)
		var is_on: bool = display_as_boolean_array[i]
		var color = get_on_off_color(is_on)
		image.set_pixel(pos.x, pos.y, color)

	texture_2d = ImageTexture.create_from_image(image)
	on_texture_updated.emit(texture_2d)
	on_texture_material_updated.emit(0, material_duplicated)

func set_texture_with_bit_array(bit_pack_as_bytes:PackedByteArray):
	# expects width * height bits, packed as bytes (8 bits per byte)
	var total_bits = bit_pack_as_bytes.size() * 8
	var max_size = min(total_bits, SCREEN_SIZE)
	var result_array: Array[bool] = []
	
	for i in range(max_size):
		var byte_index = i / 8
		var bit_index = i % 8
		var is_on: bool = (bit_pack_as_bytes[byte_index] & (1 << bit_index)) != 0
		result_array.append(is_on)
	
	set_texture_with_boolean_array(result_array)
	

	
func index_to_xy(index: int) -> Vector2i:
	var x: int = index % SCREEN_WIDTH
	var y: int = index / SCREEN_WIDTH
	return Vector2i(x, y)


func xy_to_index(x: int, y: int) -> int:
	return y * SCREEN_WIDTH + x
