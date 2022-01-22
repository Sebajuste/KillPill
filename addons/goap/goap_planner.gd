#tool
class_name GoapPlanner
extends Node


signal action_list_updated(action_list)


export var world_state: Dictionary = {}
export var goal_state: Dictionary = {}
export(NodePath) var goap_state_machine_path


onready var goap_state_machine = get_node(goap_state_machine_path)


func _init():
	
	add_to_group("goap_planner")
	


func _ready():
	for action in get_children():
		if action.is_valid():
			for key in action.get_preconditions():
				if not world_state.has(key):
					world_state[key] = false


func get_actions() -> Array:
	var actions = []
	for child in get_children():
		actions.append(child)
	return actions


func create_plan(context := {}) -> Array:
	
	var astar := AStarGoapGrid.new( get_actions() )
	
	var from = AStarGoapGridNode.new(null)
	from.state = world_state
	
	var to = AStarGoapGridNode.new(null)
	to.state = goal_state
	
	var path = astar.find_path(from, to, context)
	
	var action_list = []
	
	for next in path:
		if next.action != null:
			action_list.append(next.action)
	
	emit_signal("action_list_updated", action_list)
	
	return action_list
