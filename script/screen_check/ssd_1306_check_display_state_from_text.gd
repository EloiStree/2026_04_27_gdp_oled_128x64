class_name SSD1306CheckDisplayStateFromText
extends Node


signal on_state_validated_changed(is_valid:bool)
signal on_state_valide()
signal on_state_invalide()

@export var ssd1306_facade:SSD1306NodeFacade
@export var text_file :SSD1306TextFile
@export var expected_screen_state_as_text:String
@export var check_interval_seconds:float = 0.5
@export var is_valided_state:bool = false

var _time_since_last_check:float = 0.0

func _process(delta:float) -> void:
	_time_since_last_check += delta
	if _time_since_last_check >= check_interval_seconds:
		_time_since_last_check = 0.0
		check_display_state()

func get_text_file_as_string()->String:
	if text_file == null or not is_instance_valid(text_file):
		return ""
	if text_file is Resource and text_file.resource_path:
		var content = FileAccess.get_file_as_string(text_file.resource_path)
		return content if content else ""
	return ""


func check_display_state():
	var current_screen_state_as_text = get_text_file_as_string()
	var is_valid:bool = ssd1306_facade.compare_is_equals_to_image_text_at_lrtd_zero(expected_screen_state_as_text)

	if is_valid != is_valided_state:
		is_valided_state = is_valid
		on_state_validated_changed.emit( is_valid)
		if is_valid:
			on_state_valide.emit()
		else:
			on_state_invalide.emit()
