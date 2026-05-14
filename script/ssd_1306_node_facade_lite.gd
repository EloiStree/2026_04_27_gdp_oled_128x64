## For developer that want to learn or create their own tools.
## Simple boolean resource and texture generator facade for SSD1306-like displays.
class_name SSD1306NodeFacadeLite
extends Node

@export var boolean_state:SSD1306SetGetScreenStateInterfaceWithCPU
@export var texture_builder:SSD1306BoolArrayToTexture

#region To Change the Color Style

## EN:
## Invert the rendering colors used by the texture builder.
## This does NOT modify the stored boolean values, only the visual rendering.
##
## FR:
## Inverse les couleurs de rendu utilisées par le générateur de texture.
## Cela NE modifie PAS les valeurs booléennes stockées, uniquement l'affichage visuel.
func inverse_display_texture_colors():
	texture_builder.inverse_color_true_false()

## EN:
## Define the rendering color used for pixels set to TRUE.
##
## FR:
## Définit la couleur de rendu utilisée pour les pixels à TRUE.
func set_texture_color_true_color(true_color:Color):
	texture_builder.set_color_on(true_color)

## EN:
## Define the rendering color used for pixels set to FALSE.
##
## FR:
## Définit la couleur de rendu utilisée pour les pixels à FALSE.
func set_texture_color_false_color(false_color:Color):
	texture_builder.set_color_off(false_color)


## EN:
## Allows when you start learning to display a bit of context for debugging on the top line of the screen.
##
## FR:
## Permet d'afficher un peu de contexte pour le débogage sur la ligne supérieure de l'écran lors de l'apprentissage.
func print_title_up(title:String):
	title=title.replace("\n", "")
	boolean_state.print_text_at_lrtd(2,2,title)


## EN:
## Allows when you start learning to display a bit of context for debugging on the bottom line of the screen.
##
## FR:
## Permet d'afficher un peu de contexte pour le débogage sur la ligne inférieure de l'écran lors de l'apprentissage.
func print_title_down(title:String):
	title=title.replace("\n", "")
	boolean_state.print_text_at_lrtd(2,59,title)
	

#endregion


#region ONLY ALLOWED IF YOU ARE LEARNING FROM THE SSD1306

## EN:
## Set a pixel value using a 1D index from 0 to 8191.
## The index is mapped from left-to-right and top-to-bottom on a 128x64 display.
## This does NOT automatically redraw the texture.
##
## FR:
## Définit la valeur d’un pixel avec un index 1D de 0 à 8191.
## L’index est mappé de gauche à droite puis de haut en bas sur un écran 128x64.
## Cela NE redessine PAS automatiquement la texture.
func set_value_at_index_1d(index_0_8191:int, is_on:bool):
	boolean_state.set_value_at_index_1d(index_0_8191, is_on)



## EN:
## Get the stored boolean value from a 1D index.
## Index order is left-to-right and top-to-bottom.
##
## FR:
## Récupère la valeur booléenne stockée à partir d’un index 1D.
## L’ordre des index est de gauche à droite puis de haut en bas.
func get_value_at_index_1d(index_0_8191:int)->bool:
	var is_on := boolean_state.get_value_at_index_1d(index_0_8191)
	return is_on

## EN:
## Replace the internal storage array with the given boolean array.
## The array should contain exactly 8192 elements.
##
## FR:
## Remplace le tableau interne par le tableau booléen fourni.
## Le tableau doit contenir exactement 8192 éléments.
## EN:
## Replace the internal storage array with the given boolean array and trigger a redraw.
## The array should contain exactly 8192 elements.
##
## FR:
## Remplace le tableau interne par le tableau booléen fourni et déclenche un rendu.
## Le tableau doit contenir exactement 8192 éléments.
func set_value_with_1d_array(array:Array[bool]):
	boolean_state.override_array_with_boolean_array(array)



## EN:
## Replace the internal storage array with the given boolean array and trigger a redraw.
## The array should contain exactly 8192 elements.
##
## FR:
## Remplace le tableau interne par le tableau booléen fourni et déclenche un rendu.
## Le tableau doit contenir exactement 8192 éléments.
func set_value_with_1d_array_and_draw(array:Array[bool]):
	set_value_with_1d_array(array)
	draw()

## EN:
## Return the direct reference to the internal boolean storage array.
## Be careful when modifying it and NEVER resize it.
##
## FR:
## Retourne la référence directe du tableau booléen interne.
## Faites attention lors des modifications et ne le redimensionnez JAMAIS.
func get_value_as_1d_array_reference()->Array[bool]:
	return boolean_state.get_value_as_1d_array_reference()




## EN:
## Return a copy of the internal boolean storage array.
##
## FR:
## Retourne une copie du tableau booléen interne.
func get_value_as_1d_array_copy()->Array[bool]:
	return boolean_state.get_value_as_1d_array_copy()
	
## EN:
## Trigger a redraw/render of the stored boolean data.
## Rendering can be expensive, so avoid calling this too often.
##
## FR:
## Déclenche un rendu/redessin des données booléennes stockées.
## Le rendu peut être coûteux, évitez donc de l’appeler trop souvent.
func draw():
	boolean_state.emit_boolean_array_as_updated()	

#endregion


#region ONLY ALLOWED IF YOU LEARNED TO USE 1D INDEX AS TOP DOWN / DOWN TOP

## EN:
## Set a pixel value using X/Y coordinates.
## Coordinates are interpreted from left-to-right and top-to-bottom.
##
## FR:
## Définit la valeur d’un pixel avec des coordonnées X/Y.
## Les coordonnées sont interprétées de gauche à droite et de haut en bas.
func set_value_at_x_y_lrtd(x_left_right:int,y_top_down:int, is_on:bool):
	boolean_state.set_value_at_x_y_lrtd(x_left_right,y_top_down,is_on)

## EN:
## Get a pixel value using X/Y coordinates.
## Coordinates are interpreted from left-to-right and top-to-bottom.
##
## FR:
## Récupère la valeur d’un pixel avec des coordonnées X/Y.
## Les coordonnées sont interprétées de gauche à droite et de haut en bas.
func get_value_at_x_y_lrtd(x_left_right:int,y_top_down:int)->bool:
	return boolean_state.get_value_at_x_y_lrtd(x_left_right,y_top_down)

## EN:
## Set a pixel value using X/Y coordinates.
## Coordinates are interpreted from left-to-right and bottom-to-top.
##
## FR:
## Définit la valeur d’un pixel avec des coordonnées X/Y.
## Les coordonnées sont interprétées de gauche à droite et de bas en haut.
func set_value_at_x_y_lrdt(x_left_right:int,y_down_top:int, is_on:bool):
	boolean_state.set_value_at_x_y_lrdt(x_left_right,y_down_top,is_on)

## EN:
## Get a pixel value using X/Y coordinates.
## Coordinates are interpreted from left-to-right and bottom-to-top.
##
## FR:
## Récupère la valeur d’un pixel avec des coordonnées X/Y.
## Les coordonnées sont interprétées de gauche à droite et de bas en haut.
func get_value_at_x_y_lrdt(x_left_right:int,_down_top:int)->bool:	
	return boolean_state.get_value_at_x_y_lrdt(x_left_right,_down_top)

#endregion
