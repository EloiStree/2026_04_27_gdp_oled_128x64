class_name ScreenBuilderCircleLayerDemo
extends SSD1306ModLiteLayerWithTagName



func append_layer(array: Array[bool]) -> void:
	if not is_layer_enabled:
		return
	ScreenBuilderPrint6x8.print_text(array,"Hello Circle",true,true)
	ScreenBuilderCircle.draw_circle_at_center(array, Vector2i(0,0),true)
	ScreenBuilderCircle.draw_circle_from_to_fit(array, Vector2i(0,0),Vector2i(127,63),true)

	
