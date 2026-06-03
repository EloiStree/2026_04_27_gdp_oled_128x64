## CREATED DURING TRAIN TRAVEL.
## NEED TO BE RESTEST AND TAKE TIME ON THIS ONE.
class_name ScreenBuilderDrawImage
extends Node

const SCREEN_SIZE: int = 128*64
const SCREEN_SIZE_INDEX_MAX: int = (128*64)- 1
const SCREEN_WIDTH=64
const SCREEN_HEIGHT=128

static func xy_lrtd_to_index(x: int, y: int) -> int:
	return y * SCREEN_WIDTH + x	

static func xy_lrdt_to_index(x: int, y: int) -> int:
	return (SCREEN_HEIGHT - 1 - y) * SCREEN_WIDTH + x


static func draw_texture_2d_lrtd(array:Array[bool],x_left_right: int, y_top_down: int, texture: Texture2D, threshold: float = 1.0):
	if texture == null:
		return
	var image: Image = texture.get_image()
	draw_image_2d_lrtd(array,x_left_right, y_top_down, image, threshold)

static func draw_image_texture_2d_lrtd(array:Array[bool],x_left_right: int, y_top_down: int, image_texture: ImageTexture, threshold: float = 1.0):
	if image_texture == null:
		return 
	var image: Image = image_texture.get_image()
	draw_image_2d_lrtd(array,x_left_right, y_top_down, image, threshold)

static func is_color_white_threshold(color:Color, threshold:float):
	return color.r >= threshold and color.g >= threshold and color.b >= threshold

static func is_color_white(color: Color) -> bool:
	return color.r >= 0.5 and color.g >= 0.5 and color.b >= 0.5

static func is_color_transparent(color: Color, alpha_threshold: float) -> bool:
	return color.a < alpha_threshold

static func set_value_at_index_1d(array:Array[bool], index_0_8191:int, is_on:bool):
	if index_0_8191 < 0 or index_0_8191 > SCREEN_SIZE_INDEX_MAX:
		return
	array[index_0_8191] = is_on

static func set_value_at_x_y_lrtd(array:Array[bool],x_left_right:int,y_top_down:int, is_on:bool):
	if x_left_right < 0 or x_left_right >= SCREEN_WIDTH:
		return
	if y_top_down < 0:
		y_top_down = 0
	if y_top_down >= SCREEN_HEIGHT:
		y_top_down = SCREEN_HEIGHT - 1

	var index: int = xy_lrtd_to_index(x_left_right, y_top_down)
	set_value_at_index_1d(array,index, is_on)


static func draw_image_2d_lrtd(array:Array[bool],x_left_right: int, y_top_down: int, image: Image, threshold: float = 1.0):
	var width: int = image.get_width()
	var height: int = image.get_height()
	for y in range(height):
		for x in range(width):
			var color: Color = image.get_pixel(x, y)
			var is_white_not_transparent: bool = is_color_white_threshold(color,threshold) #and not is_color_transparent(color, alpha)
			set_value_at_x_y_lrtd(array,x_left_right + x, y_top_down + y, is_white_not_transparent)
	image = null


static func draw_image_2d_center_at_point_lrtd(array:Array[bool],x_left_right: int, y_top_down: int, image: Image, threshold: float = 1.0):
	if image == null:
		return 
	var width: int = image.get_width()
	var height: int = image.get_height()
	var offset_x: float = width / 2.0
	var offset_y: float = height / 2.0
	var top_left_x: int = x_left_right - offset_x
	var top_left_y: int = y_top_down - offset_y
	draw_image_2d_lrtd(array,top_left_x, top_left_y, image, threshold)

static func draw_image_2d_at_center(array:Array[bool],image: Image, threshold: float = 1.0):
	if image == null:
		return 
	draw_image_2d_center_at_point_lrtd(array,64,32, image, threshold)

static func draw_image_2d_at_center_left(array:Array[bool],image: Image, threshold: float = 1.0):
	if image == null:
		return 
	draw_image_2d_center_at_point_lrtd(array,32,32, image, threshold)

static func draw_image_2d_at_center_right(array:Array[bool],image: Image, threshold: float = 1.0):
	if image == null:
		return 
	draw_image_2d_center_at_point_lrtd(array,96,32, image, threshold)
