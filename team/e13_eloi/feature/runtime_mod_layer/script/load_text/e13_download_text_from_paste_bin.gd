class_name E13DownloadTextFromPasteBin
extends Node

signal text_downloaded(text:String)
signal download_failed(code:int)

@export var paste_url:String = "https://pastebin.com/9J42b49m"
@export var load_at_ready:bool=false
@export var use_print_debug:bool=false

@onready var http:HTTPRequest = HTTPRequest.new()

func _ready():
	add_child(http)
	http.request_completed.connect(_on_request_completed)
	if load_at_ready:
		download_and_emit()

func download_and_emit() -> void:
	var raw_url:String = _to_raw_url(paste_url)

	print("Downloading:", raw_url)

	var headers:Array[String] = [
		"User-Agent: Mozilla/5.0"
	]

	var err:int = http.request(raw_url, headers, HTTPClient.METHOD_GET)

	if err != OK:
		download_failed.emit(err)


func _to_raw_url(url:String) -> String:
	url = url.strip_edges()

	# Already raw
	if "/raw/" in url:
		return url

	# Remove query string
	var clean_url:String = url.split("?")[0]

	# Extract last part (paste ID)
	var id:String = clean_url.get_file()

	if id.is_empty():
		return url

	return "https://pastebin.com/raw/" + id


func _on_request_completed(
	result:int,
	response_code:int,
	headers:PackedStringArray,
	body:PackedByteArray
) -> void:

	print("HTTP:", response_code)

	if response_code == 200:
		var text:String = body.get_string_from_utf8()
		if use_print_debug:
			print("URL: ",paste_url," CODE: ", text)
		text_downloaded.emit(text)
	else:
		download_failed.emit(response_code)
