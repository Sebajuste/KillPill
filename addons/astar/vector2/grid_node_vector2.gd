extends AStarGridNode

class_name AStarVector2GridNode

export var position: Vector2

func _init(p: Vector2):
	
	self.position = p
	


func equals(other) -> bool:
	
	return self.position == other.position
	


func heuristic(goal, context: Dictionary) -> float:
	
	return .heuristic(goal, context) + (position - goal.position).length()
	
