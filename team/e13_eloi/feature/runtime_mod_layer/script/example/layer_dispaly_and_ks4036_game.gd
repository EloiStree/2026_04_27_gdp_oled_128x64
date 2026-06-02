extends SSD1306ModLiteLayerWithTagName

@onready var input: Node = get_tree().root.find_child("KS4036Input", true, false)
@onready var read: Node = get_tree().root.find_child("KS4036Read", true, false)

func _ready():
	print(input)
	print(read)

	input.set_color_led_front_left(Color.RED)
	input.set_color_led_front_right(Color.BLUE)
	for i in range(5):
		await get_tree().create_timer(2).timeout
		input.set_left_wheel_percent_11(1)
		await get_tree().create_timer(2).timeout
		input.set_left_wheel_percent_11(1)


func append_layer(array_128x64: Array[bool]) -> void:
	array_128x64.fill(false)
	var text: String = "Hello "

	var distance: float = read.get_front_distance_in_meter()
	var is_on_line_left: bool = read.is_left_line_on()
	var is_on_line_right: bool = read.is_right_line_on()

	var color_left: Color = read.get_color_line_left()
	var color_right: Color = read.get_color_line_right()

	var light_left = read.get_light_intensity_left()
	var light_right = read.get_light_intensity_right()

	text += "D:%0.1f LL:%d LR:%d LSL:%d LSR:%d" % [
		distance,
		int(is_on_line_left),
		int(is_on_line_right),
		light_left,
		light_right
	]

	# Convert colors into something human-readable (since raw Color is useless in text)
	text += " \nCL:(%d,%d,%d) CR:(%d,%d,%d)" % [
		int(color_left.r * 255.0),
		int(color_left.g * 255.0),
		int(color_left.b * 255.0),
		int(color_right.r * 255.0),
		int(color_right.g * 255.0),
		int(color_right.b * 255.0)
	]
	
	var position: Vector3 = read.get_global_position()
	var direction: Vector3 = read.get_global_forward_direction()
	var euler: Vector3 = read.get_global_euler_rotation()
	var rotation: Quaternion = read.get_global_quaternion()

	text += "\nP:(%0.1f,%0.1f,%0.1f) D:(%0.2f,%0.2f,%0.2f)" % [
		position.x, position.y, position.z,
		direction.x, direction.y, direction.z
	]

	text += "\nE:(%0.1f,%0.1f,%0.1f)" % [
		rad_to_deg(euler.x), rad_to_deg(euler.y), rad_to_deg(euler.z)
	]

	text += "\nR:(%0.1f,%0.1f,%0.1f,%0.1f)" % [
		rotation.x, rotation.y, rotation.z, rotation.w
	]
	

	E13ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(
		array_128x64,
		Vector2(0, 0),
		text,
		true,
		true
	)
