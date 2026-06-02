class_name E13DownloadTextFromClipboard
extends Node

signal on_text_downloaded_from_clipboard(text:String)
signal on_clipboard_download_failed()

@export var load_clipboard_at_ready:bool

func _ready():
	if load_clipboard_at_ready:
		download_text_from_clipboard()

func download_text_from_clipboard() -> void:
	var clipboard_text:String = get_text_from_clipboard()
	if clipboard_text.strip_edges().is_empty():
		on_clipboard_download_failed.emit()
	else:
		on_text_downloaded_from_clipboard.emit(clipboard_text)


static func get_text_from_clipboard() -> String:
	return DisplayServer.clipboard_get()
