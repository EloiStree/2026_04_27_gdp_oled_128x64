
class_name SSD1306BuilderQrCode
extends Node


@export var drawer: SSD1306SetGetScreenStateInterfaceWithCPU


func display_at_left_top_corner_lrtd(text:String):

	drawer.flush_and_emit()
	var qr_code: SSD1306QrCode = SSD1306QrCode.new()
	qr_code.error_correct_level = SSD1306QrCode.ErrorCorrectionLevel.LOW
	var texture: ImageTexture = qr_code.get_texture(text)
	var image: Image = texture.get_image()
	drawer.draw_bool_image_2d_at_center_left(image,0.5)
	qr_code.queue_free() # clean up to avoid leaks	
	pass
