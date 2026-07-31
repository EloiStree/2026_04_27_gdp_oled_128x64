class_name SSD1306CheckDisplayStateFromImage
extends Node


signal on_state_validated_changed(is_valid:bool)
signal on_state_valide()
signal on_state_invalide()

@export var ssd1306_facade:SSD1306NodeFacade
@export var image_to_mirror :Texture2D
@export var check_interval_seconds:float = 0.5
@export var is_valided_state:bool = false
var _time_since_last_check:float = 0.0
@export var array_to_check:Array[bool]

func _ready() -> void:
	set_with_texture(image_to_mirror)
	
func set_with_texture(image:Texture2D):
	image_to_mirror =image
	array_to_check =SSD1306ParseImageToBoolean.convert_image_to_boolean_1d_array(image_to_mirror)

	

func _process(delta:float) -> void:
	_time_since_last_check += delta
	if _time_since_last_check >= check_interval_seconds:
		_time_since_last_check = 0.0
		check_display_state()


func check_display_state():
	
	var is_valid:= ssd1306_facade.compare_with_1d_array(array_to_check)
	if is_valid != is_valided_state:
		is_valided_state = is_valid
		on_state_validated_changed.emit( is_valid)
		if is_valid:
			on_state_valide.emit()
		else:
			on_state_invalide.emit()
