class_name SSD1306InputMemoryFromGetSetTextOfTargetNode
extends Node

@export var _target_node: Node
@export var _path_format: String = "user://temp/%s.txt"
@export var _save_unique_id: String

@export var _default_if_not_set: String = ""

@export var _use_print_of_save_path: bool = false
@export var _save_on_exit_tree: bool = true
@export var _load_on_ready: bool = true


func _ready() -> void:
	if _target_node == null or not _has_text_methods(_target_node):
		return
	if _load_on_ready:
		load_text()


func _exit_tree() -> void:
	if _target_node == null or not _has_text_methods(_target_node):
		return
	if _save_on_exit_tree:
		save_text_in_input_field()



func load_text() -> void:
	if _target_node == null or not _has_text_methods(_target_node):
		return

	var loaded_text := _default_if_not_set
	var path := _get_absolute_save_path()
	if path.is_empty():
		return

	if _use_print_of_save_path:
		print("Save PATH: ", path)
	var exists:bool=FileAccess.file_exists(path)
	if  exists :
		var file := FileAccess.open(path, FileAccess.READ)
		if file != null:
			loaded_text = file.get_as_text()
	print("KKK ",exists," = ",loaded_text)
	set_text_to_node(loaded_text)


func _notification(what: int) -> void:
	if _target_node == null or not _has_text_methods(_target_node):
		return
	if not _save_on_exit_tree:
		return

	match what:
		NOTIFICATION_WM_CLOSE_REQUEST, NOTIFICATION_APPLICATION_FOCUS_OUT, NOTIFICATION_PREDELETE:
			save_text_in_input_field()

func get_text_from_node() -> String:
	if _target_node == null or not _has_text_methods(_target_node):
		return ""
	return _target_node.get_text()


func set_text_to_node(text: String) -> void:
	if _target_node == null or not _has_text_methods(_target_node):
		return
	_target_node.set_text(text)


func save_given_text(text: String) -> void:
	var path := _get_absolute_save_path()
	if path.is_empty():
		return

	create_directory_if_not_exists(get_directory_from_path(path))

	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open file for writing: " + path)
		return

	file.store_string(text)
	


func save_text_in_input_field() -> void:
	save_given_text(get_text_from_node())


func create_directory_if_not_exists(dir_path: String) -> void:
	if dir_path.is_empty():
		return
	if DirAccess.dir_exists_absolute(dir_path):
		return
	var err := DirAccess.make_dir_recursive_absolute(dir_path)
	if err != OK and err != ERR_ALREADY_EXISTS:
		push_error("Failed to create directory: " + dir_path + "  Error: " + str(err))


func get_directory_from_path(path: String) -> String:
	return path.get_base_dir()


func _get_absolute_save_path() -> String:
	if _save_unique_id.strip_edges().is_empty():
		push_warning("InputMemory: _save_unique_id is empty – nothing will be saved/loaded")
		return ""
	var path := _path_format % _save_unique_id
	if path.to_lower().begins_with("user://") or path.to_lower().begins_with("res://"):
		return ProjectSettings.globalize_path(path)
	else:
		return path


func _has_text_methods(node: Object) -> bool:
	return node.has_method("get_text") and node.has_method("set_text")
