
class_name SSD1306BuilderQrCode
extends Node


@export var drawer: SSD1306SetGetScreenStateInterfaceWithCPU


func display_at_left_center_with_flush(text:String):

	drawer.flush_and_emit()
	display_at_left_center(text)

func display_at_left_center(text:String):
	
	var inverse:bool = text.begins_with("inverse")
	if inverse:
		text = text.substr(7, text.length())
		
	var qr_code: SSD1306QrCode = SSD1306QrCode.new()
	qr_code.error_correct_level = SSD1306QrCode.ErrorCorrectionLevel.LOW
	var texture: ImageTexture = qr_code.get_texture(text)
	var image: Image = texture.get_image()
	if inverse:
		image = inverse_image_color(image)
	drawer.draw_bool_image_2d_at_center_left(image,0.5)
	qr_code.queue_free() # clean up to avoid leaks	
	pass

func inverse_image_color(image:Image):
	# inverse color of the image
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			var color: Color = image.get_pixel(x, y)
			color.r = 1.0 - color.r
			color.g = 1.0 - color.g
			color.b = 1.0 - color.b
			image.set_pixel(x, y, color)
	return image
	
