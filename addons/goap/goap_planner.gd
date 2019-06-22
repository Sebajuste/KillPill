tool
extends Node

signal on_action_list_updated


export var world_state: Dictionary = {}

export var goal_state: Dictionary = {}


func get_actions() -> Array:
	var actions = []
	
	for child in get_children():
		actions.append(child)
	
	return actions

func create_plan(context := {}) -> Array:
	
	var astar: AStarGoapGrid = AStarGoapGrid.new( get_actions() )
	
	var from = AStarGoapGridNode.new(null)
	from.state = world_state
	
	var to = AStarGoapGridNode.new(null)
	to.state = goal_state
	
	var path = astar.find_path(from, to, context)
	
	var action_list = []
	
	for next in path:
		if next.action != null:
			action_list.append(next.action)
	
	emit_signal("on_action_list_updated", action_list)
	
	return action_list

func _ready():
	
	for action in get_children():
		for key in action.preconditions:
			if not world_state.has(key):
				world_state[key] = false
	
