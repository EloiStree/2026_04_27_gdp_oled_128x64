class_name SSD1306UdpSendToSingleTarget
extends Node




signal on_target_set_valide_ipv4(is_valide:bool)

@export var target_ip: String = "192.168.178.122"
@export var target_port: int = 3615
@export var use_timer_send: bool = true
@export var send_interval_ms: int = 500

var next_byte_array: Array[bool] = []
var next_byte_array_packed: PackedByteArray = PackedByteArray()

var timer : Timer



func _ready() -> void:
	var timer: Timer = Timer.new()
	timer.wait_time = send_interval_ms / 1000.0
	timer.connect("timeout", Callable(self, "send_byte_in_memory"))
	add_child(timer)
	self.timer = timer
	if use_timer_send:
		timer.start()
	else:
		timer.stop()


func set_target_ip(ip: String) -> void:
	var is_valid: bool = is_valid_ipv4(ip)
	on_target_set_valide_ipv4.emit(is_valid)
	target_ip = ip

func set_target_port(port: int) -> void:
	target_port = port

func set_time_between_sends(milliseconds: int) -> void:
	send_interval_ms = milliseconds
	timer.wait_time = send_interval_ms / 1000.0


func start_timer_pushing_bytes() -> void:
	use_timer_send = true
	timer.start()

func stop_timer_pushing_bytes() -> void:
	use_timer_send = false
	timer.stop()

func set_timer_pushing_bytes_active(active: bool) -> void:
	use_timer_send = active
	if active:
		start_timer_pushing_bytes()
	else:
		stop_timer_pushing_bytes()

var changed_since_last_set=false

var previously_pushed : Array[bool] =[]
	
func set_next_push_byte_as_array_bool(array:Array[bool]) -> void:
	
	next_byte_array = array
	next_byte_array_packed = PackedByteArray()
	for i in range(0, next_byte_array.size(), 8):
		var byte_value: int = 0
		for j in range(8):
			if i + j < next_byte_array.size() and next_byte_array[i + j]:
				byte_value |= (1 << (7 - j))
		next_byte_array_packed.append(byte_value)

func set_next_push_byte_as_array_bool_and_send(array:Array[bool]) -> void:
	set_next_push_byte_as_array_bool(array)
	send_byte_in_memory()

func send_byte_in_memory():
	send_byte_in_memory_pack(next_byte_array_packed)

func send_byte_in_memory_pack(pack: PackedByteArray) -> void:
	send_bytes_to_target(target_ip, target_port, pack)


func send_integer_0() -> void:
	send_integer_value_as_little_endian(0)

func send_integer_1() -> void:
	send_integer_value_as_little_endian(1)

func send_integer_42() -> void:
	send_integer_value_as_little_endian(42)

func send_integer_2501() -> void:
	send_integer_value_as_little_endian(2501)

func send_integer_value_as_little_endian(value: int) -> bool:
	var byte_array: PackedByteArray = PackedByteArray()
	byte_array.append(value & 0xFF)
	byte_array.append((value >> 8) & 0xFF)
	byte_array.append((value >> 16) & 0xFF)
	byte_array.append((value >> 24) & 0xFF)
	return send_bytes_to_target(target_ip, target_port, byte_array)



static func send_integer_little_endian_to_target(ip:String, port:int, integer:int)->bool:
	var byte_array: PackedByteArray = PackedByteArray()
	byte_array.append(integer & 0xFF)
	byte_array.append((integer >> 8) & 0xFF)
	byte_array.append((integer >> 16) & 0xFF)
	byte_array.append((integer >> 24) & 0xFF)
	return send_bytes_to_target(ip, port, byte_array)

static func send_1d_boolean_array_to_target(ip:String, port:int, array:Array[bool])->bool:
	var byte_array: PackedByteArray = PackedByteArray()
	for i in range(0, array.size(), 8):
		var byte_value: int = 0
		for j in range(8):
			if i + j < array.size() and array[i + j]:
				byte_value |= (1 << (7 - j))
		byte_array.append(byte_value)
	return send_bytes_to_target(ip, port, byte_array)

static func send_1d_packed_boolean_array_to_target(ip:String, port:int, array:PackedByteArray)->bool:
	return send_bytes_to_target(ip, port, array)

static func is_valid_ipv4(ip: String) -> bool:
	var parts = ip.split(".")
	if parts.size() != 4:
		return false
	for part in parts:
		if not part.is_valid_int():
			return false
		var num = int(part)
		if num < 0 or num > 255:
			return false
	return true

static func send_bytes_to_target(ip:String, port:int, array:PackedByteArray)->bool:

	if not is_valid_ipv4(ip):
		return false

	var udp_packet := PacketPeerUDP.new()
	udp_packet.set_dest_address(ip, port)
	udp_packet.put_packet(array)	
	udp_packet.close()
	return true
	
	
