class_name ScreenLayerXrInputDebug
extends SSD1306ModLiteLayerWithTagName

@export var debug_label_3d:Label3D
@export var debug_label_2d:Label

@export var use_clear_background: bool = true

const MAX_CHAR_PER_LINE = 128/6
const MAX_LINES = 64/8

func append_layer(array_128x64: Array[bool]) -> void:
	if use_clear_background:
		array_128x64.fill(false)
	var text_to_display:String = ""
	text_to_display += "LT:%.2f" % get_trigger_left_value()
	text_to_display += " RT:%.2f" % get_trigger_right_value()
	text_to_display += "\nLG:%.2f" % get_grip_left_value()
	text_to_display += " RG:%.2f" % get_grip_right_value()
	text_to_display += "\nLJ:" + compress_vector2_to_string(get_left_joystick_2d_value())
	text_to_display += "\nRJ:" + compress_vector2_to_string(get_right_joystick_2d_value())
	text_to_display += "\nLJB:" + ("1" if get_left_joystick_button_press() else "0")
	text_to_display += " RJB:" + ("1" if get_right_joystick_button_press() else "0")
	text_to_display += "LM:" + ("1" if get_button_menu_left_press() else "0")	
	text_to_display += "\nLDX:" + ("1" if get_button_left_down_x_press() else "0")
	text_to_display += " LUY:" + ("1" if get_button_left_up_y_press() else "0")
	text_to_display += "\nRDA:" + ("1" if get_button_right_down_a_press() else "0")
	text_to_display += " RUB:" + ("1" if get_button_right_up_b_press() else "0")
	ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(array_128x64,Vector2i(0,0), "XR INPUT                 ",false,true)
	ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(array_128x64,Vector2i(0,8), text_to_display,true,true)
	draw_vertical_line_up_percentage(array_128x64,124,63,get_trigger_left_value())
	draw_vertical_line_up_percentage(array_128x64,125,63,get_trigger_right_value())
	draw_vertical_line_up_percentage(array_128x64,126,63,get_grip_left_value())
	draw_vertical_line_up_percentage(array_128x64,127,63,get_grip_right_value())
	if debug_label_2d:
		debug_label_2d.text= text_to_display
	if debug_label_3d:
		debug_label_3d.text= text_to_display

func compress_vector2_to_string(v: Vector2) -> String:
	return "%.1f, %.1f" % [v.x, v.y]

func draw_vertical_line_up_percentage(array: Array[bool], x: int, y_start: int, percentage: float) -> void:
	var pixel_count = int(percentage * 127)
	draw_vertical_line_up(array, x, y_start, pixel_count)
	
func draw_vertical_line_up(array: Array[bool], x: int, y_start: int, pixel_count: int) -> void:
	for i in range(pixel_count):
		var y = y_start - i
		if y >= 64 or y<0:
			break
		var index = y * 128 + x
		if index < array.size():
			array[index] = true

@export_group("Found")
@export var xr_origin: XROrigin3D
@export var xr_camera: XRCamera3D
@export var xr_left_controller: XRController3D
@export var xr_right_controller: XRController3D

func _ready() -> void:
	var all_nodes := get_all_nodes_of_scene()
	find_xr_elements_in_nodes(all_nodes)
	if not xr_origin:
		push_warning("XR Origin not found!")
	if not xr_camera:
		push_warning("XR Camera not found!")
	if not xr_left_controller:
		push_warning("XR Left Controller not found!")
	if not xr_right_controller:
		push_warning("XR Right Controller not found!")

func get_all_nodes_of_scene() -> Array[Node]:
	var nodes: Array[Node] = []
	_collect_nodes_recursive(get_tree().root, nodes)
	return nodes

func _collect_nodes_recursive(node: Node, collected: Array[Node]) -> void:
	if not node:
		return
	collected.append(node)
	for child in node.get_children():
		_collect_nodes_recursive(child, collected)
		
func find_xr_elements_in_nodes(nodes: Array[Node]) -> void:
	for node in nodes:
		if not node:
			continue
		if not xr_origin and node is XROrigin3D:
			xr_origin = node
		elif not xr_camera and node is XRCamera3D:
			xr_camera = node
		elif node is XRController3D:
			var controller := node as XRController3D
			if controller.tracker == "left_hand" or controller.name.to_lower().contains("left"):
				if not xr_left_controller:
					xr_left_controller = controller
			elif controller.tracker == "right_hand" or controller.name.to_lower().contains("right"):
				if not xr_right_controller:
					xr_right_controller = controller
		if xr_origin and xr_camera and xr_left_controller and xr_right_controller:
			break
			
func get_button_left_down_x_press() -> bool:
	if not xr_left_controller: return false
	return xr_left_controller.is_button_pressed("ax_button")  # or "x_button" depending on your action map

func get_button_left_up_y_press() -> bool:
	if not xr_left_controller: return false
	return xr_left_controller.is_button_pressed("by_button")  # or "y_button"

func get_button_right_down_a_press() -> bool:
	if not xr_right_controller: return false
	return xr_right_controller.is_button_pressed("ax_button")  # A on right = ax_button in many maps

func get_button_right_up_b_press() -> bool:
	if not xr_right_controller: return false
	return xr_right_controller.is_button_pressed("by_button")

func get_button_menu_left_press() -> bool:
	if not xr_left_controller: return false
	return xr_left_controller.is_button_pressed("menu_button")
	
func get_left_joystick_2d_value() -> Vector2:
	if not xr_left_controller:
		return Vector2.ZERO
	for name in ["primary", "thumbstick", "joystick", "secondary"]:
		var value = xr_left_controller.get_vector2(name)
		if value.length() > 0.01:   # small deadzone
			return value
	return Vector2.ZERO

func get_right_joystick_2d_value() -> Vector2:
	if not xr_right_controller:
		return Vector2.ZERO
	
	for name in ["primary", "thumbstick", "joystick", "secondary"]:
		var value = xr_right_controller.get_vector2(name)
		if value.length() > 0.01:   # small deadzone
			return value
	return Vector2.ZERO

func get_left_joystick_button_press() -> bool:
	if not xr_left_controller: return false
	for name in [ "thumbstick_click", "joystick_button", "primary_click", "secondary_click"]:
		if xr_left_controller.is_button_pressed(name):
			return true
	return false

func get_right_joystick_button_press() -> bool:
	if not xr_right_controller: return false
	for name in [ "thumbstick_click", "joystick_button", "primary_click", "secondary_click"]:
		if xr_right_controller.is_button_pressed(name):
			return true
	return false
	
	
func get_float(hand: XRController3D, action_name: String) -> float:
	return hand.get_float(action_name) if hand else 0.0

func get_vector2(hand: XRController3D, action_name: String) -> Vector2:
	return hand.get_vector2(action_name) if hand else Vector2.ZERO

func is_pressed(hand: XRController3D, action_name: String) -> bool:
	return hand.is_button_pressed(action_name) if hand else false
	
	
## Returns trigger squeeze value on the left controller (0.0 = not pressed, 1.0 = fully pressed)
func get_trigger_left_value() -> float:
	if not xr_left_controller: return 0.0
	return xr_left_controller.get_float("trigger")  # Default Godot OpenXR action name

## Returns trigger squeeze value on the right controller
func get_trigger_right_value() -> float:
	if not xr_right_controller: return 0.0
	return xr_right_controller.get_float("trigger")

## Returns grip squeeze value on the left controller
func get_grip_left_value() -> float:
	if not xr_left_controller: return 0.0
	return xr_left_controller.get_float("grip")

## Returns grip squeeze value on the right controller
func get_grip_right_value() -> float:
	if not xr_right_controller: return 0.0
	return xr_right_controller.get_float("grip")
