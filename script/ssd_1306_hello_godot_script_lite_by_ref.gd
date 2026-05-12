
## The aim of this class is to show the basic of Godot in a hello script display on the OLED screen. It is a simple script that can be used as a starting point for more complex projects. 

class_name SSD1306HelloGodotScriptLiteByRef
extends Node




func your_code_here():
	# Your code here
	
	example_of_how_to_use_godot_script()
	pass

#region TO EASE THE LEARNING HERE IS A SMALL STARTER TEMPLATE

# 🐿️ Signal can allows to say: I don't care how, but can you do that

## Ask to set the data with this array value and then draw on the OLED screen.
signal on_set_and_draw_array_requested(array_to_draw:Array[bool])

## Ask to display a debug text somewhere in the scene.
signal on_debug_print_requested(text:String)

## 🐿️ OLED SSD is all until the end of humanity will stay at 128x64.
## So we can define some constant to say this value will never change.
const OLED_WIDTH :int = 128
const OLED_HEIGHT :int = 64
const OLED_PIXELS :int = OLED_WIDTH * OLED_HEIGHT

## 🐿️ We will use a boolean array to store the state of each pixel. True for on, False for off.
var screen :Array[bool] = []

## 🐿️ This variable can be used to enable or disable debug print in the console. It is true by default.
## @export allows the designer to turn it on or off in the editor without changing the code.
@export var use_debug_print_in_console :bool = true


## 🐿️ _init and _ready are two very important functions in Godot.
## _init is called when the object is created, and _ready is called when the node is added to the scene.
func _init() -> void:
	screen.resize(OLED_PIXELS)
	screen.fill(false)

## 🐿️ Static methods can be accessed from anywhere in the application,
## It is nice to make utility code for your app.
## Array are passed by reference, look on google for more information.
static func append_random_layer(array:Array[bool]) -> void:
	for i in range(array.size()):
		array[i] = randi() % 2 == 0

## 🐿️ To check where we are in the script it could be nice to create log.
## This ask the designer to display a log in the scene.
func debug_log(text:String) -> void:
	if use_debug_print_in_console:
		print(text)
	on_debug_print_requested.emit(text)

## 🐿️ It takes the array we are building and ask the designer to draw it on the OLED screen.
## What ever it means.
func draw() -> void:
	on_set_and_draw_array_requested	.emit(screen)


## 🐿️ In Godot you can wait by creating a temporary timer and using `await` to sleep until it is done.
func wait_for_seconds(seconds:float) -> void:
	await get_tree().create_timer(seconds).timeout

## 🐿️ In Godot you can wait by creating a temporary timer and using `await` to sleep until it is done.
func draw_then_wait_for_seconds(seconds:float) -> void:
	draw()
	await get_tree().create_timer(seconds).timeout


## 🐿️ An example of how you can create a screen effect taking advantage of the "coroutine" system.
## call `await coroutine_screen_effect()` to start it.
func coroutine_screen_effect() -> void:
	for i in range(30):
		await wait_for_seconds(0.05)
		append_random_layer(screen)
		draw()
	screen.fill(false)
	draw()

## When ready to start and added existing in the scene.
func _ready() -> void:
	draw()
	await coroutine_screen_effect()
	your_code_here()

func reload_current_scene():
	get_tree().reload_current_scene()
#endregion

## =======================================

#region AN EXAMPLE OF HOW TO USE GODOT SCRIPT.
func example_of_how_to_use_godot_script():
	#🐿️ OK ok vous connaissez rien de Godot et vous avez deja entre vu un language programmation avant😉
	
	# <-🐿️ Ce ci est un commentaire. Ca permet just de parler entre developers.
	# Ce sera retirer dans le code final.

	"""
	🐿️	Ca c est pour ecrire un commentaire sur plusieurs ligne 😊
	Si vous avez des choose a dire

	"""

	## <- 🐿️ Ca c est un commentaire qui devant un signal, func, @export permet de donner de la documentation
	## Pour les designer et developpers.

	
	#🐿️ Une tradition de developer est toujours commencer par un hello world afficher dans la console.
	print("Hello World in the console!")

	#🐿️ Alors c est bien pratique mais c'est pas visible en jeu...
	# Demandonas a notre designer de l afficher en jeu avec un signal.
	# Via cette methode que je vous ai preparer.
	debug_log("Hello World!")

	#🐿️ Laissons nous du temps poura aller le voir
	await wait_for_seconds(2.0)
	debug_log("Allez hope, on y va")

	var un_variable = 42
	# 🐿️ + est une concatenation. Ca permet de fusionner deux textes.
	# 42 c est un nombre par un text. Donc on va le transformer en text avec str() pour pouvoir le fusionner.
	debug_log("Voici une variable: " + str(un_variable))

	#🐿️ Je vous propose pour l occasion d allumer votre 42 eme pixel. 
	screen[41] = true
	## Pourquoi 41 du coup?
	## Parce les developers on compte depuis 0
	## Ici de 0 a 41 ca fait 42.
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Essayons d'allumer le premier et le dernier pixel
	debug_log("Allumons le premier et le dernier pixel")
	# 0 pour le premier pixel 
	screen[0] = true
	# la taille du tableau -1 pour le dernier pixel
	screen[screen.size() - 1] = true
	draw()


	await wait_for_seconds(2.0)
	#🐿️ Allumons la premier ligne
	debug_log("Allumons la premier ligne avec while")
	var debut_de_la_ligne = 0
	var fin_de_ligne = 128
	var un_compteur = debut_de_la_ligne
	## tantque le compte est inferieur a la fin de la ligne
	while un_compteur < fin_de_ligne:
		## la case du compteur devient vrai
		screen[un_compteur] = true
		## On attemd un pour le fun de voir le processus
		draw()
		await wait_for_seconds(0.001)
		## On va au pixel suivant
		un_compteur = un_compteur + 1
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Alors si on veut dessiner la ligne de gauche.
	# On dessine le premier pixel puis on saute de 128 pixel pour dessiner le pixel suivant
	# et ainsi de suite
	debug_log("La colonne de gauche while")
	var debut_de_la_colonne = 0
	var fin_de_la_colonne = 64
	var un_compteur_colonne = debut_de_la_colonne
	while un_compteur_colonne < fin_de_la_colonne:
		screen[un_compteur_colonne * 128] = true
		draw()
		await wait_for_seconds(0.001)
		un_compteur_colonne += 1
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Les while c est bien mais on a un outil un peu plus direct les for
	# Ca permet de parcourir un tableau.
	# pour le nomtre de element dans mon tableau fait cela
	# pour generer un tableau on peut utiliser range() qui genere une suite de nombre dans une liste
	debug_log("Ligne du bas avec for")

	## Ici 8064 8065 8066 ... 8191 sont les index de la ligne du bas
	for un_element_de_la_liste in range(8064, 8192):
		screen[un_element_de_la_liste] = true
		draw()
		await wait_for_seconds(0.001)

	draw()

	await wait_for_seconds(2.0)
	#🐿️ Utilisons donc un for pour la colone de droite.
	# On veut commencer a 127 puis 255 puis 383 ... jusqu a 8191
	# Donc on va a un nombre et on saute de 128 a chaque fois.
	debug_log("Colonne de droite avec for et pas 128")
	# De 127 a 8192 en sautant de 128 creer mois une liste a parcourir avec for
	# liste sera 127, 255, 383 ... 8063, 8191
	for un_element_de_la_liste in range(127, 8192, 128):
		screen[un_element_de_la_liste] = true
		draw()
		await wait_for_seconds(0.001)
	draw()

	await wait_for_seconds(2.0)

	#🐿️ Essayons de dessiner une ligne de pointier
	# Si le nombre est pair on allume le pixel sinon on le laisse eteint
	# Etre pair ca revient a etre divisible par 2 et donc que le reste soit 0
	debug_log("Dession un pixel sur deux")
	var tout_les_pixels = range(0, 8192)
	for un_pixel in tout_les_pixels:
		## / veut dire divise
		## % veut dire divise et donne moie ce qui reste
		## si il reste 0 c est pair sinon c est impair
		if un_pixel % 2 == 0:
			screen[un_pixel] = true
		else:
			screen[un_pixel] = false
		draw()
		await wait_for_seconds(0.001)

		## 🐿️ On... 8192 pixel, ca devient vite long a dessiner.
		## Utilisons un breark (qui veut dire "stop la boucle") pour s arreter a 400 pixel
		if un_pixel ==400:
			break
	draw()

	await wait_for_seconds(2.0)
	#🐿️ On a dessinner des jolies lignes.
	# Mais c est mieux les grillages 😉
	# Il faut doit une ligne sur deux inverse pour faire un grillage
	debug_log("Dessin d un grillage")
	for une_ligne in range(0, 64):  
		# Noter que range est dit exclusif sur la sortie, donc ca va de 0 a 63
		for une_colonne in range(0, 128): 
			# Pareil pour la ligne de pixel, ca va de 0 a 127
			if une_ligne % 2 == 0:
				if une_colonne % 2 == 0:
					screen[une_ligne * 128 + une_colonne] = true
				else:
					screen[une_ligne * 128 + une_colonne] = false
			else:
				if une_colonne % 2 == 0:
					screen[une_ligne * 128 + une_colonne] = false
				else:
					screen[une_ligne * 128 + une_colonne] = true
		# 🐿️ Pour aller plus vite on va dessinez ligne par ligne
		draw()
		await wait_for_seconds(0.05)
	# On a utiliser ici une boucle for and une boucle for
	# En anglais `a nested loop` (une boucle imbriquée)
	draw()





	await wait_for_seconds(2.0)
	#🐿️ Nettoyons tout ca avec un blink
	debug_log("Clean Blink")
	#🐿️ I did it slow because I dont want to kill epileptic students
	for i in range(2):
		screen.fill(true)
		draw()
		await wait_for_seconds(1)
		screen.fill(false)
		draw()
		await wait_for_seconds(1)
	draw()


	await wait_for_seconds(2.0)
	#🐿️ Commencons a typer no variable.
	# Il y a pas beaucoup de type primitif en Godot
	var un_nombre_entier :int = 4
	var un_nombre_a_virgule_flottante :float = 3.14
	var un_integer_en_texte :String = "127"
	var un_float_en_texte :String = "1.9"
	## 🐿️ A votre avis que va donner le code suivant
	
	debug_log("Des variables typé et des conversions de type")
	# 🐿️ ici cest un nombre sans virgule on est bon pour un tableau
	screen[un_nombre_entier] = true
	# 🐿️ 3.14 ca n est pa vraiment possible dans un tableau ca veut rien dire.
	# On doit donc le convertir en entier avec un int()
	screen[int(un_nombre_a_virgule_flottante)] = true
	# 🐿️ On peut aussi faire cela sur du text
	screen[int(un_integer_en_texte)] = true
	# 🐿️ La pa contre 1.9 converti en entier ca nous donnera... 1. 🤔
	# Si vous voulez deux, il faut arrondire avec ceil() ou floor() ou round() selon le comportement que vous voulez.
	# float() ici converti un text en floatant et int() converti le float en entier
	screen[int(float(un_float_en_texte))] = true	
	draw()


	await wait_for_seconds(2.0)
	#🐿️ Creeons un calculatrice pour reviser les operateurs
	debug_log("Operateurs")
	var a :int = 10
	var b :int = 3
	debug_log("a + b = " + str(a + b))
	screen[a + b] = true
	await draw_then_wait_for_seconds(2.0)
	debug_log("a - b = " + str(a - b))
	screen[a - b] = true
	await draw_then_wait_for_seconds(2.0)
	debug_log("a * b = " + str(a * b))
	screen[a * b] = true
	await draw_then_wait_for_seconds(2.0)
	debug_log("a / b = " + str(a / b))
	screen[int(a / b)] = true
	await draw_then_wait_for_seconds(2.0)
	debug_log("a mod b = " + str(a % b))
	screen[a % b] = true
	await draw_then_wait_for_seconds(2.0)
	debug_log("a puissance b = " + str(a ** b))
	screen[int(a ** b) % 8192] = true
	await draw_then_wait_for_seconds(2.0)
	debug_log("a == b = " + str(a == b))
	screen.fill(a == b)
	await draw_then_wait_for_seconds(2.0)
	debug_log("a != b = " + str(a != b))
	screen.fill(a != b)
	await draw_then_wait_for_seconds(2.0)
	debug_log("a > b = " + str(a > b))
	screen.fill(a > b)
	await draw_then_wait_for_seconds(2.0)
	debug_log("a < b = " + str(a < b))
	screen.fill(a < b)
	await draw_then_wait_for_seconds(2.0)
	debug_log("a >= b = " + str(a >= b))
	screen.fill(a >= b)
	await draw_then_wait_for_seconds(2.0)
	debug_log("a <= b = " + str(a <= b))
	screen.fill(a <= b)
	await draw_then_wait_for_seconds(2.0)
	debug_log("a and b = " + str(a and b))
	screen.fill(a and b)
	await draw_then_wait_for_seconds(2.0)
	debug_log("a or b = " + str(a or b))
	screen.fill(a or b)
	await draw_then_wait_for_seconds(2.0)
	debug_log("not (a == b) = " + str(not (a == b)))
	screen.fill(not (a == b))
	await draw_then_wait_for_seconds(2.0)
	#On pourrait faire du nor, nand, xor etc... mais je pense que c est suffisant pour le moment.
	draw()

	screen.fill(false)
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Si vous avez compris les nested loop for.
	# Comment ferriez vous un cube d un point a un autre point?
	debug_log("Dessinons un cube")
	var x_start:int = 10
	var y_start:int = 5
	var x_end:int = 20
	var y_end:int = 30
	
	for ligne in range(y_start, y_end):
		for colonne in range(x_start, x_end):
			var index_a_une_dimension = ligne * 128 + colonne
			screen[index_a_une_dimension] = true
		draw()
		await wait_for_seconds(0.05)
	draw()



	await wait_for_seconds(2.0)
	#🐿️ Si on veut dessinez un cube plein avec ses bords
	# on peut verifier si cest le premier ou le dernier de la ligne.
	debug_log("Dessinons les bords du cube")
	for ligne in range(y_start, y_end):
		for colonne in range(x_start, x_end):
			var index_a_une_dimension = ligne * 128 + colonne
			if ligne == y_start or ligne == y_end - 1 or colonne == x_start or colonne == x_end - 1:
				screen[index_a_une_dimension] = true
			else:
				screen[index_a_une_dimension] = false
		draw()
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Si on veut faire plein de rectangle aleatoire sur l ecran
	debug_log("Dessinons des rectangles aleatoires")

	for i in range(5):
		var x_start_random:int = randi() % 64
		var y_start_random:int = randi() % 32
		var x_end_random:int = randi() % 64 + 64
		var y_end_random:int = randi() % 32 + 32
		
		screen.fill(false)
		for ligne in range(min(y_start_random, y_end_random), max(y_start_random, y_end_random)):
			for colonne in range(min(x_start_random, x_end_random), max(x_start_random, x_end_random)):
				if ligne == y_start_random or ligne == y_end_random - 1 or colonne == x_start_random or colonne == x_end_random - 1:
					var index_a_une_dimension = ligne * 128 + colonne
					screen[index_a_une_dimension] = true
		await draw_then_wait_for_seconds(1.0)


	draw()

	await wait_for_seconds(2.0)
	#🐿️ Essyons d afficher une lettre
	debug_log("Affichons une lettre")
	var letter_a :String="""
		01110|
		10001|
		10001|
		11111|
		10001|
		10001|
		10001|
	"""
	var offset_x = 10
	var offset_y = 10
	var left_right_letter_counter = 0
	var up_down_letter_counter = 0
	
	for character in letter_a:
		if character == "0" or character == "1":
			var index_a_une_dimension = (offset_y + up_down_letter_counter) * 128 + offset_x + left_right_letter_counter
			screen[index_a_une_dimension] = character == "1"
			left_right_letter_counter += 1
		elif character == "|":
			up_down_letter_counter += 1
			left_right_letter_counter = 0
		else:
			# Ignore les autres character 
			pass
		draw()
	draw()



	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()

	await wait_for_seconds(2.0)
	#🐿️ Commentaire
	debug_log("Commentaire:")
	draw()
	
#endregion
