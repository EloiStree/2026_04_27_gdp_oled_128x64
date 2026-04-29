class_name SSD1306ModCreateCodeNode
extends Node



signal on_created_node_with_code(node_created:Node)

@export var unique_code_file_name:String ="code_file_name_change_me.gd"
@export var created_node_holding_code:Node



func try_to_execute_code(code_text:String) -> void:
	
	
	## When we start we need to destroy the previous one.
	if created_node_holding_code:
		## if it existe. kill it. I means... lets is free 
		created_node_holding_code.queue_free()
		created_node_holding_code = null
	
	var code = code_text
	
	## code cant be loaded like that. you need to load from file
	
	## we can create the file in folde of our application
	var script_path: String = "user://"+unique_code_file_name
	print(script_path)
	## to see where it is store in the end
	print(ProjectSettings.globalize_path(script_path))
	
	var file_connection =FileAccess.open(script_path, FileAccess.WRITE)
	if file_connection:
		file_connection.store_string(code)
		file_connection.close()
	else:
		push_error("Oups file was not created")
		return
	
	#lets see that
	# lets try to execute it now.
	var script:Script = ResourceLoader.load(script_path,"GDScript",0)
	if not script is GDScript:
		push_error("Hum that not a Godot Script")
		return 
	
	## We created and loaded a script in our application.
	## now we need to use it
	
	## we need for that a node
	var node :Node = Node.new()
	# we have a new node but not yet in the scene
	node.set_script(script)
	# he has our code 
	node.set_process(true)
	# he now use _process(delta)
	node.set_physics_process(true)
	# in case we need it later
	
	## now we add it in the scene
	created_node_holding_code = node
	add_child(node)
	on_created_node_with_code.emit(node)
	## from here you will have ready trigger
	# and _process
	
