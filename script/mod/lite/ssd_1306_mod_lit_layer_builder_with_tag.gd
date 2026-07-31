class_name SSD1306ModLiteLayerBuilderWithTagName
extends SSD1306ModLiteLayerWithTagName


@export var layers: Array[SSD1306ModLiteLayerWithTagName] = []
@export_group("Add script of childrens")
@export var add_layer_in_childrens_at_ready:bool=true
@export var add_layer_in_childrens_recursively:bool=true
@export var add_scripts_in_node_childrens: Node




# -------------------------------------------------------------------
# Layer control
# -------------------------------------------------------------------

func disable_all_layers() -> void:
	for layer in layers:
		if layer != null:
			layer.set_disabled()

func enable_all_layers() -> void:
	for layer in layers:
		if layer != null:
			layer.set_enabled()

func enable_only_one_layer_by_name(name: String) -> void:
	for layer in layers:
		if layer == null:
			continue
		layer.set_enabled_as(layer.get_tag_name() == name)

func enable_only_one_layer_by_unique_id(id: String) -> void:
	for layer in layers:
		if layer == null:
			continue
		layer.set_enabled_as(layer.get_tag_unique_id() == id)
		
func enable_only_one_layer_by_name_or_unique_name(name: String) -> void:
	for layer in layers:
		if layer == null:
			continue
		var is_enable:=layer.get_tag_name() == name or layer.get_tag_unique_id() == name
		layer.set_enabled_as(is_enable)


# -------------------------------------------------------------------
# Rendering
# -------------------------------------------------------------------

func append_layer(array_128x64: Array[bool]) -> void:
	# Builder itself can also be disabled
	if not is_layer_enabled:
		return
	for layer in layers:
		if layer == null:
			continue
		if layer.is_layer_enabled:
			layer.append_layer(array_128x64)
			
	


func _init() -> void:
#	super._init()
	append_layers_with_childrens(add_scripts_in_node_childrens, add_layer_in_childrens_recursively)


@export var childrens:Array[Node]
func append_layers_with_childrens(from_node: Node, recursive: bool = true) -> void:
		childrens= get_all_children(from_node, false)
		for child in childrens:
			if child is SSD1306ModLiteLayerWithTagName:
				var c:SSD1306ModLiteLayerWithTagName= child
				layers.append(c)

static func get_all_children(node: Node, include_self: bool = false) -> Array[Node]:
	if not node:
		return []
	
	var result: Array[Node] = []
	
	if include_self:
		result.append(node)
	
	_collect_children_recursive(node, result)
	return result


static func _collect_children_recursive(parent: Node, result: Array[Node]) -> void:
	for child in parent.get_children():
		result.append(child)
		_collect_children_recursive(child, result)
