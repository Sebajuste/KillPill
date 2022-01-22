extends Node

signal properties_created(id, properties)
signal properties_removed(id)
signal property_changed(id, key, value)

var enabled := false
var is_server := false

var player_info : Dictionary = {}



var node_sync_list := []


class NodeSyncInfo:
	var path : String
	var filename : String
	var name : String
	var id : int



# Called when the node enters the scene tree for the first time.
func _ready():
	
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if not node_sync_list.empty():
		
		for index in range(node_sync_list.size()):
			var node_sync_info: NodeSyncInfo = node_sync_list[index]
			
			var parent = get_node(node_sync_info.path)
			
			print("parent: ", parent)
			if parent:
				
				var scene = load(node_sync_info.filename)
				var instance = scene.instance()
				instance.name = node_sync_info.name
				instance.set_network_master( node_sync_info.id )
				parent.add_child(instance)
				print("instance ready ", instance.get_path() )
				node_sync_list.remove(index)
				return
	


func close_connection():
	if enabled:
		get_tree().get_network_peer().close_connection()
		enabled = false
		player_info.clear()
	


func is_enabled() -> bool:
	return enabled


func set_property(key: String, value):
	
	rpc("rpc_set_property", key, value)
	


func get_property(peer_id: int, key: String):
	if player_info.has(peer_id):
		var info = player_info[peer_id]
		return info[key]
	return null


func erase_property(key: String):
	
	rpc("rpc_erase_property", key)
	


func get_self_peer_id() -> int:
	
	return get_tree().get_network_unique_id()
	


func broadcast(res: Node, method: String, args: Array):
	var self_peer_id = get_self_peer_id()
	for peer_id in player_info:
		if self_peer_id != peer_id:
			res.rpc(method, args)


func spawn_node(parent : Node, node: Node):
	print("spawn_node ALL -> parent: ", parent.get_path(), ", name: ", node.name, ", filename: ", node.filename)
	if node.filename:
		rpc("rpc_spawn_node", parent.get_path(), node.name, node.filename)
	

func spawn_node_id(id: int, parent : Node, node: Node):
	print("spawn_node [%d] -> parent: " % id, parent.get_path(), ", name: ", node.name, ", filename: ", node.filename)
	if node.filename:
		rpc_id(id, "rpc_spawn_node", parent.get_path(), node.name, node.filename)


func despawn_node(node: Node):
	
	rpc("rpc_despawn_node", node.get_path())
	


func rename_node(node: Node, old_name: String):
	
	rpc("rcp_rename_node", node.get_parent().get_path(), old_name, node.name)
	


func get_own_properties() -> Dictionary:
	var self_peer_id = get_self_peer_id()
	if not player_info.has(self_peer_id):
		player_info[self_peer_id] =  {}
	return player_info[self_peer_id]


func _player_connected(id: int):
	
	rpc_id(id, "rpc_register_player", get_own_properties() )
	


func _player_disconnected(id: int):
	player_info.erase(id)
	emit_signal("properties_removed", id)


func _connected_ok():
	enabled = true
	get_own_properties()
	pass


func _connected_fail():
	enabled = false
	player_info.clear()


func _server_disconnected():
	enabled = false
	player_info.clear()


func _check_version(id: int, key: String, value):
	if is_server and key == "game_version":
		var properties := get_own_properties()
		if value != properties.game_version:
			get_tree().get_network_peer().disconnect_peer(id)


remotesync func rpc_register_player(properties):
	var id = get_tree().get_rpc_sender_id()
	player_info[id] = properties
	emit_signal("properties_created", id, properties)


remotesync func rpc_set_property(key: String, value):
	var id = get_tree().get_rpc_sender_id()
	var info
	if not player_info.has(id):
		info = {}
		player_info[id] = info
		emit_signal("properties_created", id, info)
	else:
		info = player_info[id]
	info[key] = value
	emit_signal("property_changed", id, key, value)
	_check_version(id, key, value)


remotesync func rpc_erase_property(key: String):
	var id = get_tree().get_rpc_sender_id()
	var info : Dictionary = player_info[id]
	info.erase(key)


remote func rpc_spawn_node(parent_path: String, name: String, filename: String):
	var id = get_tree().get_rpc_sender_id()
	var node_sync_info := NodeSyncInfo.new()
	node_sync_info.path = parent_path
	node_sync_info.name = name
	node_sync_info.filename = filename
	node_sync_info.id = id
	node_sync_list.append(node_sync_info)
	


func rpc_despawn_node(node_path: String):
	var node = get_tree().get_root().get_node(node_path)
	node.queue_free()


func rcp_rename_node(parent_path: String, old_name: String, name: String):
	var parent = get_tree().get_root().get_node(parent_path)
	var node = parent.get_node(old_name)
	node.set_name(name)
