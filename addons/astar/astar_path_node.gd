class_name AStarPathNode
extends Object


var parent: AStarPathNode
var grid_node: AStarGridNode
var cost: float = 0.0
var priority: float = 0.0


func _init(p: AStarPathNode, n: AStarGridNode):
	self.parent = p
	self.grid_node = n
	self.cost = n.weight


func equals(other: AStarPathNode) -> bool:
	
	return other.grid_node == self.grid_node
	
