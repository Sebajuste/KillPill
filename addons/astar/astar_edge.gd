class_name AStarEdge
extends Object


var to: AStarGridNode = null

var cost: float = 1.0


func _init(t: AStarGridNode, c: float=1.0):
	self.to = t
	self.cost = c
