
class_name ScreenBuilderQrCode
extends Node

static func display_at_left_center_with_flush(array:Array[bool],text:String):
	display_at_left_center(array,text)

static func display_at_left_center(array:Array[bool],text:String):
	
	var inverse:bool = text.begins_with("inverse")
	if inverse:
		text = text.substr(7, text.length())
		
	var qr_code: SSD1306QrCode = SSD1306QrCode.new()
	qr_code.error_correct_level = SSD1306QrCode.ErrorCorrectionLevel.LOW
	var texture: ImageTexture = qr_code.get_texture(text)
	var image: Image = texture.get_image()
	if inverse:
		image = inverse_image_color(array,image)
	ScreenBuilderDrawImage.draw_image_2d_at_center_left(array,image,0.5)
	qr_code.queue_free() # clean up to avoid leaks	
	pass

static func inverse_image_color(array:Array[bool],  image:Image):
	# inverse color of the image
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			var color: Color = image.get_pixel(x, y)
			color.r = 1.0 - color.r
			color.g = 1.0 - color.g
			color.b = 1.0 - color.b
			image.set_pixel(x, y, color)
	return image
	
static func draw_bool_image_2d_center_at_point_lrtd(array:Array[bool],x_left_right: int, y_top_down: int, image: Image, threshold: float = 1.0):
	if image == null:
		return 
	var width: int = image.get_width()
	var height: int = image.get_height()
	var offset_x: float = width / 2.0
	var offset_y: float = height / 2.0
	var top_left_x: int = x_left_right - offset_x
	var top_left_y: int = y_top_down - offset_y
	ScreenBuilderDrawImage.draw_image_2d_lrtd(array,top_left_x, top_left_y, image, threshold)
