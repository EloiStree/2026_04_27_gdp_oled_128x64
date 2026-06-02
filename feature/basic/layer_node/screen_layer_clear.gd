class_name ScreenLayerClear
extends SSD1306ModLiteLayerWithTagName

@export var value_to_draw:=true
func append_layer(array_128x64: Array[bool]) -> void:
	array_128x64.fill(value_to_draw)
