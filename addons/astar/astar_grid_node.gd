class_name AStarGridNode
extends Object


var weight: float = 1.0

var links: Array = []


func get_link_to(node: AStarGridNode):
	
	for link in links:
		if link.to == node:
			return link
	return null


func get_weight() -> float:
	
	return weight
	


func add_link(edge):
	
	if get_link_to(edge.to) == null:
		links.append(edge)
	

func equals(other: AStarGridNode) -> bool:
	
	return self == other
	


func heuristic(goal: AStarGridNode, context: Dictionary) -> float:
	
	return 1.0
	
