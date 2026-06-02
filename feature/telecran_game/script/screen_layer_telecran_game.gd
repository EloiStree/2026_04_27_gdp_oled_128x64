class_name ScreenLayerTelecranGame
extends SSD1306ModLiteLayerWithTagName


@export var current_cursor:Vector2 = Vector2(64, 32)

@export var array:Array[bool] 


func _ready() -> void:
	array.resize(8192)


func move_cursor_at(position:Vector2):
	var start :Vector2= Vector2(current_cursor.x, current_cursor.y)
	current_cursor = position
	var start_int :Vector2i=Vector2i(start.x, start.y)
	var current_cursor_int :Vector2i=Vector2i(current_cursor.x, current_cursor.y)
	ScreenBuilderLineFromTo.draw_line_from_to(array,start_int, current_cursor_int,true)
	clamp_cursor()

func move_cursor_up_right( movement:Vector2):
	var start :Vector2= Vector2(current_cursor.x, current_cursor.y)
	current_cursor.y-=movement.y
	current_cursor.x+=movement.x
	var start_int :Vector2i=Vector2i(start.x, start.y)
	var current_cursor_int :Vector2i=Vector2i(current_cursor.x, current_cursor.y)
	ScreenBuilderLineFromTo.draw_line_from_to(array,start_int, current_cursor_int,true)
	clamp_cursor()

func clamp_cursor():
	current_cursor.x=clamp(current_cursor.x, 0, 127)
	current_cursor.y=clamp(current_cursor.y, 0, 63)
	
func move_cursor_up(pixel_to_move:float):	
	move_cursor_at(Vector2(0, current_cursor.y - pixel_to_move))

func move_cursor_right(pixel_to_move:float):
	move_cursor_at(Vector2(current_cursor.x + pixel_to_move, 0))

func move_cursor_down(pixel_to_move:float):
	move_cursor_at(Vector2(0, current_cursor.y + pixel_to_move))

func move_cursor_left(pixel_to_move:float):
	move_cursor_at(Vector2(current_cursor.x - pixel_to_move, 0))

func append_layer(array_128x64: Array[bool]) -> void:
	for i in range(8192):
		if array[i]:
			array_128x64[i]=array[i]

@export var use_default_gamepad:bool =true
@export var cursor_move_speed:float=50

## add curve value
@export var curve_value:Curve

func _process(delta: float) -> void:
	if use_default_gamepad:
		var direction:Vector2=Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if direction.length()>0:
			var curve_multiplier:float=curve_value.sample_baked(direction.length())
			move_cursor_at(current_cursor + direction*cursor_move_speed*delta*curve_multiplier)
		
	
