extends Node


onready var ennemy = $Characters/Buddy

var ai_goal_set := false




# Called when the node enters the scene tree for the first time.
func _ready():
	
	NavigationManager.set_navigation($Environment/Navigation)
	
	"""
	$Characters/Buddy/ControlSM/Control/AI/GoapPlanner.goal_state = {
		"box_dropped": true,
		"near_constructor": true
	}
	"""
	
	
	var ai = ennemy.control_state_machine.get_node("Control/AI/")
	
	ai.goap_planner.goal_state = {
		#"attack": true,
		"builder_ready": true
	}
	
	Game.connect("level_node_created", self, "_on_level_node_created")
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	if ennemy.is_holding():
		var ai = ennemy.control_state_machine.get_node("Control/AI/")
		ai.goap_planner.goal_state = {
			"attack": true
		}
		
	
	
	pass

"""
func get_player_team_member():
	
	return $Characters/Player
	
"""


func _on_level_node_created(node: Node):
	
	$Objects.add_child(node)
	
