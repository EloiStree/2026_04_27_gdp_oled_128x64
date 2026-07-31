class_name ScreenLayerDebugGlobalTransform3D
extends SSD1306ModLiteLayerWithTagName


@export var observed:Node3D

func append_layer(array: Array[bool]) -> void:
	# Clear or initialize pattern
	for i in range(8192):
		array[i] = (i % 7 == 0)
   
	# Set some solid areas
	for i in range(128 * 5):
		array[i] = true
   
	for i in range(128 * 10, 128 * 12):
		array[i] = true

	# Print header
	ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(
		array, Vector2i(0, 2), "Global Value              ", true, true
	)
	# === Extract transform data ===
	var transform: Transform3D = observed.global_transform
	var position: Vector3 = transform.origin
	var euler: Vector3 = transform.basis.get_euler()
	var direction: Vector3 = -transform.basis.z
	var quaternion: Quaternion = transform.basis.get_rotation_quaternion()
	
	# Direction (Forward)
	var forward: Vector3 = -transform.basis.z

	# === Print with nice formatting ===
	ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(
		array, Vector2i(2, 20), "P:" + format_vec3(position), true, true
	)
	
	ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(
		array, Vector2i(2, 28), "E: " + format_vec3_euler(euler), true, true
	)
	
	ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(
		array, Vector2i(2, 36), "D: " + format_vec3(direction), true, true
	)
	
	ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(
		array, Vector2i(2, 44), "Q:" + format_quad(quaternion), true, true
	)
	ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(
		array, Vector2i(2, 52), "Info: X Y Z | W", true, true
	)


func format_vec3(v: Vector3) -> String:
	return "%.2f, %.2f, %.2f" % [v.x, v.y, v.z]
func format_vec3_euler(v: Vector3) -> String:
	return "%.1f, %.1f, %.1f" % [rad_to_deg(v.x), rad_to_deg(v.y), rad_to_deg(v.z)]
	
func format_quad(v: Quaternion) -> String:
	return "%.1f, %.1f, %.1f, %.1f" % [v.x, v.y, v.z, v.w]
