class_name SSD1306LoadScene
extends Node

@export var scene_to_load: PackedScene


func change_to_scene_in_inspector():
	get_tree().change_scene_to_packed(scene_to_load)
