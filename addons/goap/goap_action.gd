tool
extends Node

signal on_action_end

export var preconditions: Dictionary = {}
export var effects: Dictionary = {}
export var cost: float = 1.0

func is_reachable(context: Dictionary) -> bool:
	return true

func heuristic(context: Dictionary) -> float:
	return 0.0

func cost(context: Dictionary) -> float:
	return 0.0

func execute(actor):
	return false
