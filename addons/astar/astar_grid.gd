class_name AStarGrid
extends Object


var max_deep_search := 75


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
	





func find_path(from: AStarGridNode, goal: AStarGridNode, context := {}) -> Array:
	
	
	if _equals_goal(from, goal):
		return []
	
	var open_list: Array = []
	
	var closed_list: Array = []
	
	var start_path_node = AStarPathNode.new(null, from)
	start_path_node.priority = from.get_weight() + from.heuristic(goal, context)
	
	open_list.append( start_path_node )
	
	var count = 0
	
	while not open_list.empty():
		
		count += 1
		if count > max_deep_search:
			push_error("Max loop reached : %d" % count)
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
			
			var open_path_node = _search(open_list, neighbor)
			
			if open_path_node == null:
				
				var visited_path_node: AStarPathNode = _search(closed_list, neighbor)
				
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
		
		closed_list.append( path_node )
		
		if need_sort:
			open_list.sort_custom(PathSorter, "priority_sort")
	
	return []


func _build_path_list(path_node: AStarPathNode) -> Array:
	var path_list = []
	while path_node.parent != null:
		path_list.append( path_node.grid_node )
		path_node = path_node.parent
	path_list.append( path_node.grid_node )
	path_list.invert()
	return path_list


func _search(list : Array, needle : AStarGridNode):
	for item in list:
		if item.grid_node.equals(needle):
			return item
	return null
