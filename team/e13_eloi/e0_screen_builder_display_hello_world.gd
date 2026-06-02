class_name E0ScreenBuilderDisplayHelloWorld
extends Node

@export var screen: SSD1306NodeFacadeLite
var array:Array[bool]
func _ready() -> void:
	array.resize(8192)
	array.fill(false)
	
	var position:Vector2i = Vector2i(5,5) 
	var text:String = "Hello World ;)"
	E13ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(
		array,position,text,true, true)
	
	screen.set_value_with_1d_array_and_draw(array)
	
