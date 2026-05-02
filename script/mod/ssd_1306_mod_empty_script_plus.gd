extends Node


signal on_screen_update_request(array:Array[bool])
var facade:SSD1306NodeFacade
var screen:Array[bool]=[]
var count=0

func wait_seconds(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func _ready() -> void:
	
	await wait_seconds(0.1)
	#facade.draw_chess_centered()
	facade.draw_chess_full()	
	
func _process(delta: float) -> void:
	screen = facade.get_value_as_1d_array_reference()
	var index = count%(128*64)
	screen[index] = not screen[index]
	on_screen_update_request.emit(screen)
	count+=1
	# facade.get_draw_interface().draw_bool_line_characters_6x8_lrtd(0,0,"Hello World")

func on_draw_was_called():
	# print("draw was called")
	pass
	
func on_update_position_rotation(position:Vector3, euler_rotation:Vector3, quaternion_rotation:Quaternion):
	var to_display :String="%.1f,%.1f,%.1f\n%.1f,%.1f,%.1f" % [position.x, position.y, position.z, euler_rotation.x, euler_rotation.y, euler_rotation.z]
	facade.get_draw_interface().draw_bool_line_characters_6x8_lrtd(0,0,to_display)
	facade.get_draw_interface().draw_bool_fill_square_lrtd(20,20,20,20)
	
func on_update_nes_buttons(up:bool,right:bool,down:bool,left:bool,a:bool,b:bool,menu_left_select:bool,menu_right_restart:bool):
	var line:Array[bool] =[up,right,down,left,a,b,menu_left_select, menu_right_restart]
	var x =2
	var y =2
	for i in range(line.size()):
		facade.set_value_at_x_y_lrdt(x+i,y,line[i])
