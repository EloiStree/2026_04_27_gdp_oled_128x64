class_name SSD1306ModCodeEditorToString
extends Node



signal on_code_to_execute_updated(node_created:String)

@export var code_editor_to_read_from:CodeEdit
@export var code_to_load_at_ready:Script
@export var execute_at_ready:bool =false
@export var unique_code_file_name:String ="code_file_name_change_me.gd"
@export var created_node_holding_code:Node

@export var use_emit_on_changed:bool =false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if code_to_load_at_ready:
		var local_path = code_to_load_at_ready.resource_path
		var text = FileAccess.get_file_as_string(local_path)
		code_editor_to_read_from.text = text

	if execute_at_ready:
		on_code_to_execute_updated.emit(code_editor_to_read_from.text)

	if code_editor_to_read_from:
		code_editor_to_read_from.connect("text_changed", Callable(self, "_emit_on_changed"))

func _emit_on_changed():
	if use_emit_on_changed:
		emit_code_editor_text()	
func emit_code_editor_text() -> void:
	if not code_editor_to_read_from:
		return
	on_code_to_execute_updated.emit(code_editor_to_read_from.text)
	
