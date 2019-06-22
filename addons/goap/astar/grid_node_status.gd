extends AStarGridNode

class_name AStarGoapGridNode


var state: Dictionary = {}

var action

func _init(a):
	self.action = a

func get_weight() -> float:
	if action != null:
		return .get_weight() + action.cost
	return .get_weight()

func check(conditions: Dictionary) -> bool:
	
	for key in conditions:
		
		if not state.has(key) or state[key] != conditions[key]:
			#print("check ", state, " with conditions: ", conditions, " => FALSE")
			return false
	#print("check ", state, " with conditions: ", conditions, " => TRUE")
	return true

func equals(other) -> bool:
	
	if self.state.size() != other.state.size():
		#print("equals : ", self.state, " <=> ", other.state, " ==> FALSE" )
		return false
	
	for key in self.state:
		
		if not other.state.has(key) or self.state[key] != other.state[key]:
			#print("equals : ", self.state, " <=> ", other.state, " ==> FALSE" )
			return false
	
	#print("equals : ", self.state, " <=> ", other.state, " ==> TRUE" )
	
	return true
	#return self.state == other.state

func heuristic(goal_node, context: Dictionary) -> float:
	
	var validation := 0
	
	for key in goal_node.state:
		if state.has(key) and state[key] == goal_node.state[key]:
			validation += 1
	
	var action_heuristic := 0.0
	if action != null:
		action_heuristic = action.heuristic(context)
	
	return .heuristic(goal_node, context) + (goal_node.state.size() - validation) + action_heuristic
