class_name SSD1306ModLiteRunLayerBuilder
extends SSD1306ModLiteLayerBuilderWithTagName

signal on_append_layer_called(array_128x64:Array[bool])
signal on_append_layer_start()
signal on_append_layer_end()
signal on_append_layer_end_with_execute_time(milliseconds:float)

@export var screens:Array[SSD1306NodeFacadeLite]
var array_128x64:Array[bool]=[]

@export var use_await:bool=true
@export var run_layers_at_ready:bool=true
@export var use_default_refresher:bool=true
@export var time_between_refresh:float=0.05

@export var last_executed_time:float
 	
var _next_frame_in:float=0
		
func _ready() -> void:
	if array_128x64.size()!=8192:
		array_128x64.resize(8192)
	if run_layers_at_ready:
		call_append_layer_with_signal_and_time()
			
func _process(delta: float) -> void:
	if _next_frame_in<=0.0:
		_next_frame_in=time_between_refresh
		call_append_layer_with_signal_and_time()
	_next_frame_in-=delta

func call_append_layer_with_signal_and_time():
	_next_frame_in = time_between_refresh

	on_append_layer_start.emit()
	var start_time: int = Time.get_ticks_msec()
	if use_await:
		await append_layer(array_128x64)
	else:
		append_layer(array_128x64)
	var end_time: int = Time.get_ticks_msec()
	var time_in_milliseconds: float = float(end_time - start_time)
	
	on_append_layer_end.emit()
	on_append_layer_called.emit(array_128x64)
	on_append_layer_end_with_execute_time.emit(time_in_milliseconds)
	last_executed_time= time_in_milliseconds
	
	for screen in screens:
		if screen:
			screen.set_value_with_1d_array_and_draw(array_128x64)
