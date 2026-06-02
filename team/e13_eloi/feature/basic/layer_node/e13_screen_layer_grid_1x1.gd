class_name E13ScreenLayerGrid1x1
extends SSD1306ModLiteLayerWithTagName

func append_layer(array_128x64: Array[bool]) -> void:
	E13ScreenBuilderBasic.draw_grid_1x1(array_128x64)
