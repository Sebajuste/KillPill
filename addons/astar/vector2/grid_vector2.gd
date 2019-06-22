tool
extends AStarGrid


var _nodes: Dictionary = {}


func add_grid_node(node):
	_nodes[node.position] = node
	

func get_grid_node(pos: Vector2):
	return _nodes[pos]

func get_nearest_node(position: Vector2, accept_self=true):
	var nearest_node = null
	var nearest_distance = null
	for key in _nodes:
		var node = _nodes[key]
		if accept_self or position != node.position:
			var distance = (node.position - position).length()
			if nearest_distance == null or distance < nearest_distance:
				nearest_distance = distance
				nearest_node = node
	return nearest_node

func get_nearest_nodes(position: Vector2) -> Array:
	var nearest_node = get_nearest_node( position, false )
	
	var distance = (nearest_node.position - position).length()
	
	var nodes = []
	
	for key in _nodes:
		var node = _nodes[key]
		
		if abs((node.position - position).length() - distance) < 0.1:
			nodes.append(node)
	
	return nodes


func get_near_edges(node: AStarGridNode, context: Dictionary) -> Array:
	var links = .get_near_edges(node, context)
	
	#for i in range(3):
	#	for j in range(3):
	#		_add_edge(links, node, i - 1, j - 1)
	
	#_add_edge(links, node, -1, 0)
	#_add_edge(links, node, 1,  0)
	#_add_edge(links, node, 0, -1)
	#_add_edge(links, node, 0,  1)
	
	for n in get_nearest_nodes(node.position):
		var cost = (n.position - node.position).length()
		links.append( AStarEdge.new( n, cost ) )
	
	return links

func _add_edge(links: Array, node: AStarGridNode, x, y):
	if x == 0 and y == 0:
		return
	
	var pos = node.position + Vector2(x, y)
	if _nodes.has( pos ):
		var cost = (pos - node.position).length()
		links.append( AStarEdge.new( _nodes[pos], cost ) )

func _ready():
	
	for node in get_children():
		_nodes[node.position] = node
	