#tool
class_name GoapAction
extends Node


signal on_action_end


export var action_resource : Resource

onready var goap_planner = _get_goap_planner(self)


func is_reachable(context: Dictionary) -> bool:
	return true


func heuristic(context: Dictionary) -> float:
	return 0.0


func cost(context: Dictionary) -> float:
	return 0.0


func execute(actor) -> bool:
	
	return false
	


func is_valid() -> bool:
	
	return action_resource != null
	


func get_preconditions() -> Dictionary:
	
	return action_resource.preconditions
	


func get_effects() -> Dictionary:
	
	return action_resource.effects
	


func is_effect(key: String) -> bool:
	
	return action_resource.effects[key]
	


func get_cost() -> float:
	
	return action_resource.cost
	


func _get_configuration_warning() -> String:
	
	return "Invalid Action Resource" if action_resource == null else ""
	


static func _get_goap_planner(node : Node) -> Node:
	var parent := node.get_parent()
	while parent != null and not parent.is_in_group("goap_planner"):
		parent = node.parent()
	return parent
