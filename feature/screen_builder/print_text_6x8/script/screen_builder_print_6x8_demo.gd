class_name  ScreenBuilderPrint6x8LayerDemo
extends SSD1306ModLiteLayerWithTagName

@export_multiline() var text_to_print:String = "Objectifs :\n- Afficher du texte\n- Utiliser print_text_6x8\n- Utiliser sans background\n- Tester les positions\n- Valider l'affichage\n- Optimiser le code"
@export var offset_x_left_right: int = 1
@export var offset_y_top_down: int = 1
@export var value_text_color: bool = true
@export var use_background: bool = false
@export var dot_random_on_percentage: float = 0.1

func append_layer(array: Array[bool]) -> void:
	for i in range(8192):
		array[i] = randf() < dot_random_on_percentage
	ScreenBuilderPrint6x8.print_text_6x8_at_lrtd(array, Vector2i(offset_x_left_right, offset_y_top_down), text_to_print, value_text_color,use_background)
	
