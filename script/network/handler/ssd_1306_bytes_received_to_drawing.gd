class_name SSD1306BytesReceivedToDrawing
extends Node



@export var drawer:SSD1306SetGetScreenStateInterfaceWithCPU

signal on_found_lrtd_full_frame(bytes_received: Array[bool])
signal on_found_lrtd_one_horizontal_page(page_id_0_7:int , bytes_received: Array[int])


## Would be better to use signal,but I am missing time.
## A solution would be to have a drawer fast version and an signal.

# signal on_found_lrdt_one_pixel_to_set(x_left_right: int, y_down_top: int, is_on: bool)
# signal on_found_lrdt_one_pixel_to_toggle(x_left_right: int, y_down_top: int)

# signal on_found_lrdt_draw_line(x_start: int, y_start: int, x_end: int, y_end: int, is_on:bool)

# signal on_found_lrdt_draw_rectangle(x_start: int, y_start: int, x_end: int, y_end: int, is_on:bool)
# signal on_found_lrdt_draw_rectangle_border(x_start: int, y_start: int, x_end: int, y_end: int, is_on:bool)

# signal on_found_lrdt_draw_circle(x_start: int, y_start: int, x_end: int, y_end: int, is_on:bool)
# signal on_found_lrdt_draw_circle_border(x_start: int, y_start: int, x_end: int, y_end: int, is_on:bool)

# signal on_found_iid_value(value:int)
# signal on_found_iid_index_value(index:int,value:int)


func push_in_bytes_received(bytes_received: PackedByteArray) -> void:
	var array_of_bools: Array[bool] = []
	for byte in bytes_received:
		for bit_index in range(8):
			var bit_value = (byte >> (7 - bit_index)) & 1
			array_of_bools.append(bit_value == 1)

	var size:int = bytes_received.size()
	if size == 0:
		return
	if size == 1024:
		var bytes_received_as_bool: Array[bool] = []
		for b in bytes_received:
			for i in range(8):
				bytes_received_as_bool.append((b >> i) & 1) # Convert byte to bits and append to the array
		on_found_lrtd_full_frame.emit(bytes_received_as_bool)
		if drawer:
			drawer.override_array_with_boolean_array(bytes_received_as_bool)
		pass

	if size == 129:
		var page_id_0_7:int = bytes_received[0]
		var bytes_received_as_int: Array[int] = []
		for i in range(1, size):
			bytes_received_as_int.append(bytes_received[i])
		on_found_lrtd_one_horizontal_page.emit(page_id_0_7, bytes_received_as_int)
		if drawer:
			drawer.draw_page(page_id_0_7, bytes_received_as_int)
		#PAGING
		pass

	if size == 3:
		var x_left_right: int = bytes_received[0]
		var y_top_bottom: int = bytes_received[1]
		var byte_value: int = bytes_received[2]
		var is_on: bool = byte_value != 0
		if drawer:
			drawer.set_pixel(x_left_right, y_top_bottom, is_on)
		#on_found_lrdt_one_pixel_to_set.emit(x_left_right, y_top_bottom, is_on)

	if size == 2:
		var x_left_right: int = bytes_received[0]
		var y_top_bottom: int = bytes_received[1]
		if y_top_bottom <64:
			
			if drawer:
				drawer.toggle_2d_lrdt_value(x_left_right,y_top_bottom)
			#on_found_lrdt_one_pixel_to_toggle.emit(x_left_right, y_top_bottom)
		else: 
			var y_top_bottom_mod:int = y_top_bottom %64
			var is_over_64:int = y_top_bottom> 64
			
			if drawer:
				drawer.set_value_at_x_y_lrdt(x_left_right,y_top_bottom_mod, is_over_64)
			#on_found_lrdt_one_pixel_to_toggle.emit(x_left_right, y_top_bottom_mod,is_over_64)
	
	if size == 6 :
		var x_start: int = bytes_received[0]
		var y_start: int = bytes_received[1]
		var x_end: int = bytes_received[2]
		var y_end: int = bytes_received[3]
		var type_of_drawing: int = bytes_received[4]
		var set_type = bytes_received[5]
		var is_on: bool = false
		var is_toggle:bool=false
		if set_type==2:
			is_toggle = true
		elif set_type==1:
			is_on = true
		elif set_type==0:
			is_on = false

		if drawer==null:
			return 
			

		var v_start = Vector2i(x_start,y_start)
		var v_end = Vector2i(x_end,y_end)
		match type_of_drawing:
			0:
				drawer.draw_bool_line_v2i_lrdt(v_start,v_end,is_on)
				pass
			1:
				drawer.draw_bool_fill_rectangle_lrdt_from_to_vectori(v_start,v_end,is_on)
				pass
			2:
				drawer.draw_bool_border_rectangle_lrtd_from_to_vectori(v_start,v_end, is_on)
				pass 
			3:
				# Draw Circle/Ellipse false
				drawer.draw_bool_ellipsis_in_rectangle_lrtd_from_to_vectori(v_start,v_end,is_on)
				pass 
			4:
				# Draw  Circle/Ellipse Border false
				drawer.draw_bool_ellipsis_border_in_rectangle_lrtd_from_to_vectori(v_start,v_end,is_on)
				pass 
			5:
				pass 
			
			6:
				pass 
			7:
				pass 
			8:
				pass 
			9:
				pass 
				
	

	if size ==4  or size ==8 or size ==12 or size ==16:
		
		pass
		
