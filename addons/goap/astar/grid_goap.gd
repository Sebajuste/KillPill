extends AStarGrid

class_name AStarGoapGrid


var actions: Array = []

func _init(a: Array):
	self.actions = a

func _equals_goal(node, goal) -> bool:
	return node.check(goal.state)

func get_near_edges(node):
	var links = .get_near_edges(node)
	
	for action in actions:
		
		if node.check( action.preconditions ) and action.is_reachable():
			
			var new_state = node.state.duplicate()
			for key in action.effects:
				new_state[key] = action.effects[key]
			
			var next_node = AStarGoapGridNode.new(action)
			next_node.state = new_state
			
			var edge: AStarEdge = AStarEdge.new(next_node)
			
			links.append(edge)
	
	return links