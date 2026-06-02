class_name ScreenBuilderLineFromTo
extends Node

@export var screen:SSD1306NodeFacadeLite
var array:Array[bool]

@export var use_demo_at_ready:bool

func _ready() -> void:
	if use_demo_at_ready:
		array.resize(8192)

func _process(delta: float) -> void:
	if use_demo_at_ready:
		ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(array,Vector2i.ZERO,"Hello World",true,true)
		ScreenBuilderLineFromTo.draw_line_radius_from_to(array, Vector2i(10,10),Vector2i(50,50),true)
		ScreenBuilderLineFromTo.draw_line_radius_from_to(array, Vector2i(20,20),Vector2i(10,10),false)
		ScreenBuilderLineFromTo.draw_line_from_to(array, Vector2i(0,0),Vector2i(127,63),true)
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
		
static func draw_line_from_to(array:Array[bool], from:Vector2i, to:Vector2i, is_on:bool):
	var points_on_line: Array[Vector2i] = []
	var magnitude: float = from.distance_to(to)
	if magnitude == 0:
		set_value_at_v2i_lrtd(array,from, is_on)
		return
	var direction: Vector2 = (to - from) / magnitude
	var current_point: Vector2 = from
	var traveled_distance: float = 0.0

	while traveled_distance <= magnitude:
		points_on_line.append(Vector2i(round(current_point.x), round(current_point.y)))
		current_point += direction
		traveled_distance += direction.length()
	
	for point in points_on_line:
		set_value_at_v2i_lrtd(array,point, is_on)

static func draw_line_radius_from_to(array:Array[bool],start: Vector2i, end: Vector2i, is_on: bool = true, radius: int = 2):
	
	var points_on_line: Array[Vector2i] = []
	var magnitude: float = start.distance_to(end)
	if magnitude == 0:
		draw_circle_at_center(array,start, 2, is_on, true)
		return
	var direction: Vector2 = (end - start) / magnitude
	var current_point: Vector2 = start
	var traveled_distance: float = 0.0

	while traveled_distance <= magnitude:
		points_on_line.append(Vector2i(round(current_point.x), round(current_point.y)))
		current_point += direction
		traveled_distance += direction.length()

	for point in points_on_line:
		draw_circle_at_center(array,point, radius, is_on, true)

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
