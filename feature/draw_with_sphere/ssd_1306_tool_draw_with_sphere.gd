class_name SSD1306ToolDrawWithSphere
extends Node

@export var left_down_anchor:Node3D
@export var right_top_anchor:Node3D
@export var left_top_anchor:Node3D

@export var drawing_point_center:Node3D
@export var drawing_radius_center:Node3D


@export var move_rotate_anchor_quad:Node3D
@export var move_rotate_anchor_sphere_brush:Node3D

@export var size_anchor_quad:Node3D
@export var size_anchor_sphere_brush:Node3D


func set_size_of_brush_with_diameter(diameter:float):
	set_size_of_brush_with_radius(diameter/2.0)


func set_size_of_brush_with_radius(radius:float):
	pass
		
func set_size_with_width(size_as_meter:float):
	pass




func get_cursor_lrdt_percent_01() -> Vector2:
	var local_point: Vector2 = get_local_point_in_quad_vector2(drawing_point_center.global_position)
	return Vector2(
		local_point.x / get_quad_width_as_meter(),
		-local_point.y / get_quad_height_as_meter()
	)


func get_contact_radius_as_meter() -> float:
	var height: float = get_cursor_height()
	var radius: float = get_cursor_radius_as_meter()
	if height> radius:
		return 0.0
	
	var height_left_passed_plane = abs(radius) - abs(height)
	var height_plant_to_center = abs(radius) - height_left_passed_plane	
	var height_left_normalized = height_plant_to_center / radius
	var adjacent_edge = height_left_normalized
	var hypothenus_edge =1.0
	var opposed_edge = sqrt(hypothenus_edge*hypothenus_edge - adjacent_edge*adjacent_edge)
	var contact_radius_as_meter = radius * opposed_edge
	return contact_radius_as_meter


func get_contact_radius_percent_01_from_width() -> float:
	return get_contact_radius_as_meter() / get_quad_width_as_meter()



func get_cursor_radius_percent_01() -> float:
	return get_cursor_radius_as_meter() / get_quad_width_as_meter()


func get_cursor_height() -> float:
	var cursor_position: Vector3 = get_local_point_in_quad_vector3(drawing_point_center.global_position)
	return cursor_position.y

func get_cursor_up_pression_percent_11() -> float:
	var height: float = get_cursor_height()
	var radius: float = get_cursor_radius_as_meter()
	if abs(height) > radius:
		return 0.0

	var percent_to_center: float = height/radius
	if percent_to_center > 0.0:
		return 1.0 - percent_to_center
	if percent_to_center < 0.0:
		return -1.0 - percent_to_center

	return 0.0




# func _process(delta: float) -> void:
# 	## print widht height
# 	print("")
# 	# print("Width: "+str(get_quad_width_as_meter())+" Height: "+str(get_quad_height_as_meter()))
# 	# print("Diameter: "+str(get_quad_diameter_as_meter()))
# 	# print("cursor lrdt percent 01: "+str(get_cursor_lrdt_percent_01()))
# 	# print("Local point in quad: "+str(get_local_point_in_quad_vector3(drawing_point_center.global_position)))
# 	# print("Pression percent 11: "+str(get_cursor_up_pression_percent_11()))
# 	# print ("Cursor Height: ",str(get_cursor_height(), " Cursor Radius: "+str(get_cursor_radius_as_meter()))

# 	# print ("Cursor Radius Percent 01: "+str(get_cursor_radius_percent_01()))
# 	# print ("Contact Radius Percent 01 from width: "+str(get_contact_radius_percent_01_from_width()))	
	
# 	# print("Height: "+str(height)+" Radius: "+str(radius))
# 	# print("Height left: "+str(height_plant_to_center))
# 	# print("Contact radius as meter: "+str(contact_radius_as_meter))


func get_quad_diameter_as_meter() -> float:
	return (right_top_anchor.global_position - left_down_anchor.global_position).length()

func get_quad_height_as_meter() -> float:
	return (left_down_anchor.global_position - left_top_anchor.global_position).length()

func get_quad_width_as_meter() -> float:
	return (right_top_anchor.global_position - left_top_anchor.global_position).length()
	
func get_cursor_radius_as_meter() -> float:
	return (drawing_radius_center.global_position - drawing_point_center.global_position).length()

func get_cursor_diameter_as_meter() -> float:
	return get_cursor_radius_as_meter() * 2.0






var  quaternion_rotation_180:= Quaternion.from_euler(Vector3(0.0, 180.0, 0.0))
func get_local_point_in_quad_vector3(point:Vector3) -> Vector3:
	var relative_point: Vector3 = point - left_down_anchor.global_position
	var inverse_rotation: Quaternion = Quaternion.from_euler(left_down_anchor.global_rotation).inverse()
	var local_point: Vector3 = inverse_rotation*relative_point
	return local_point



func get_local_point_in_quad_vector2(point:Vector3) -> Vector2:
	var local_point: Vector3 = get_local_point_in_quad_vector3(point)
	return Vector2(local_point.x, local_point.z)
	
