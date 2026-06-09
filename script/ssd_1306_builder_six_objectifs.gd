class_name ScreenBuilderSixObjectifs
extends Node

static  var margin_left_right: int = 2
static  var margin_top_down: int = 2
static  var line_height: int = 10
static  var line_cut_border: int = 5

##ScreenBuilderSixObjectifs.draw_title_with_six_objectifs_from_text
static func draw_title_with_six_objectifs_from_text(array:Array[bool],text_of_six_objectif:String, clear_before_drawing:bool=true):
	if clear_before_drawing:
		array.fill(false)
	var lines := text_of_six_objectif.split("\n")
	var size:int = lines.size()
	if size>=1:
		ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(array,Vector2(margin_left_right, margin_top_down), lines[0],true,true)
		var from :Vector2 = Vector2(line_cut_border, margin_top_down+line_height)
		var to :Vector2 = Vector2(line_cut_border+128, margin_top_down+line_height)
		ScreenBuilderLineFromTo.draw_line_from_to(array,from, to,true)
	var text_without_first_line:String = text_of_six_objectif.substr(lines[0].length() + 1, text_of_six_objectif.length())
	ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(array,Vector2(margin_left_right, line_height+4),text_without_first_line,true,true)
