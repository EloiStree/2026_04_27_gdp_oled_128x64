class_name SensorDisplay128x64Memory
extends Node


signal on_memory_saved(display_as_boolean_array: Array[bool])
signal on_memory_loaded(display_as_boolean_array: Array[bool])
signal on_memory_loaded_has_no_data()


@export var file_in_app_data_name: String = "oled_128x64_display_memory.txt"
@export var true_value_as_string: String = "1"
@export var false_value_as_string: String = "0"


@export var load_at_ready: bool = true
@export var save_at_exit: bool = true
@export var use_save_every_n_seconds: bool = false
@export var save_every_n_seconds: float = 30.0



var next_save_boolean_array: Array[bool] = []


func set_next_save_boolean_array(display_as_boolean_array: Array[bool]):
	next_save_boolean_array = display_as_boolean_array.duplicate()

func set_next_save_boolean_array_and_save(display_as_boolean_array: Array[bool]):
	set_next_save_boolean_array(display_as_boolean_array)
	save_boolean_array_to_memory()


func _ready():
	if load_at_ready:
		load_boolean_array_from_memory()

	if use_save_every_n_seconds:
		var timer = Timer.new()
		timer.wait_time = save_every_n_seconds
		timer.one_shot = false
		timer.connect("timeout", Callable(self, "_on_auto_save_timer_timeout"))
		add_child(timer)
		timer.start()



func _exit_tree():
	if save_at_exit:
		save_boolean_array_to_memory()


func _on_auto_save_timer_timeout():
	save_boolean_array_to_memory()


func save_boolean_array_to_memory():
	var file = FileAccess.open(file_in_app_data_name, FileAccess.WRITE)
	if file:
		var string_to_save: String = ""
		for i in range(next_save_boolean_array.size()):
			var is_on: bool = next_save_boolean_array[i]
			string_to_save += true_value_as_string if is_on else false_value_as_string

		file.store_string(string_to_save)
		file.close()
		on_memory_saved.emit(next_save_boolean_array)
	else:
		print("Failed to open file for writing: " + file_in_app_data_name)


func load_boolean_array_from_memory():
	var file = FileAccess.open(file_in_app_data_name, FileAccess.READ)
	if file:
		var string_from_file: String = file.get_as_text()
		file.close()
		var boolean_array: Array[bool] = []
		for char in string_from_file:
			boolean_array.append(char == true_value_as_string)
		on_memory_loaded.emit(boolean_array)
	else:
		on_memory_loaded_has_no_data.emit()
