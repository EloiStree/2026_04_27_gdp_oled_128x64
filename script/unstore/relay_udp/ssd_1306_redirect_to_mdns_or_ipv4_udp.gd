class_name SSD1306RedirectToMdnsOrIpv4Udp
extends Node

@export var _target_address: String
@export var _target_port: int =  3615
@export var _send_bytes_count:int

var _udp: PacketPeerUDP

func _ready() -> void:
	_udp = PacketPeerUDP.new()

	var err := _udp.bind(0)
	if err != OK:
		push_error("Failed to initialize UDP socket: %s" % err)
	set_target_address(_target_address)
	

func set_target_address(p_address: String) -> void:
	var address := p_address.strip_edges()

	if is_target_in_ipv4_format(address):
		_target_address = address
	else:
		_target_address = try_to_convert_address_from_mdns_to_ipv4(address)

	if _target_address.is_empty():
		push_error("Could not resolve target address: %s" % address)


func is_target_in_ipv4_format(address: String) -> bool:
	var parts := address.split(".")

	if parts.size() != 4:
		return false

	for part in parts:
		if not part.is_valid_int():
			return false

		var octet := int(part)
		if octet < 0 or octet > 255:
			return false

	return true


func try_to_convert_address_from_mdns_to_ipv4(address: String) -> String:
	var resolved_address := IP.resolve_hostname(
		address,
		IP.TYPE_IPV4
	)

	if resolved_address.is_empty():
		push_warning("mDNS/hostname resolution failed: %s" % address)
		return ""

	return resolved_address


func relay_packed_byte_array_to_udp_target(bytes: PackedByteArray) -> void:
	if _udp==null:
		_udp = PacketPeerUDP.new()
	
	if _target_address.is_empty():
		push_warning("No UDP target address configured.")
		return

	if not is_target_in_ipv4_format(_target_address):
		push_error("Invalid IPv4 target: %s" % _target_address)
		return


	var err := _udp.set_dest_address(_target_address, _target_port)

	if err != OK:
		push_error("Failed to set UDP destination: %s" % err)
		return

	err = _udp.put_packet(bytes)

	if err != OK:
		push_error("Failed to send UDP packet: %s" % err)
		
	_send_bytes_count+=len(bytes)
	#print("Sent bytes ", len(bytes))
