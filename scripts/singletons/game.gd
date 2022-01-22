extends Node


signal level_node_created(node)


func add_node_in_level(node : Node):
	
	emit_signal("level_node_created", node)
	
