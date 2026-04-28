class_name SSD1306FrameRefresher
extends Node

signal on_before_frame_refresh()
signal call_refreshing_frame() 
signal on_after_frame_refresh()

@export var time_between_frames: float = 0.1

@export var use_device_max_frame_rate: bool = true
@export var device_max_frame_rate: float = 10.0

@export_group("Debug")
@export var milliseconds_counter: int = 0
@export var next_frame_in_milliseconds: int = 0
@export var time_to_draw_frame:int=0



func _process(delta):
	if use_device_max_frame_rate:
		var time_minimum = 1.0 / device_max_frame_rate
		if time_between_frames < time_minimum:
			time_between_frames = time_minimum

	milliseconds_counter += int(delta * 1000)
	next_frame_in_milliseconds -= int(delta * 1000)
	if next_frame_in_milliseconds < 0:
		next_frame_in_milliseconds = int(time_between_frames * 1000)
		push_frame_signals()


func push_frame_signals():
	on_before_frame_refresh.emit()
	var start_time = Time.get_ticks_msec()
	call_refreshing_frame.emit()
	time_to_draw_frame = Time.get_ticks_msec() - start_time
	on_after_frame_refresh.emit()
