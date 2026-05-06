class_name SSD1306ClipboardFromTo
extends Node


signal on_imported_array_from_clipboard(array : Array[bool])
signal on_imported_text_from_clipboard(text : String)
signal on_exported_array_in_clipboard(array : Array[bool])
signal on_exported_text_in_clipboard(text : String)

var current_state_of_array : Array[bool] = []

func set_reference_to_current_state_of_array(array : Array[bool]) -> void:
	current_state_of_array = array

func export_in_clipboard_from_given_reference() -> void:
	export_in_clipboard_state_of_array(current_state_of_array)



func export_in_clipboard_state_of_array(array : Array[bool]) -> void:
	# using "1" and "0"
	var string_to_export : String = ""
	for i in range(array.size()):
		string_to_export += (  "1" if array[i] else "0") + "\n"
	DisplayServer.clipboard_set(string_to_export)
	on_exported_array_in_clipboard.emit( array)
	on_exported_text_in_clipboard.emit( string_to_export)

func import_through_signal_from_clipboard_state_of_array():
	# using "1" and "0"
	var string_from_clipboard : String = DisplayServer.clipboard_get()
	var array_from_clipboard : Array[bool] = []
	for line in string_from_clipboard.split("\n"):
		if line == "1":
			array_from_clipboard.append(true)
		elif line == "0":
			array_from_clipboard.append(false)
	on_imported_array_from_clipboard.emit( array_from_clipboard)
	on_imported_text_from_clipboard.emit( string_from_clipboard)

func import_without_signal_from_clipboard_state_of_array() -> Array[bool]:
	# using "1" and "0"
	var string_from_clipboard : String = DisplayServer.clipboard_get()
	var array_from_clipboard : Array[bool] = []
	for line in string_from_clipboard.split("\n"):
		if line == "1":
			array_from_clipboard.append(true)
		elif line == "0":
			array_from_clipboard.append(false)

	return array_from_clipboard	



func export_in_clipboard_in_base_58() -> void:
	var base58_string := convert_to_base_58(current_state_of_array)
	DisplayServer.clipboard_set(base58_string)
	on_exported_text_in_clipboard.emit( base58_string)
	on_exported_array_in_clipboard.emit( current_state_of_array)

func import_from_clipboard_in_base_58() -> void:
	var base58_string := DisplayServer.clipboard_get()
	var array_from_clipboard := convert_from_base_58(base58_string)
	on_imported_text_from_clipboard.emit( base58_string)
	on_imported_array_from_clipboard.emit( array_from_clipboard)

static func convert_to_base_58(array: Array[bool]) -> String:	
	# VIBE CODED NOT TESTED, MAY CONTAIN BUGS, USE WITH CAUTION
	# TODO: READ WHEN BRAIN CLEAR AND TEST, MAY CONTAIN BUGS

	var bytes := PackedByteArray()
	for i in range(0, array.size(), 8):
		var byte := 0
		for j in range(8):
			if i + j < array.size() and array[i + j]:
				byte |= (1 << (7 - j))
		bytes.append(byte)
	
	# Convert to Base58
	var result := ""
	var zeros := 0
	while zeros < bytes.size() and bytes[zeros] == 0:
		zeros += 1
	
	var number := bytes.slice(zeros)
	if number.is_empty():
		return "1".repeat(zeros)
	
	var base58_chars := []
	var value := number
	
	while not value.is_empty():
		# Divide by 58
		var remainder := 0
		var quotient := PackedByteArray()
		
		for byte in value:
			var current := remainder * 256 + byte
			quotient.append(current / 58)
			remainder = current % 58
		
		base58_chars.append(BASE58_CHARS[remainder])
		
		# Remove leading zeros from quotient
		var start := 0
		while start < quotient.size() and quotient[start] == 0:
			start += 1
		value = quotient.slice(start)
	
	# Reverse the characters
	var reversed := []
	for i in range(base58_chars.size() - 1, -1, -1):
		reversed.append(base58_chars[i])
	
	return "1".repeat(zeros) + "".join(reversed)

const BASE58_CHARS := "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
static func convert_from_base_58(base58_string: String) -> Array[bool]:
	# VIBE CODED NOT TESTED, MAY CONTAIN BUGS, USE WITH CAUTION
	# TODO: READ WHEN BRAIN CLEAR AND TEST, MAY CONTAIN BUGS
	
	var zeros := 0
	for char in base58_string:
		if char == '1':
			zeros += 1
		else:
			break
	
	# Convert from Base58 to bytes
	var number := PackedByteArray()
	for char in base58_string:
		var digit := BASE58_CHARS.find(char)
		if digit == -1:
			push_error("Invalid Base58 character: ", char)
			return []
		
		# Multiply current number by 58 and add digit
		var carry := digit
		for i in range(number.size() - 1, -1, -1):
			carry += number[i] * 58
			number[i] = carry & 0xFF
			carry >>= 8
		
		while carry > 0:
			number.insert(0, carry & 0xFF)
			carry >>= 8
	
	# Add leading zeros
	var result_bytes := PackedByteArray()
	result_bytes.resize(zeros)
	result_bytes.fill(0)
	result_bytes += number
	
	# Convert bytes to bool array
	var bool_array: Array[bool] = []
	for byte in result_bytes:
		for j in range(8):
			bool_array.append((byte & (1 << (7 - j))) != 0)
	
	return bool_array



func export_in_clipboard_in_base_8192() -> void:
	var base8192_string := ChinaBase.convert_to_base_8192(current_state_of_array)
	DisplayServer.clipboard_set(base8192_string)
	on_exported_text_in_clipboard.emit( base8192_string)
	on_exported_array_in_clipboard.emit( current_state_of_array)

func import_from_clipboard_in_base_8192() -> void:
	var base8192_string := DisplayServer.clipboard_get()
	var array_from_clipboard := ChinaBase.convert_from_base_8192(base8192_string)
	on_imported_text_from_clipboard.emit( base8192_string)
	on_imported_array_from_clipboard.emit( array_from_clipboard)
