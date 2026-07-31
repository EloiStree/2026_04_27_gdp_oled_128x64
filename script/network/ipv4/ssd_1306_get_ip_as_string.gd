class_name SSD1306GetIpAsString
extends Node

signal on_ipv4_group_found(interface_name: String, addresses: PackedStringArray)
signal on_ipv4_group_found_join(ipv4: String)
signal on_ipv4_found(ipv4: String)

@export var ipv4_found: String = ""
@export var spliter:String = ","
@export var refresh_at_ready: bool = true

func _ready() -> void:
	if refresh_at_ready:
		refresh_ipv4()


func refresh_ipv4() -> void:
	ipv4_found = ""
	
	# Get all local interfaces with their addresses
	var interfaces: Array[Dictionary] = IP.get_local_interfaces()
	var ipv4_addresses: Array[String] = []
	for iface in interfaces:
		var name: String = iface["name"]
		var addresses: PackedStringArray = iface["addresses"]
		
		on_ipv4_group_found.emit(name, addresses)
		for addr in addresses:
			if _is_ipv4(addr):
				ipv4_addresses.append(addr)
				ipv4_found = addr
				
				on_ipv4_found.emit(ipv4_found)
	
	on_ipv4_group_found_join.emit(spliter.join(ipv4_addresses))


func _is_ipv4(address: String) -> bool:
	if not "." in address:
		return false
	var parts := address.split(".")
	if parts.size() != 4:
		return false
	for p in parts:
		if not p.is_valid_int() or int(p) < 0 or int(p) > 255:
			return false
	return true
