extends Node

class_name AStarGrid

class PathSorter:
	
	static func cost_sort(a: AStarPathNode, b: AStarPathNode) -> bool:
		return a.cost < b.cost
	
	static func priority_sort(a: AStarPathNode, b: AStarPathNode) -> bool:
		return a.priority < b.priority

func add_grid_node(node):
	pass

func get_near_edges(node, context: Dictionary):
	var edges = []
	for link in node.links:
		edges.append(link)
	return edges

func connect_grid_node(from_node: AStarGridNode, to_node: AStarGridNode, cost: float=1.0, bidirectional: bool=true):
	from_node.add_link( AStarEdge.new(to_node, cost) )
	if bidirectional:
		to_node.add_link( AStarEdge.new(from_node, cost) )
	

func _equals_goal(node, goal) -> bool:
	return node == goal

func _search(list: Array, needle):
	
	for item in list:
		if item.grid_node.equals(needle):
			return item
	return null


func find_path(from: AStarGridNode, goal: AStarGridNode, context := {}) -> Array:
	
	if _equals_goal(from, goal):
		return []
	
	var open_list: Array = []
	#var closed_map: Dictionary = {}
	var closed_list: Array = []
	
	var start_path_node = AStarPathNode.new(null, from)
	start_path_node.priority = from.get_weight() + from.heuristic(goal, context)
	#closed_map[start_path_node.grid_node] = start_path_node
	#closed_list.append( start_path_node )
	open_list.append( start_path_node )
	
	var count = 0
	
	while not open_list.empty():
		
		count += 1
		if count > 50:
			print("Max loop reached")
			
			break
		
		var path_node: AStarPathNode = open_list.pop_front()
		var grid_node: AStarGridNode = path_node.grid_node
		
		var need_sort = false
		
		if _equals_goal(grid_node, goal):
			return _build_path_list(path_node)
		
		for edge in get_near_edges(grid_node, context):
			
			var neighbor: AStarGridNode = edge.to
			
			var new_cost: float = path_node.cost + edge.cost + neighbor.get_weight()
			var priority: float = new_cost + neighbor.heuristic(goal, context)
			
			#var visited_path_node: AStarPathNode = closed_map.get(neighbor, null)
			var visited_path_node: AStarPathNode = _search(closed_list, neighbor)
			
			var is_in_open_list: bool = false
			var open_path_node: AStarPathNode = null
			for n in open_list:
				if n.grid_node.equals(neighbor):
					open_path_node = n
					is_in_open_list = true
					break
			
			if not is_in_open_list:
				
				if visited_path_node == null:
					var next_path_node = AStarPathNode.new(path_node, neighbor)
					next_path_node.cost = new_cost
					next_path_node.priority = priority
					open_list.append( next_path_node )
					need_sort = true
				elif new_cost < visited_path_node.cost:
					visited_path_node.parent = path_node
					visited_path_node.cost = new_cost
					visited_path_node.priority = priority
					need_sort = true
				
			else:
				
				if new_cost < open_path_node.cost:
					open_path_node.parent = path_node
					open_path_node.cost = new_cost
					open_path_node.priority = priority
					need_sort = true
		
		#closed_map[grid_node] = path_node
		closed_list.append( path_node )
		
		if need_sort:
			open_list.sort_custom(PathSorter, "priority_sort")
	
	return []

func _build_path_list(path_node: AStarPathNode):
	
	var path_list = []
	
	while path_node.parent != null:
		path_list.append( path_node.grid_node )
		path_node = path_node.parent
	path_list.append( path_node.grid_node )
	
	path_list.invert()
	
	return path_list

