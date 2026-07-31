class_name DownloadTextFromWebPage
extends Node

signal on_text_downloaded(text:String)
signal on_download_failed(code:int)

@export var url:String = ""
@export var load_at_ready:bool=false
@export var use_debug_print:bool=false
@onready var http:HTTPRequest = HTTPRequest.new()

func _ready():
	add_child(http)
	http.request_completed.connect(_on_done)
	if load_at_ready:
		download()

func download() -> void:
	var final_url:String = _to_raw_url(url)

	if use_debug_print:
		print("Downloading:", final_url)

	var headers:Array[String] = [
		"User-Agent: Mozilla/5.0"
	]
	var err:int = http.request(final_url, headers, HTTPClient.METHOD_GET)
	if err != OK:
		on_download_failed.emit(err)


func _to_raw_url(input_url:String) -> String:
	input_url = input_url.strip_edges()

	if "/raw" in input_url:
		return input_url
	if "pastebin.com" in input_url:
		var clean:String = input_url.split("?")[0]
		var id:String = clean.get_file()

		if id.is_empty():
			return input_url

		return "https://pastebin.com/raw/" + id

	if "gist.github.com" in input_url:
		# format: https://gist.github.com/user/gistid
		var parts:Array = input_url.split("/")
		if parts.size() >= 5:
			var user:String = parts[3]
			var gist_id:String = parts[4]
			return "https://gist.githubusercontent.com/%s/%s/raw" % [user, gist_id]
		return input_url
	return input_url


func _on_done(
	result:int,
	response_code:int,
	headers:PackedStringArray,
	body:PackedByteArray
) -> void:

	if use_debug_print:
		print("HTTP:", response_code)

	if response_code == 200:
		var text:String = body.get_string_from_utf8()
		on_text_downloaded.emit(text)
	else:
		on_download_failed.emit(response_code)
