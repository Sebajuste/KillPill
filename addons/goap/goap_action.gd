tool
extends Node

signal on_action_end

export var preconditions: Dictionary = {}
export var effects: Dictionary = {}
export var cost: float = 1.0

func is_reachable() -> bool:
	return true

func execute(actor):
	return false
