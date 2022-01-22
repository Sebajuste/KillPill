class_name AStarGoapGrid
extends AStarGrid



var actions: Array = []


func _init(a: Array):
	
	self.actions = a
	


func _equals_goal(node, goal) -> bool:
	
	return node.check(goal.state)
	


func get_near_edges(node, context: Dictionary) -> Array:
	var links = .get_near_edges(node, context)
	
	for action in actions:
		
		if node.check( action.get_preconditions() ) and action.is_reachable(context):
			
			var new_state = node.state.duplicate()
			for key in action.get_effects():
				new_state[key] = action.is_effect(key)
			
			var next_node = AStarGoapGridNode.new(action)
			next_node.state = new_state
			
			var edge := AStarEdge.new(next_node, action.cost(context) )
			
			links.append(edge)
	
	return links
