class_name E13ScreenModDactylographyGame
extends Node

@export var screen: SSD1306NodeFacadeLite
@export_multiline()
var letter_to_train_on: String = "1234567890!@#$%^&*()_+~{}:\"<>?|[]\\;',./'"
@export var y_top_distance:int =10
@export var y_top_distance_score:int =20
@export var x_center_distance:int =5
@export var use_print_debug:bool=true

@export_group("Debug")
@export var letter_to_type: String = ""
@export var letter_to_last_typed: String = ""
@export var letter_to_last_typed_as_key: String = ""
@export var score: int = 0
@export var mistakes: int = 0

var array: Array[bool]
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	letter_to_train_on.replace("\n","")
	rng.randomize()

	array.resize(8192)
	clear_screen()

	refresh()

func clear_screen() -> void:
	for i in array.size():
		array[i] = false

	screen.set_value_with_1d_array_and_draw(array)



func reset_char_to_type_randomly():
		var index := rng.randi_range(0, letter_to_train_on.length() - 1)
		letter_to_type = letter_to_train_on[index]



func refresh() -> void:

	if letter_to_type.is_empty():\
		reset_char_to_type_randomly()

	if letter_to_last_typed == letter_to_type:
		reset_char_to_type_randomly()


	clear_screen()
	var point:Vector2i = Vector2i(64-x_center_distance-6,1)
	E13ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(array, point,letter_to_type,true,true)
	point = Vector2i(64+x_center_distance,1)
	E13ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(array, point,letter_to_last_typed,true,true)
	point = Vector2i(1,56)
	E13ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(array, point,letter_to_last_typed_as_key,true,true)

	
	E13ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(array, Vector2i(2,46),str(score),true,true)
	E13ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(array, Vector2i(64,46),str(mistakes),true,true)
	screen.set_value_with_1d_array_and_draw(array)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var ch = char(event.unicode)
		letter_to_last_typed = ch
		if use_print_debug:
			print("Input Unicode:", ch)
		refresh()
		
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		var typed := event.as_text()
		if typed.is_empty():
			return			
		letter_to_last_typed_as_key = typed
		if use_print_debug:
			print("Input Event Key Name:", typed)
		refresh()
