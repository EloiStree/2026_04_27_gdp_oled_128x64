class_name SSD1306Exporter
extends Node


signal on_export_as_1d_pack_bytes(bytes:PackedByteArray)
signal on_export_as_text_image(text_as_image:String)
signal on_export_as_eight_pages_8x128(p0:PackedByteArray,p1:PackedByteArray,p2:PackedByteArray,p3:PackedByteArray,p4:PackedByteArray,p5:PackedByteArray,p6:PackedByteArray,p7:PackedByteArray)


@export var direct_import_from: SSD1306SetGetScreenStateInterfaceWithCPU


func export_from_inspector_target():
	if direct_import_from:
		var array = direct_import_from.get_value_as_1d_array_copy()
		export_given_boolean_array(array)

func export_given_boolean_array(array:Array[bool]):
	var text : String = convert_bool_array_to_text_image_01(array)
	var bytes_1d : PackedByteArray = convert_bool_array_to_1d_packed_bytes(array)
	on_export_as_text_image.emit(text)
	on_export_as_1d_pack_bytes.emit(bytes_1d)

	
static func convert_bool_array_to_text_image_01(array:Array[bool])->String:
	var result:String =""
	for i in range(128*64):
		result += "1" if array[i] else "0"
		if (i + 1) % 128 == 0:
			result += "\n"
	return result


static func convert_bool_array_to_1d_packed_bytes(array:Array[bool])->PackedByteArray:
	var result = PackedByteArray()
	for i in range(0, array.size(), 8):
		var byte = 0
		for j in range(8):
			if i + j < array.size() and array[i + j]:
				byte |= (1 << j)
		result.append(byte)
	return result





#region B58
const BASE58_CHARS := "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
static func convert_bool_array_to_base_58_text(array: Array[bool]) -> String:
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











static func convert_bool_array_from_base_58_text(base58_string: String) -> Array[bool]:
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
#endregion
	
	
	
	
	
	
	
	
	


#region B64
static func convert_texture_to_markdown_base64_image(texture: Texture2D) -> String:
	var image: Image = texture.get_image()
	var png_buffer: PackedByteArray = image.save_png_to_buffer()
	var b64 := Marshalls.raw_to_base64(png_buffer)
	var html := '<img width="128" height="64" src="data:image/png;base64,%s" />' % b64
	return html

## <img width="128" height="64" src="data:image/png;base64,iVBOR...w0KGgo=" />
static func convert_base64_html_image_to_bool_array(img_html: String) -> Array[bool]:
	# Extract base64 data
	var marker := "base64,"
	var index_start := img_html.to_lower().find(marker)
	if index_start == -1:
		return []
	index_start += marker.length()
	
	var index_end := img_html.find("\"", index_start)
	if index_end == -1:
		index_end = img_html.length()
	
	var b64_text := img_html.substr(index_start, index_end - index_start)
	var png_bytes: PackedByteArray = Marshalls.base64_to_raw(b64_text)
	
	# Load as Image
	var image := Image.new()
	var err := image.load_png_from_buffer(png_bytes)
	if err != OK:
		push_error("Failed to load PNG from base64")
		return []	
	image.convert(Image.FORMAT_L8)
	var data := image.get_data()
	var bool_array: Array[bool] = []
	bool_array.resize(image.get_width() * image.get_height())
	
	var i := 0
	for y in image.get_height():
		for x in image.get_width():
			var brightness := data[i]
			bool_array[i] = brightness < 128
			i += 1
	
	return bool_array
#endregion







#region SVG
static func convert_texture_to_markdown_svg_image(texture: Texture2D) -> String:
	var image: Image = texture.get_image()
	var array: Array[bool] = []
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			var color := image.get_pixel(x, y)
			var is_true := color.r > 0.5 or color.g > 0.5 or color.b > 0.5
			array.append(is_true)
	return convert_bool_array_to_svg_for_markdown(array)

static func convert_bool_array_to_svg_for_markdown(array: Array[bool]) -> String:
	var width := 128
	var height := 64

	var svg := ""
	svg += '<?xml version="1.0" encoding="UTF-8"?>\n'
	svg += '<svg xmlns="http://www.w3.org/2000/svg" width="128" height="64" viewBox="0 0 128 64">\n'

	var color_true := "#000000"
	var color_false := "#FFA500"

	for i in range(array.size()):
		var x := i % width
		var y := i / width

		var is_true := array[i]
		var color := color_true if is_true else color_false

		svg += '<rect x="%d" y="%d" width="1" height="1" fill="%s"/>\n' % [x, y, color]

	svg += "</svg>"
	return svg

#endregion
