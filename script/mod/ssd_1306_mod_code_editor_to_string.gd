class_name SSD1306ModCodeEditorToString
extends Node

signal on_code_to_execute_updated(node_created:String)

@export var code_editor_to_read_from:CodeEdit
@export var stop_button:Button
@export var run_button:Button
@export var code_to_load_at_ready:Script
@export var execute_at_ready:bool =false
@export var execute_on_changed:bool =false

func _ready() -> void:
	if code_to_load_at_ready:
		var local_path = code_to_load_at_ready.resource_path
		var text = FileAccess.get_file_as_string(local_path)
		code_editor_to_read_from.text = text
		
	if execute_at_ready:
		on_code_to_execute_updated.emit(code_editor_to_read_from.text)
	if code_editor_to_read_from:
		code_editor_to_read_from.text_changed.connect( _emit_on_changed )
	if run_button:
		run_button.button_down.connect(emit_code_editor_text)
	if run_button:
		stop_button.button_down.connect(func(): 
			on_code_to_execute_updated.emit("")
		)
		

func _emit_on_changed():
	if execute_on_changed:
		emit_code_editor_text()	

func emit_code_editor_text() -> void:
	if not code_editor_to_read_from:
		return
	on_code_to_execute_updated.emit(code_editor_to_read_from.text)
	
	
@export_group("Keyboard Run")
@export var _use_key_code_to_reload_code:bool=true
@export var _key_code_to_reload_code:int=KEY_F1
func _unhandled_input(event):
	if not _use_key_code_to_reload_code:
		return 
	if event is InputEventKey and event.pressed:
		
		print(
			"keycode=", event.keycode,
			" text=", event.as_text()
		)

		if event.keycode == _key_code_to_reload_code:
			emit_code_editor_text()
