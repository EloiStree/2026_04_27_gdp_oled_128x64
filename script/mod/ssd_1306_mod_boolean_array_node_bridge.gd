class_name SSD1306ModBooleanArrayNodeBridge
extends Node


@export_group("Method and Signal Names")
@export var methode_name_draw_called:String = "on_draw_was_called"
@export var methode_name_update_position_rotation:String = "on_update_position_rotation"
@export var methode_name_update_nes_buttons:String = "on_update_nes_buttons"
@export var signal_name_listen_to_array_1d_upated:String = "out_push_boolean_array"

@export var variable_name_api_code:String = "facade"
@export var facade_to_provide:SSD1306NodeFacade
@export var default_node_position_rotation:Node3D

@export_group("Value State")
@export var node_to_affect:Node
@export var button_up:bool
@export var button_right:bool
@export var button_down:bool
@export var button_left:bool
@export var button_a:bool
@export var button_b:bool
@export var button_menu_left_select:bool
@export var button_menu_right_restart:bool

@export var game_position:Vector3
@export var game_euler_rotation:Vector3
@export var game_quaternion_rotation:Quaternion



func _process(delta: float) -> void:
	if default_node_position_rotation:
		update_position_rotation_from_node_3d(default_node_position_rotation)



#regions SET NODE TO AFFECT

func set_node_to_affect(given_node: Node):
	node_to_affect = given_node
	if node_to_affect:
		mod_out_connect_signal_in_node_to_callable(signal_name_listen_to_array_1d_upated, mod_out_push_boolean_array.emit)
		if facade_to_provide:
			mod_in_set_variable_from_name(variable_name_api_code, facade_to_provide)

#endregion



#region NOTIFY DRAW

func notify_that_draw_was_called():
	if not node_to_affect:
		return 
	if node_to_affect.has_method(methode_name_draw_called):
		node_to_affect.call(methode_name_draw_called)
#endregion


#region UPADTE POSITION AND ROTATION
# on_update_position_rotation(position:Vector3, euler_rotation:Vector3, quaternion_rotation:Quaternion)
func update_position_rotation_from_node_3d(node_3d:Node3D):
	var position = node_3d.global_transform.origin
	var euler_rotation = node_3d.global_transform.basis.get_euler()
	var quaternion_rotation = node_3d.global_transform.basis.get_rotation_quaternion()
	update_position_rotation(position, euler_rotation, quaternion_rotation)

func update_position_rotation(position:Vector3, euler_rotation:Vector3, quaternion_rotation:Quaternion):
	game_position = position
	game_euler_rotation = euler_rotation
	game_quaternion_rotation = quaternion_rotation
	
	if not node_to_affect:
		return 
	if node_to_affect.has_method(methode_name_update_position_rotation):
		node_to_affect.call(methode_name_update_position_rotation, game_position, game_euler_rotation, game_quaternion_rotation)

#endregion
	

#region UPDATE NES BUTTONS

# on_update_nes_buttons(up:bool,right:bool,down:bool,left:bool,a:bool,b:bool,menu_left_select:bool,menu_right_restart:bool)
func set_nes_buttons(up:bool,right:bool,down:bool,left:bool,a:bool,b:bool,menu_left_select:bool,menu_right_restart:bool):
	button_up = up
	button_right = right
	button_down = down
	button_left = left
	button_a = a
	button_b = b
	button_menu_left_select = menu_left_select
	button_menu_right_restart = menu_right_restart
	if not node_to_affect:
		return 
	if node_to_affect.has_method(methode_name_update_nes_buttons):
		node_to_affect.call(methode_name_update_nes_buttons, up, right, down, left, a, b, menu_left_select, menu_right_restart)

func _push_nes_button_to_mod():
	if not node_to_affect:
		return 
	if node_to_affect.has_method(methode_name_update_nes_buttons):
		node_to_affect.call(methode_name_update_nes_buttons, button_up, button_right, button_down, button_left, button_a, button_b, button_menu_left_select, button_menu_right_restart)

func set_nes_button_a(is_pressed:bool):
	button_a = is_pressed
	_push_nes_button_to_mod()

func set_nes_button_b(is_pressed:bool):
	button_b = is_pressed
	_push_nes_button_to_mod()

func set_nes_button_up(is_pressed:bool):
	button_up = is_pressed
	_push_nes_button_to_mod()	

func set_nes_button_right(is_pressed:bool):
	button_right = is_pressed
	_push_nes_button_to_mod()
	
func set_nes_button_down(is_pressed:bool):
	button_down = is_pressed
	_push_nes_button_to_mod()

func set_nes_button_left(is_pressed:bool):
	button_left = is_pressed
	_push_nes_button_to_mod()

func set_nes_button_menu_left_select(is_pressed:bool):
	button_menu_left_select = is_pressed
	_push_nes_button_to_mod()

func set_nes_button_menu_right_restart(is_pressed:bool):
	button_menu_right_restart = is_pressed
	_push_nes_button_to_mod()

func set_nes_arryow_from_vector2(arrow_direction:Vector2):
	button_up = arrow_direction.y > 0
	button_down = arrow_direction.y < 0
	button_right = arrow_direction.x > 0
	button_left = arrow_direction.x < 0
	_push_nes_button_to_mod()

#endregion

	


#regions SIGNAL

signal mod_out_push_boolean_array(boolean_array: Array[bool])

#endregion



#region GENERIC FUNCTIONS

## CONNET A SIGNAL IN THE USER SCRIPT TO A FUNCTION 
func mod_out_connect_signal_in_node_to_callable(signal_name:String, callable: Callable):
	if node_to_affect and node_to_affect.has_signal(signal_name):
		node_to_affect.connect(
			signal_name,
			callable
		)

## OVERRIDE A VARIABLE FROM IT NAME WITH A GIVEN UNTYPE VALUE
func mod_in_set_variable_from_name(variable_name:String, value):
	if not node_to_affect:
		return
	if variable_name in node_to_affect:
		node_to_affect.set(variable_name, value)
		
## CALL A METHOD FROM IT NAME WITH A GIVEN UNTYPE VALUE
func mod_in_call_method_with_one_varible(method_name:String,value):
	if not node_to_affect:
		return 
	if node_to_affect.has_method(method_name):
		node_to_affect.call(method_name,value)

## CALL A METHOD FROM IT NAME WITHOUT PARAMS
func mod_in_call_method_without_params(method_name:String):
	if not node_to_affect:
		return 
	if node_to_affect.has_method(method_name):
		node_to_affect.call(method_name)

## OVERRIDE A VARIABLE AND CALL A METHOD FROM IT NAME WITH A GIVEN UNTYPE VALUE
func mod_in_set_and_affect_from_var_method_name(var_name:String, method_name:String, value):
	mod_in_set_variable_from_name(var_name,value )
	mod_in_call_method_with_one_varible(method_name,value)
	
#endregion
