class_name GoapStateMachine
extends StateMachine


signal on_actions_done
signal on_move_reached(result)


export(NodePath) var goap_planner_path


onready var goap_planner : Node = get_node(goap_planner_path)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
