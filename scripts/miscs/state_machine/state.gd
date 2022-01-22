tool
class_name State
extends Node


onready var state_machine: StateMachine = _get_state_machine(self)


var parent


# Called when the node enters the scene tree for the first time.
func _ready():
	#yield(owner, "ready")
	var local_parent = get_parent()
	if not local_parent.is_in_group("state_machine"):
		self.parent = local_parent


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(_delta):
	pass


func physics_process(_delta):
	pass


func unhandled_input(_event: InputEvent):
	pass


func enter(_msg: Dictionary = {}):
	pass


func exit():
	pass


func _get_state_machine(node: Node) -> Node:
	if node != null and not node.is_in_group("state_machine"):
		return _get_state_machine(node.get_parent())
	return node


func _get_configuration_warning() -> String:
	return "Missing StateMachine node" if not state_machine else ""
