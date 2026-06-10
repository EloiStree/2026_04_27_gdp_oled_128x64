class_name SSD1306ScreenLayerModCodeAbstract
extends SSD1306ModLiteLayerWithTagName

signal on_created_node(node_created:Node)
signal on_created_node_with_code(node_created:Node, code:String)
signal on_fail_to_load_code(code:String)

@export_multiline() 
var given_godot_code_to_execute:String="""
extends Node
func _ready():
	print("Hello Layer SSD1306")
	
func append_layer(array_128x64: Array[bool]) -> void:
	array_128x64.fill(true)
	
"""
@export var where_to_create_node:Node
@export var load_code_inspector_at_ready:bool=true
@export var unique_code_file_name:String ="code_file_name_change_me_mod_layer.gd"

@export_group("Debug")
@export var created_node_holding_code:Node

@export var use_3d_node:bool=true

func append_layer(array_128x64: Array[bool]) -> void:
	if created_node_holding_code and created_node_holding_code.has_method("append_layer"):
		created_node_holding_code.call("append_layer",array_128x64)

func _ready() -> void:
	if  load_code_inspector_at_ready:
		load_in_godot_code(given_godot_code_to_execute)

func load_code_from_file_script_in_project(script: Script):
	var local_path = script.resource_path
	var text = FileAccess.get_file_as_string(local_path)
	load_in_godot_code(text)

func load_in_godot_code(code:String):
	## When we start we need to destroy the previous one.
	if created_node_holding_code:
		## if it existe. kill it. I means... lets is free 
		created_node_holding_code.queue_free()
		created_node_holding_code = null
		
	## code cant be loaded like that. you need to load from file
	## we can create the file in folde of our application
	if unique_code_file_name=="":
		unique_code_file_name= str(self.get_instance_id())+".gd"
	var script_path: String = "user://"+unique_code_file_name
	## print(script_path)
	## to see where it is store in the end
	##print(ProjectSettings.globalize_path(script_path))
	var file_connection =FileAccess.open(script_path, FileAccess.WRITE)
	if file_connection:
		file_connection.store_string(code)
		file_connection.close()
	else:
		push_error("Oups file was not created")
		return
	
	# lets try to execute it now.
	var script:Script = ResourceLoader.load(script_path,"GDScript",0)
	if not script is GDScript:
		push_error("Hum that not a Godot Script")
		on_fail_to_load_code.emit(code)
		return 
	
	## We created and loaded a script in our application.
	## now we need to use it
	
	## we need for that a node
	var node :Node =  Node3D.new() if use_3d_node else Node.new()
	# we have a new node but not yet in the scene
	node.set_script(script)
	# he has our code 
	node.set_process(true)	
	# he now use _process(delta)
	node.set_physics_process(true)
	# in case we need it later
	
	## now we add it in the scene
	created_node_holding_code = node
	if where_to_create_node:
		where_to_create_node.add_child(node)
	else:
		add_child(node)
	on_created_node.emit(node)
	on_created_node_with_code.emit(node,code)
	

	## from here you will have ready trigger
	# and _process
	

	
	
