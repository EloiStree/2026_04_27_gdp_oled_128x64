class_name SSD1306WebSocketBytesClient
extends Node

signal on_bytes_received(data: PackedByteArray)
signal on_bit_received(bit_array: Array[bool])
signal on_bit_8192_received(bit_array: Array[bool])  # 128x64 OLED
signal connection_established()
signal connection_closed()
signal connection_error()

@export var server_host: String = "127.0.0.1"
@export var server_port: int = 3617
@export var poll_interval_msec: int = 5
@export var auto_reconnect: bool = true
@export var reconnect_delay_msec: int = 2000

var ws_peer: WebSocketPeer
var is_running: bool = false
var bytes_queue: Array[PackedByteArray] = []
var queue_mutex: Mutex = Mutex.new()

var _reconnect_timer: Timer

func _ready() -> void:
	_reconnect_timer = Timer.new()
	_reconnect_timer.one_shot = true
	_reconnect_timer.timeout.connect(_on_reconnect_timer_timeout)
	add_child(_reconnect_timer)
	
	connect_to_server()


func connect_to_server() -> void:
	if is_running:
		return
		
	is_running = true
	bytes_queue.clear()
	
	ws_peer = WebSocketPeer.new()
	var url = "ws://%s:%d" % [server_host, server_port]
	var err = ws_peer.connect_to_url(url)
	
	if err != OK:
		push_error("SSD1306WebSocketBytesClient: Failed to connect to %s (error %d)" % [url, err])
		is_running = false
		connection_error.emit()
		_schedule_reconnect()
		return
		
	print("SSD1306WebSocketBytesClient: Connecting to ", url)


func _on_reconnect_timer_timeout() -> void:
	if auto_reconnect and not is_connected_to_server():
		connect_to_server()


func _process(_delta: float) -> void:
	if not ws_peer:
		return
		
	ws_peer.poll()
	var state = ws_peer.get_ready_state()
	
	match state:
		WebSocketPeer.STATE_OPEN:
			while ws_peer.get_available_packet_count() > 0:
				var data := ws_peer.get_packet()
				if not data.is_empty():
					queue_mutex.lock()
					bytes_queue.append(data)
					queue_mutex.unlock()
					
			# Fire established signal once
			if not connection_established.get_connections().size():
				connection_established.emit()
				
		WebSocketPeer.STATE_CLOSING, WebSocketPeer.STATE_CLOSED:
			if is_running:
				_handle_disconnect()
	
	_drain_queue()


func _drain_queue() -> void:
	while true:
		queue_mutex.lock()
		if bytes_queue.is_empty():
			queue_mutex.unlock()
			break
		var data: PackedByteArray = bytes_queue.pop_front()
		queue_mutex.unlock()
		
		on_bytes_received.emit(data)
		
		# Convert to bits
		var bit_array: Array[bool] = []
		bit_array.resize(data.size() * 8)
		
		var idx := 0
		for byte_val in data:
			for bit_idx in range(8):
				bit_array[idx] = bool((byte_val >> (7 - bit_idx)) & 1)
				idx += 1
		
		on_bit_received.emit(bit_array)
		
		if bit_array.size() == 8192:
			on_bit_8192_received.emit(bit_array)


func _handle_disconnect() -> void:
	var was_running := is_running
	is_running = false
	
	if ws_peer:
		ws_peer.close()
		ws_peer = null
	
	connection_closed.emit()
	print("SSD1306WebSocketBytesClient: Connection closed")
	
	if was_running and auto_reconnect:
		_schedule_reconnect()


func _schedule_reconnect() -> void:
	if auto_reconnect:
		_reconnect_timer.start(reconnect_delay_msec / 1000.0)


func is_connected_to_server() -> bool:
	return ws_peer and ws_peer.get_ready_state() == WebSocketPeer.STATE_OPEN


func send_data(data: PackedByteArray) -> bool:
	if not is_connected_to_server():
		return false
	return ws_peer.put_packet(data) == OK


func disconnect_from_server() -> void:
	auto_reconnect = false
	if ws_peer:
		ws_peer.close()
	is_running = false


func _exit_tree() -> void:
	disconnect_from_server()
