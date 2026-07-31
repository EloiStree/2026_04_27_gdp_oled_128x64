extends Node

func wait_seconds(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	
## CALLLED WHEN SCRIPT STARTS
func _ready() -> void:	
	pass

## DIRECT ACCESS TO THE UI DISPLAY ARRAY OF 128x64 8192 pixels
func append_layer(array_128x64: Array[bool]) -> void:
	if array_128x64 and array_128x64.size()>=128*64:
		var is_active:=true
		if is_active:
			for i in range(8192):
				array_128x64[i] =i%3==0
	
## 40-200 FPS of GODOT
## No need to go faster that the draw call, but it is there if you need it.
func _process(delta: float) -> void:
	pass

## CALLED AFTER EACH SCREEN REFRESHED 
## (around 10 / seconds in real life, can be changed by designer)
func on_draw_was_called():
	print("Draw was called")
	pass


## GAME POSITION AND ROTATION OF THE SSD1306 NODE
## (You dont have that in real life ;), it is added to praticed rotationa and vectors)
func on_update_position_rotation(position:Vector3, euler_rotation:Vector3, quaternion_rotation:Quaternion):
	print("Update Position Info")
	pass


## BY DEFAULT FAKE NES INPUT ARE PROVIDED TO ALLOW YOU TO CREATE MINI GAMES
## You can use that input to create games like snake, pong, tetris, etc...
## Input can be disable or override for XR or other use.
## But the idea is to make game using an arrow keys, 2 buttons and 2 menu buttons.
func on_update_nes_buttons(up:bool,right:bool,down:bool,left:bool,a:bool,b:bool,menu_left_select:bool,menu_right_restart:bool):
	print(",".join([up,right,down, left, a,b, menu_left_select,menu_right_restart]))
	pass
	
