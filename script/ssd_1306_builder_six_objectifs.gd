class_name SSD1306BuilderSixObjectifs
extends Node

@export var drawer: SSD1306SetGetScreenStateInterfaceWithCPU

@export var margin_left_right: int = 2
@export var margin_down_top: int = 2
@export var line_height: int = 10
@export var line_cut_border: int = 5

func push_in_text(text_of_six_objectif:String):	
	drawer.flush()
	var lines := text_of_six_objectif.split("\n")
	var size:int = lines.size()
	if size>=1:
		drawer.print_text_at_lrtd(margin_left_right, margin_down_top, lines[0])
		drawer.draw_bool_line_right_lrtd( line_cut_border, margin_down_top + line_height, 128)
	var text_without_first_line:String = text_of_six_objectif.substr(lines[0].length() + 1, text_of_six_objectif.length())
	drawer.print_text_at_lrtd(margin_left_right, line_height+4, text_without_first_line)
