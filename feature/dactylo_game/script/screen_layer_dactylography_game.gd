class_name ScreenLayerDactylographyGame
extends SSD1306ModLiteLayerWithTagName

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
@export var letter_to_last_typed_as_unicode: String = ""
@export var letter_to_last_typed_as_key_code: String = ""
@export var score: int = 0
@export var mistakes: int = 0

var array: Array[bool]
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	letter_to_train_on.replace("\n","")
	rng.randomize()

func clear_screen() -> void:
	for i in array.size():
		array[i] = false

enum PrintType{ OnlyTrue, Clear}
@export var print_type:PrintType
var first_print=true
func append_layer(array_128x64: Array[bool]) -> void:
	if array.size()!=8192:
		array.resize(8192)

	if first_print:
		first_print=false
		refresh_in(array_128x64)

	for i in range(8192):
		if print_type== PrintType.OnlyTrue:
			if array[i]==true:
				array_128x64[i]=array[i]
		else:
				array_128x64[i]=array[i]
	
func reset_char_to_type_randomly():
		var index := rng.randi_range(0, letter_to_train_on.length() - 1)
		letter_to_type = letter_to_train_on[index]

func refresh_in(array:Array[bool]) -> void:
	if letter_to_last_typed_as_key.to_lower()=="ctrl+delete":
		self.score=0
		self.mistakes=0
	if letter_to_last_typed_as_unicode == letter_to_type:
		reset_char_to_type_randomly()
		self.score+=1
	else :
		var skip :=false
		if letter_to_last_typed_as_key.to_lower().contains("shift"):
			skip=true
		if letter_to_last_typed_as_key.to_lower().contains("ctrl"):
			skip=true
		if letter_to_last_typed_as_key.to_lower().contains("alt"):
			skip=true						
		if not skip:
			self.mistakes+=1
			print("BAD",letter_to_last_typed_as_unicode ," vs ", letter_to_type)
		
	clear_screen()
	var point:Vector2i = Vector2i(4,2)
	ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(array, point,letter_to_type,true,true)
	point = Vector2i(20,2)
	ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(array, point,letter_to_last_typed,true,true)
	point = Vector2i(1,56)
	ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(array, point,letter_to_last_typed_as_key,true,true)
	ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(array, Vector2i(100,56),letter_to_last_typed_as_unicode,true,true)
	var left_key_code =100
	if int(letter_to_last_typed_as_key_code)>999:
		left_key_code-=20
	ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(array, Vector2i(left_key_code,48),letter_to_last_typed_as_key_code,true,true)
	ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(array, Vector2i(80,2),str(score),true,true)
	ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(array, Vector2i(100,2),str(mistakes),true,true)
		
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		var typed := event.as_text()
		if typed.is_empty():
			return
		letter_to_last_typed_as_key = typed
		var uni:int =event.unicode
		letter_to_last_typed_as_unicode= char(event.unicode) if uni!=0 else ""
		letter_to_last_typed_as_key_code= str(event.keycode)
		if use_print_debug:
			print("Input Event Key Name:", typed, "Unicode:",letter_to_last_typed_as_unicode, "Key Code:",letter_to_last_typed_as_key_code)
		refresh_in(self.array)
