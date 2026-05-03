class_name SSD1306UdpBytesListener
extends Node

signal on_bytes_received(data: PackedByteArray)
signal on_bit_received(bit_array: Array[bool])
signal on_bit_8196_received(bit_array: Array[bool])

@export var default_port: int = 3615

var udp_socket: PacketPeerUDP
var listen_thread: Thread
var bytes_queue: Array[PackedByteArray] = []
var queue_mutex: Mutex = Mutex.new()
var is_running: bool = false

@export var port: int = default_port
@export var poll_interval_msec: int = 5  # Lower = more responsive, higher = less CPU


func _ready() -> void:
	start_listening()


func start_listening() -> void:
	if is_running:
		return
	
	is_running = true
	bytes_queue.clear()
	
	listen_thread = Thread.new()
	listen_thread.start(_listen_thread_function)


func _listen_thread_function() -> void:
	udp_socket = PacketPeerUDP.new()
	
	if udp_socket.bind(port) != OK:
		push_error("SSD1306UDPBytesListener: Failed to bind UDP socket on port %d" % port)
		is_running = false
		return
	
	print("SSD1306UDPBytesListener: Listening on UDP port %d" % port)
	
	while is_running:
		if udp_socket.get_available_packet_count() > 0:
			var packet := udp_socket.get_packet()
			if not packet.is_empty():
				queue_mutex.lock()
				bytes_queue.append(packet)
				queue_mutex.unlock()
		else:
			OS.delay_msec(poll_interval_msec)


func _process(_delta: float) -> void:
	# Drain the queue in batches to avoid holding the mutex too long
	while true:
		queue_mutex.lock()
		if bytes_queue.is_empty():
			queue_mutex.unlock()
			break
		
		var data := bytes_queue.pop_front()
		queue_mutex.unlock()
		
		on_bytes_received.emit(data)

		var array_of_bools: Array[bool] = []
		for byte in data:
			for bit_index in range(8):
				var bit_value = (byte >> (7 - bit_index)) & 1
				array_of_bools.append(bit_value == 1)
		on_bit_received.emit(array_of_bools)	
		if array_of_bools.size() == 8192:  # 128x64 bits
			on_bit_8196_received.emit(array_of_bools)


func stop_listening() -> void:
	if not is_running:
		return
	
	is_running = false
	
	# Wait for thread to finish
	if listen_thread and listen_thread.is_alive():
		listen_thread.wait_to_finish()
	
	# Clean up socket
	if udp_socket:
		udp_socket.close()
		udp_socket = null
	
	print("SSD1306UDPBytesListener: Stopped listening")


func _exit_tree() -> void:
	stop_listening()


# Optional: allow changing port at runtime
func set_port(new_port: int) -> bool:
	if is_running:
		push_warning("Cannot change port while listening. Stop first.")
		return false
	
	port = new_port
	return true
