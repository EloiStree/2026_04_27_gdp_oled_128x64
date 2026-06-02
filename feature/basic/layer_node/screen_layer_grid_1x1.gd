class_name ScreenLayerGrid1x1
extends SSD1306ModLiteLayerWithTagName

func append_layer(array_128x64: Array[bool]) -> void:
	ScreenBuilderBasic.draw_grid_1x1(array_128x64)
