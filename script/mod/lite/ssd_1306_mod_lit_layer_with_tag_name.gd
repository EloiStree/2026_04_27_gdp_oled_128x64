class_name SSD1306ModLiteLayerWithTagName
extends Node

@export var is_layer_enabled:bool=true

@export_group("Description")

@export var title: String = ""
@export var one_liner: String = ""

@export_multiline
var short_description: String = ""

@export var documentation_url: String = ""

@export_group("Tag")

## Use to find it with code.
@export var tag_name: String = ""

## Use it as a unique id to be called.
@export var unique_id: String = ""

func set_enabled_as(is_enabled:bool):
	is_enabled=true

func set_disabled():
	set_enabled_as(false)

func set_enabled():
	set_enabled_as(true)

# -------------------------------------------------------------------
# Description Getters
# -------------------------------------------------------------------

func get_title() -> String:
	return title

func get_one_line_description() -> String:
	return one_liner

func get_multi_line_description() -> String:
	return short_description

# -------------------------------------------------------------------
# Tag / ID Getters
# -------------------------------------------------------------------

func get_tag_name() -> String:
	return tag_name

func get_tag_unique_id() -> String:
	return unique_id

# -------------------------------------------------------------------
# Documentation URL
# -------------------------------------------------------------------

func has_documentation_url() -> bool:
	return documentation_url.strip_edges() != ""

func get_documentation_url() -> String:
	return documentation_url

func open_documentation_url() -> void:
	if has_documentation_url():
		OS.shell_open(documentation_url)
	else:
		push_warning(
			"No documentation URL defined for layer: %s" % name
		)
		
	
func set_layer(array_128x64: Array[bool],fill_value=false):
	array_128x64.fill(fill_value)
	append_layer(array_128x64)
	
# -------------------------------------------------------------------
# Display Layer
# -------------------------------------------------------------------
# array_128x64 must contain 8192 bool values (128 * 64)
# representing the SSD1306 pixel buffer.
#
# Child classes should override this method and modify
# the provided buffer.
# -------------------------------------------------------------------
func append_layer(array_128x64: Array[bool]) -> void:
	if not is_layer_enabled:
		return
	if array_128x64.size() != 128 * 64:
		push_error(
			"append_layer() expected array size 8192, got %d"
			% array_128x64.size()
		)
		return

	# Base implementation does nothing.
	# Override in derived classes.
	pass
