class_name SSD1306ParseImageToBoolean
extends Node
signal on_image_parsed(width:int, binary_image : Array[bool])
func image_to_parse_and_emit(image:Texture2D)->Array[bool]:
	var array:=convert_image_to_boolean_1d_array(image)
	var width = image.get_width()
	on_image_parsed.emit(width, array)
	return array

func image_to_parse(image:Texture2D)->Array[bool]:
	return convert_image_to_boolean_1d_array(image)

static func convert_image_to_boolean_1d_array(image:Texture2D)->Array[bool]:
	var result:Array[bool] =[]	
	var img:Image = image.get_image()
	#img.lock()
	for y in range(img.get_height()):
		for x in range(img.get_width()):
			var color:Color = img.get_pixel(x, y)
			var is_transparent:bool = color.a <=0.2
			var is_white:bool = color.r > 0.9 and color.g > 0.9 and color.b > 0.9
			var is_on:bool = true
			if is_transparent or is_white:
				is_on = false	
			result.append(is_on)
	#img.unlock()
	return result
