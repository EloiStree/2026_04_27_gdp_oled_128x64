class_name SSD1306BridgeUiButtonsToFacade
extends Node

@export var display_facade_lite: SSD1306NodeFacade
@export var button_clear:Button
@export var button_full:Button
@export var button_inverse_display_color:Button
@export var button_inverse_array_value:Button

@export var button_export_as_text_01_image:Button
@export var button_import_as_text_01_image:Button

@export var button_export_as_b58_html_image:Button
@export var button_import_as_b58_html_image:Button

@export var button_export_as_b64_html_image:Button
@export var button_export_as_svg_html_image:Button

@export var line_edit_udp_target:LineEdit

@export_group("Special")
@export var text_edit_six_objectifs:TextEdit
@export var text_edit_to_qr_code:TextEdit


@export_group("Color True/False")
@export var color_picker_false:ColorPickerButton
@export var color_picker_true:ColorPickerButton

@export_group("Color Style")
@export var button_style_gameboy:Button
@export var button_style_black_white:Button
@export var button_style_oled_sh1106:Button
@export var button_style_oled_ssd1306:Button
@export var button_style_e_ink:Button
@export var button_style_black_green_matrix:Button
@export var button_style_flipper_orange:Button
	

@export_group("Bit Shift")
@export var button_bit_shift_1d_right:Button
@export var button_bit_shift_1d_left:Button
@export var button_bit_shift_2d_left:Button
@export var button_bit_shift_2d_right:Button
@export var button_bit_shift_2d_up:Button
@export var button_bit_shift_2d_down:Button
@export var button_bit_shift_2d_up_left:Button
@export var button_bit_shift_2d_up_right:Button
@export var button_bit_shift_2d_down_left:Button
@export var button_bit_shift_2d_down_right:Button


 

func _ready() -> void:
	var d :=display_facade_lite
	if d==null:
		return
	if button_clear!=null:
		button_clear.button_down.connect(d.flush_and_draw)
	if button_full!=null:
		button_full.button_down.connect(d.fill_and_draw)
	if button_inverse_display_color!=null:
		button_inverse_display_color.button_down.connect(d.inverse_display_texture_colors)
	if button_inverse_array_value!=null:
		button_inverse_array_value.button_down.connect(d.inverse_display_value)
		
	if button_style_gameboy!=null:
		button_style_gameboy.button_down.connect(d.set_texture_color_gameboy)
	if button_style_black_white!=null:
		button_style_black_white.button_down.connect(d.set_texture_color_black_and_white)
	if button_style_oled_sh1106!=null:
		button_style_oled_sh1106.button_down.connect(d.set_texture_color_oled_blue_sh1106)
	if button_style_oled_ssd1306!=null:
		button_style_oled_ssd1306.button_down.connect(d.set_texture_color_oled_blue_ssd1306)
	if button_style_e_ink!=null:
		button_style_e_ink.button_down.connect(d.set_texture_color_e_ink)
	if button_style_black_green_matrix!=null:
		button_style_black_green_matrix.button_down.connect(d.set_texture_color_black_green_matrix)
	if button_style_flipper_orange!=null:
		button_style_flipper_orange.button_down.connect(d.set_texture_color_flipper_orange)	
	if line_edit_udp_target!=null:
		line_edit_udp_target.text_changed.connect(d.set_udp_target_ipv4)
	

	if color_picker_false!=null:
		color_picker_false.color_changed.connect(d.set_texture_color_false_color)
	if color_picker_true!=null:
		color_picker_true.color_changed.connect(d.set_texture_color_true_color)


	if button_bit_shift_1d_right!=null:
		button_bit_shift_1d_right.button_down.connect(d.bit_shift_1d_right)
	if button_bit_shift_1d_left!=null:
		button_bit_shift_1d_left.button_down.connect(d.bit_shift_1d_left)
	if button_bit_shift_2d_left!=null:
		button_bit_shift_2d_left.button_down.connect(d.bit_shift_2d_left)
	if button_bit_shift_2d_right!=null:
		button_bit_shift_2d_right.button_down.connect(d.bit_shift_2d_right)
	if button_bit_shift_2d_up!=null:
		button_bit_shift_2d_up.button_down.connect(d.bit_shift_2d_up)
	if button_bit_shift_2d_down!=null:
		button_bit_shift_2d_down.button_down.connect(d.bit_shift_2d_down)
	if button_bit_shift_2d_up_left!=null:
		button_bit_shift_2d_up_left.button_down.connect(d.bit_shift_2d_up_left)
	if button_bit_shift_2d_up_right!=null:
		button_bit_shift_2d_up_right.button_down.connect(d.bit_shift_2d_up_right)
	if button_bit_shift_2d_down_left!=null:
		button_bit_shift_2d_down_left.button_down.connect(d.bit_shift_2d_down_left)
	if button_bit_shift_2d_down_right!=null:
		button_bit_shift_2d_down_right.button_down.connect(d.bit_shift_2d_down_right)


	if text_edit_six_objectifs!=null:
		text_edit_six_objectifs.text_changed.connect(d.set_six_objectifs_from_text)
	if text_edit_to_qr_code!=null:
		text_edit_to_qr_code.text_changed.connect(d.set_to_qr_code_from_text)
	

	if button_export_as_b58_html_image!=null:
		button_export_as_b58_html_image.button_down.connect(d.export_state_as_image_b58_in_clipboard)

	if button_import_as_b58_html_image!=null:
		button_import_as_b58_html_image.button_down.connect(d.import_state_as_image_b58_from_clipboard)
		
	if button_export_as_text_01_image!=null:		
		button_export_as_text_01_image.button_down.connect(d.export_state_as_image_in_clipboard)

	if button_import_as_text_01_image!=null:
		button_import_as_text_01_image.button_down.connect(d.import_state_as_image_from_clipboard)

	if button_export_as_b64_html_image!=null:
		button_export_as_b64_html_image.button_down.connect(d.export_state_as_image_b64_in_clipboard)

	if button_export_as_svg_html_image!=null:
		button_export_as_svg_html_image.button_down.connect(d.export_state_as_image_svg_in_clipboard)


	
	
	
