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
	var text : String = convert_booleans_to_text_image(array)
	var bytes_1d : PackedByteArray = convert_booleans_to_1d_packed_bytes(array)
	on_export_as_text_image.emit(text)
	on_export_as_1d_pack_bytes.emit(bytes_1d)

	
static func convert_booleans_to_text_image(array:Array[bool])->String:
	var result:String =""
	for i in range(128*64):
		result += "1" if array[i] else "0"
		if (i + 1) % 128 == 0:
			result += "\n"
	return result


static func convert_booleans_to_1d_packed_bytes(array:Array[bool])->PackedByteArray:
	var result = PackedByteArray()
	for i in range(0, array.size(), 8):
		var byte = 0
		for j in range(8):
			if i + j < array.size() and array[i + j]:
				byte |= (1 << j)
		result.append(byte)
	return result
