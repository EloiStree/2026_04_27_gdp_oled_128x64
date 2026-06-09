class_name SSD1306ClipboardFromTo
extends Node


signal on_imported_array_from_clipboard(array : Array[bool])
signal on_imported_text_from_clipboard(text : String)
signal on_exported_array_in_clipboard(array : Array[bool])
signal on_exported_text_in_clipboard(text : String)

var current_state_of_array : Array[bool] = []
@export var texture_to_export:Texture2D
func set_texture_to_export(texture:Texture2D):
	texture_to_export = texture



func set_reference_to_current_state_of_array(array : Array[bool]) -> void:
	current_state_of_array = array

func export_in_clipboard_from_given_reference() -> void:
	export_in_clipboard_state_of_array(current_state_of_array)



func export_in_clipboard_state_of_array(array : Array[bool]) -> void:
	# using "1" and "0"
	var string_to_export : String = ""
	for i in range(array.size()):
		string_to_export += (  "1" if array[i] else "0") + "\n"
	DisplayServer.clipboard_set(string_to_export)
	on_exported_array_in_clipboard.emit( array)
	on_exported_text_in_clipboard.emit( string_to_export)

func import_through_signal_from_clipboard_state_of_array():
	# using "1" and "0"
	var string_from_clipboard : String = DisplayServer.clipboard_get()
	var array_from_clipboard : Array[bool] = []
	for line in string_from_clipboard.split("\n"):
		if line == "1":
			array_from_clipboard.append(true)
		elif line == "0":
			array_from_clipboard.append(false)
	on_imported_array_from_clipboard.emit( array_from_clipboard)
	on_imported_text_from_clipboard.emit( string_from_clipboard)

func import_without_signal_from_clipboard_state_of_array() -> Array[bool]:
	# using "1" and "0"
	var string_from_clipboard : String = DisplayServer.clipboard_get()
	var array_from_clipboard : Array[bool] = []
	for line in string_from_clipboard.split("\n"):
		if line == "1":
			array_from_clipboard.append(true)
		elif line == "0":
			array_from_clipboard.append(false)

	return array_from_clipboard	






func get_clipboard():
	return DisplayServer.clipboard_get()

func set_clipboard(text:String):
	DisplayServer.clipboard_set(text)



func export_state_as_image_b64_in_clipboard():	
	var texture :Texture2D= texture_to_export
	var text:String=SSD1306Exporter.convert_texture_to_markdown_base64_image(texture)
	set_clipboard(text)
	
func export_state_as_image_svg_in_clipboard():
	var text:String = SSD1306Exporter.convert_bool_array_to_svg_for_markdown(current_state_of_array)
	set_clipboard(text)

func export_state_as_image_b58_in_clipboard():	
	var text:String=SSD1306Exporter.convert_bool_array_to_base_58_text(current_state_of_array)	
	set_clipboard(text)
	
func import_state_as_image_b58_from_clipboard():
	var array :Array[bool] = SSD1306Exporter.convert_bool_array_from_base_58_text(get_clipboard())	
	import_through_signal_from_clipboard_state_of_array()





	
