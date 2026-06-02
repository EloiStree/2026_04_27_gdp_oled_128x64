class_name E13DownloadTextFromCodeEditForms
extends Node


signal on_combined_text_requested(combined_text:String)

@export var code_editors:Array[CodeEdit] = []
@export var text_editors:Array[TextEdit] = []

@export var load_code_at_ready:bool=true
@export var add_extends_if_missing:bool=true

func _ready():
	if load_code_at_ready:
		combine_and_emit()

func combine_and_emit():
	var combined_text:String = ""

	for editor in code_editors:
		if editor.text:
			combined_text += editor.text + "\n"

	for editor in text_editors:
		if editor.text:
			combined_text += editor.text + "\n"

	if add_extends_if_missing and not combined_text.contains("extends"):
		combined_text = "extends Node\n\n" + combined_text
	on_combined_text_requested.emit(combined_text)
