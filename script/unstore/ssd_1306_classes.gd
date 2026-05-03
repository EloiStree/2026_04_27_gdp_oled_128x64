class_name SSD1306Classes
extends Resource


class Adafruit_SSD1306_h:
	pass

class SSD1306Ascii_h:
	pass
	
	
	

#
#@export var oled: SensorModelBoolDisplay128x64CPU
#
## Adafruit_SSD1306.h
## SSD1306Ascii
#
##region SSD1306Ascii
#
##endregion
#
##region Adafruit_SSD1306.h
#func display_draw_buffer():
	#oled.emit_boolean_array_as_updated()
#
#func display_clear_display():
	#oled.set_boolean_array_to_clear()
#
#func display_full_display():
	#oled.set_boolean_array_to_full()
#
#func display_draw_pixel( x: int, y: int, is_on: bool):
	#oled.set_boolean_with_2d_lrtd(x, y, is_on)
#
#func display_draw_rectangle(x: int, y: int, width: int, height: int, is_on: bool):
	#pass 
#
##endregion
#
#
##region NOTE
#"""
  #oled.setFont(System5x7);
  #oled.clear();
  #oled.print("Hello world!");
#
#drawLine
#drawFastVLine
#drawFastHLine
#drawRect
#fillRect
#drawRoundRect
#fillRoundRect
#drawCircle
#fillCircle
#drawTriangle
#fillTriangle
#clearDisplay
#setCursor(x,y)
#print("Hello World")
#display()
#
#setRotation(0,1,2,3)
#setTextSize(2)
#steTextColor()
#println("test")
#drawChar()
#"""
#
#func draw_pixel(x: int, y: int, is_on: bool):
	#oled.set_boolean_with_2d_lrtd(x, y, is_on)
#
#func draw_horizotonal_line(x: int, y: int, width: int, is_on: bool):
	#for i in range(width):
		#oled.set_boolean_with_2d_lrtd(x + i, y, is_on)
#
#func draw_vertical_line(x: int, y: int, height: int, is_on: bool):
	#for i in range(height):
		#oled.set_boolean_with_2d_lrtd(x, y + i, is_on)
#
#
#func draw_line(x0: int, y0: int, x1: int, y1: int, is_on: bool):
	#pass 
#
#
#
#
#func get_height():
	#return oled.SCREEN_HEIGHT
#
#func get_width():
	#return oled.SCREEN_WIDTH	
#
#func get_bool_state(x: int, y: int) -> bool:
	#return oled.get_boolean_with_2d_lrtd(x, y)
#
#func get_cursor_x():
	#pass
#
#func get_cursor_y():
	#pass
#
#func draw_fast_horizontal_line(x: int, y: int, width: int, is_on: bool):
	##drawFastHLine(x, y, width, is_on#)
	#pass
#
#func draw_fast_vertical_line(x: int, y: int, height: int, is_on: bool):
	##drawFastVLine(x, y, height, is_on#)
	#pass
#
#
#func draw_rectangle(x: int, y: int, width: int, height: int, is_on: bool):
	#draw_horizotonal_line(x, y, width, is_on)
	#draw_horizotonal_line(x, y + height - 1, width, is_on)
	#draw_vertical_line(x, y, height, is_on)
	#draw_vertical_line(x + width - 1, y, height, is_on)
#
#func fill_rectangle(x: int, y: int, width: int, height: int, is_on: bool):
	#for i in range(height):
		#draw_horizotonal_line(x, y + i, width, is_on)
#
#func draw_round_rectangle(x: int, y: int, width: int, height: int, radius: int, is_on: bool):
	#pass
#
#func fill_round_rectangle(x: int, y: int, width: int, height: int, radius: int, is_on: bool):
	#pass
#
#func draw_circle(x: int, y: int, radius: int, is_on: bool):
	#pass
#
#func fill_circle(x: int, y: int, radius: int, is_on: bool):
	#pass
#
#
##> Circles. Useful for icons, indicators, or reminding yourself geometry exists.
#
#func draw_triangle(x0: int, y0: int, x1: int, y1: int, x2: int, y2: int, is_on: bool):
	#pass	
#
#func fill_triangle(x0: int, y0: int, x1: int, y1: int, x2: int, y2: int, is_on: bool):
	#pass
#
#
#func set_cursor(x: int, y: int):
	#pass
#
#
#func set_text_size(size: int):
	#pass
#
#
#func display_print(text: String):
	#pass
#
#func display_println(text: String):
	#pass
#
#func draw_char(x: int, y: int, char: String, is_on: bool, background: bool, size: int):
	#pass
	#
#
#func invert_display(is_inverted: bool):
	#pass
#
#func clear_display():
	#pass
#
#
#func display():
	#pass
#
#
### Remapping cooridnate function for all ?
#func set_rotation(rotation: int):
	## This one is a nightmare xD
	#pass
#
#
#func draw_bitmap_with_bytes(x: int, y: int, bitmap: PackedByteArray, width: int, height: int, is_on: bool):
	### MSB first
	#pass
#
#func draw_bitmap_with_bit(x: int, y: int, bitmap: Array[bool], width: int, height: int, is_on: bool):
	#pass
#
#func draw_bitmap_from_text(x: int, y: int, text: String, width: int, height: int, is_on: bool):
	#pass
#
#func draw_full_text_image_wiht_1_0(text: String):
	#pass
