class_name ScreenBuilderCircle
extends Node

@export var screen:SSD1306NodeFacadeLite
var array:Array[bool]

@export var use_demo_at_ready:bool

func _ready() -> void:
	if use_demo_at_ready:
		array.resize(8192)

func _process(delta: float) -> void:
	if use_demo_at_ready:
		array.fill(false)
		ScreenBuilderPrint6x8.print_text(array,"Hello Circle",true,true)
		ScreenBuilderCircle.draw_circle_at_center(array, Vector2i(0,0),true)
		ScreenBuilderCircle.draw_circle_from_to_fit(array, Vector2i(0,0),Vector2i(127,63),true)
		screen.set_value_with_1d_array_and_draw(array)

static func convert_2d_1d(vector:Vector2i)->int:
	return vector.y*128+vector.x

static func set_value_at_x_y_lrtd(array:Array[bool],x, y, is_on):
	if x>127 or x<0 or y>63 or y<0:
		return 
	
	array[y*128+x]=is_on
static func set_value_at_x_y_lrdt(array:Array[bool],x, y, is_on):
	if x>127 or x<0 or y>63 or y<0:
		return 
	array[(63-y)*128+x]=is_on

static func set_value_at_v2i_lrtd(array:Array[bool],vector:Vector2i,is_on:bool):
	if vector.x>127 or vector.x<0 or vector.y>63 or vector.y<0:
		return 
	array[vector.y*128+vector.x] =is_on
static func set_value_at_v2i_lrdt(array:Array[bool],vector:Vector2i,is_on:bool):
	if vector.x>127 or vector.x<0 or vector.y>63 or vector.y<0:
		return 
	array[(63-vector.y)*128+vector.x] =is_on
		
static func draw_circle_from_to_fit(array:Array[bool],from: Vector2i,to: Vector2i, is_on: bool = true, fill:bool=true):
	var point:Vector2i = (from+to)/2.0
	var width = abs(from.x-to.x)
	var height = abs(from.y-to.y)
	var radius = width/2.0 if height>width else height/2.0
	draw_circle_at_center(array,point,radius, is_on,fill)
	
static func draw_circle_at_center(array:Array[bool],point: Vector2i, radius: int, is_on: bool = true, fill:bool=true):
	if fill:
		for y in range(point.y - radius, point.y + radius + 1):
			for x in range(point.x - radius, point.x + radius + 1):
				var distance_squared: int = (x - point.x) * (x - point.x) + (y - point.y) * (y - point.y)
				if distance_squared <= radius * radius:
					set_value_at_x_y_lrdt(array,x, y, is_on)
	
	for angle in range(0, 360):
		var rad: float = deg_to_rad(angle)
		var x: int = round(point.x + radius * cos(rad))
		var y: int = round(point.y + radius * sin(rad))
		set_value_at_x_y_lrdt(array,x, y, is_on)
	
