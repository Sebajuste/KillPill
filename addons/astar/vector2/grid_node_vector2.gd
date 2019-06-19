extends AStarGridNode

class_name AStarVector2GridNode

export var position: Vector2

func _init(p: Vector2):
	self.position = p

func equals(other) -> bool:
	return self.position == other.position

func heuristic(other) -> float:
	return .heuristic(other) + (position - other.position).length()
